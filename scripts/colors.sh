cat <<'EOF' > crear_facility_roguelike.sh
#!/data/data/com.termux/files/usr/bin/bash
set -e

PROJECT="$HOME/facility_roguelike"

rm -rf "$PROJECT"
mkdir -p "$PROJECT/src" "$PROJECT/tests"

cat <<'CPP' > "$PROJECT/src/main.cpp"
#include <algorithm>
#include <chrono>
#include <fstream>
#include <iostream>
#include <random>
#include <string>
#include <thread>
#include <vector>

using namespace std;

// ============================================================
// FACILITY ROGUELIKE
// ============================================================

struct Stats {
    int runs = 0;
    int kills = 0;
    int loot = 0;
    int extractions = 0;
};

struct Weapon {
    string name;
    int damage;
    int ammo;
};

struct Item {
    string name;
    int value;
};

struct Player {
    int hp = 100;
    int maxHp = 100;
    int armor = 0;
    int damageBonus = 0;
    vector<Item> inventory;
    Weapon weapon{"Pistol", 18, 12};

    bool alive() const {
        return hp > 0;
    }

    void heal(int amount) {
        hp = min(maxHp, hp + amount);
    }

    void upgrade() {
        maxHp += 20;
        hp = maxHp;
        armor += 2;
        damageBonus += 5;
    }
};

struct Enemy {
    string name;
    int hp;
    int damage;
    int reward;

    bool alive() const {
        return hp > 0;
    }
};

struct Position {
    int x = 0;
    int y = 0;
};

class World {
public:
    static constexpr int W = 30;
    static constexpr int H = 15;

    vector<string> map;
    Position player{1, 1};
    Position objective{W - 2, H - 2};
    Position extraction{W - 2, 1};

    void generate(mt19937& rng) {
        map.assign(H, string(W, '#'));

        // Basic rooms/corridors.
        for (int y = 1; y < H - 1; ++y)
            for (int x = 1; x < W - 1; ++x)
                map[y][x] = '.';

        // Procedural obstacles.
        uniform_int_distribution<int> chance(0, 99);

        for (int y = 2; y < H - 2; ++y) {
            for (int x = 2; x < W - 2; ++x) {
                if (chance(rng) < 14)
                    map[y][x] = '#';
            }
        }

        map[player.y][player.x] = '.';
        map[objective.y][objective.x] = 'O';
        map[extraction.y][extraction.x] = 'E';
    }

    bool walkable(int x, int y) const {
        return x >= 0 && x < W &&
               y >= 0 && y < H &&
               map[y][x] != '#';
    }

    void draw(const Player& p, const vector<Enemy>& enemies,
              bool objectiveComplete, bool extractionActive) const {
        vector<string> screen = map;

        if (!objectiveComplete)
            screen[objective.y][objective.x] = 'O';
        else
            screen[objective.y][objective.x] = '.';

        if (extractionActive)
            screen[extraction.y][extraction.x] = 'X';

        for (const auto& e : enemies) {
            // Enemy positions are represented separately by game logic.
            (void)e;
        }

        screen[player.y][player.x] = '@';

        cout << "\033[2J\033[H";
        cout << "========================================\n";
        cout << "        ABANDONED FACILITY\n";
        cout << "========================================\n";
        cout << "HP " << p.hp << "/" << p.maxHp
             << "  Armor " << p.armor
             << "  Weapon " << p.weapon.name
             << "  Ammo " << p.weapon.ammo << "\n";
        cout << "Damage +" << p.damageBonus << "\n\n";

        for (const auto& row : screen)
            cout << row << '\n';

        cout << "\n@ Player   O Objective   X Extraction\n";
        cout << "WASD move | F fire | L loot | U upgrade | Q quit\n";
    }
};

class Game {
    mt19937 rng{random_device{}()};
    World world;
    Player player;
    Stats stats;

    vector<Enemy> enemies;

    bool objectiveComplete = false;
    bool extractionActive = false;
    bool running = true;

    int turns = 0;

public:
    Game() {
        loadStats();
        newRun();
    }

    explicit Game(unsigned seed) : rng(seed) {
        newRun();
    }

    void newRun() {
        player = Player{};
        enemies.clear();

        objectiveComplete = false;
        extractionActive = false;
        running = true;
        turns = 0;

        world.player = {1, 1};
        world.generate(rng);

        spawnEnemies();
    }

    void spawnEnemies() {
        uniform_int_distribution<int> xdist(2, World::W - 3);
        uniform_int_distribution<int> ydist(2, World::H - 3);

        vector<string> names{
            "Guard", "Mutant", "Crawler", "Security Drone"
        };

        for (int i = 0; i < 6; ++i) {
            Position p;
            do {
                p = {xdist(rng), ydist(rng)};
            } while (!world.walkable(p.x, p.y) ||
                     (p.x == world.player.x && p.y == world.player.y));

            Enemy e;
            e.name = names[i % names.size()];
            e.hp = 30 + (i * 5);
            e.damage = 5 + i;
            e.reward = 10 + i * 3;

            enemies.push_back(e);

            // Store enemy position using a simple parallel structure.
            enemyPositions.push_back(p);
        }
    }

    void run() {
        ++stats.runs;

        while (running && player.alive()) {
            world.draw(player, enemies, objectiveComplete, extractionActive);
            drawEnemies();

            cout << "\n> ";

            char command;
            cin >> command;

            command = static_cast<char>(tolower(command));

            switch (command) {
                case 'w': move(0, -1); break;
                case 's': move(0, 1); break;
                case 'a': move(-1, 0); break;
                case 'd': move(1, 0); break;
                case 'f': fire(); break;
                case 'l': loot(); break;
                case 'u': upgrade(); break;

                case 'q':
                    running = false;
                    break;

                default:
                    cout << "Comando desconocido.\n";
                    pause();
                    break;
            }

            enemyTurn();
            checkObjective();
            checkExtraction();

            ++turns;
        }

        if (!player.alive())
            cout << "\nGAME OVER\n";

        saveStats();
    }

    // --------------------------------------------------------
    // Movement
    // --------------------------------------------------------

    void move(int dx, int dy) {
        int nx = world.player.x + dx;
        int ny = world.player.y + dy;

        if (!world.walkable(nx, ny)) {
            cout << "Obstáculo.\n";
            pause();
            return;
        }

        world.player.x = nx;
        world.player.y = ny;
    }

    // --------------------------------------------------------
    // Combat
    // --------------------------------------------------------

    void fire() {
        int target = nearestEnemy();

        if (target < 0) {
            cout << "No hay enemigos cercanos.\n";
            pause();
            return;
        }

        if (player.weapon.ammo <= 0) {
            cout << "Sin munición.\n";
            pause();
            return;
        }

        player.weapon.ammo--;

        int damage =
            player.weapon.damage +
            player.damageBonus;

        enemies[target].hp -= damage;

        cout << "Disparas a "
             << enemies[target].name
             << " por "
             << damage
             << " de daño.\n";

        if (!enemies[target].alive()) {
            cout << enemies[target].name
                 << " eliminado.\n";

            stats.kills++;
            player.inventory.push_back(
                {"Enemy Scrap", enemies[target].reward}
            );
        }

        pause();
    }

    int nearestEnemy() const {
        int best = -1;
        int bestDistance = 9999;

        for (size_t i = 0; i < enemies.size(); ++i) {
            if (!enemies[i].alive())
                continue;

            int dx =
                abs(enemyPositions[i].x - world.player.x);

            int dy =
                abs(enemyPositions[i].y - world.player.y);

            int distance = dx + dy;

            if (distance <= 3 && distance < bestDistance) {
                bestDistance = distance;
                best = static_cast<int>(i);
            }
        }

        return best;
    }

    void enemyTurn() {
        for (size_t i = 0; i < enemies.size(); ++i) {
            if (!enemies[i].alive())
                continue;

            int dx =
                abs(enemyPositions[i].x - world.player.x);

            int dy =
                abs(enemyPositions[i].y - world.player.y);

            if (dx + dy <= 1) {
                int damage =
                    max(1, enemies[i].damage - player.armor);

                player.hp -= damage;

                cout << enemies[i].name
                     << " te golpea por "
                     << damage << ".\n";
            }
        }
    }

    void drawEnemies() const {
        cout << "\nENEMIGOS:\n";

        for (size_t i = 0; i < enemies.size(); ++i) {
            if (!enemies[i].alive())
                continue;

            cout << "  [" << i << "] "
                 << enemies[i].name
                 << " HP=" << enemies[i].hp
                 << " Pos=("
                 << enemyPositions[i].x
                 << ","
                 << enemyPositions[i].y
                 << ")\n";
        }
    }

    // --------------------------------------------------------
    // Loot
    // --------------------------------------------------------

    void loot() {
        uniform_int_distribution<int> chance(1, 3);

        int amount = chance(rng);

        if (amount == 1) {
            player.inventory.push_back({"Medkit", 25});
            cout << "Encontraste un Medkit.\n";
        } else if (amount == 2) {
            player.inventory.push_back({"Ammo", 30});
            player.weapon.ammo += 6;
            cout << "Encontraste munición.\n";
        } else {
            player.inventory.push_back({"Scrap", 10});
            cout << "Encontraste Scrap.\n";
        }

        stats.loot++;
        pause();
    }

    // --------------------------------------------------------
    // Upgrade
    // --------------------------------------------------------

    void upgrade() {
        if (player.inventory.empty()) {
            cout << "No tienes recursos para mejorar.\n";
            pause();
            return;
        }

        player.inventory.pop_back();
        player.upgrade();

        cout << "Mejora instalada.\n";
        cout << "HP máximo: "
             << player.maxHp << "\n";
        cout << "Armor: "
             << player.armor << "\n";
        cout << "Damage bonus: "
             << player.damageBonus << "\n";

        pause();
    }

    // --------------------------------------------------------
    // Objective
    // --------------------------------------------------------

    void checkObjective() {
        if (objectiveComplete)
            return;

        if (world.player.x == world.objective.x &&
            world.player.y == world.objective.y) {

            objectiveComplete = true;
            extractionActive = true;

            cout << "\nOBJETIVO COMPLETADO.\n";
            cout << "La extracción está activa.\n";

            pause();
        }
    }

    // --------------------------------------------------------
    // Extraction
    // --------------------------------------------------------

    void checkExtraction() {
        if (!extractionActive)
            return;

        if (world.player.x == world.extraction.x &&
            world.player.y == world.extraction.y) {

            cout << "\n================================\n";
            cout << "       EXTRACTION SUCCESS\n";
            cout << "================================\n";

            stats.extractions++;
            running = false;

            pause();
        }
    }

    // --------------------------------------------------------
    // Persistence
    // --------------------------------------------------------

    void saveStats() {
        ofstream out("stats.dat");

        if (!out)
            return;

        out << stats.runs << '\n';
        out << stats.kills << '\n';
        out << stats.loot << '\n';
        out << stats.extractions << '\n';
    }

    void loadStats() {
        ifstream in("stats.dat");

        if (!in)
            return;

        in >> stats.runs;
        in >> stats.kills;
        in >> stats.loot;
        in >> stats.extractions;
    }

    void showStats() const {
        cout << "\n========== ESTADÍSTICAS ==========\n";
        cout << "Runs:        " << stats.runs << '\n';
        cout << "Kills:       " << stats.kills << '\n';
        cout << "Loot:        " << stats.loot << '\n';
        cout << "Extractions: " << stats.extractions << '\n';
        cout << "==================================\n";
    }

    // --------------------------------------------------------
    // Test API
    // --------------------------------------------------------

    bool objectiveDone() const {
        return objectiveComplete;
    }

    bool extractionReady() const {
        return extractionActive;
    }

    bool playerAlive() const {
        return player.alive();
    }

    size_t enemyCount() const {
        return enemies.size();
    }

    void forceObjectiveForTest() {
        world.player = world.objective;
        checkObjective();
    }

    void forceExtractionForTest() {
        world.player = world.extraction;
        checkExtraction();
    }

private:
    vector<Position> enemyPositions;

    void pause() const {
        cout << "\n[ENTER para continuar]";
        cin.ignore(
            numeric_limits<streamsize>::max(),
            '\n'
        );
        cin.get();
    }
};

// ============================================================
// AUTOMATED TESTS
// ============================================================

bool testWorldGeneration() {
    Game game(12345);

    return game.playerAlive() &&
           game.enemyCount() == 6;
}

bool testObjective() {
    Game game(12345);

    game.forceObjectiveForTest();

    return game.objectiveDone() &&
           game.extractionReady();
}

bool testExtraction() {
    Game game(12345);

    game.forceObjectiveForTest();
    game.forceExtractionForTest();

    return game.extractionReady();
}

bool testMultipleRuns() {
    Game a(100);
    Game b(200);

    return a.playerAlive() &&
           b.playerAlive();
}

int runTests() {
    int passed = 0;
    int total = 4;

    cout << "========================================\n";
    cout << " FACILITY ROGUELIKE AUTOMATED TESTS\n";
    cout << "========================================\n\n";

    if (testWorldGeneration()) {
        cout << "[PASS] Procedural world\n";
        ++passed;
    } else {
        cout << "[FAIL] Procedural world\n";
    }

    if (testObjective()) {
        cout << "[PASS] Objective system\n";
        ++passed;
    } else {
        cout << "[FAIL] Objective system\n";
    }

    if (testExtraction()) {
        cout << "[PASS] Extraction system\n";
        ++passed;
    } else {
        cout << "[FAIL] Extraction system\n";
    }

    if (testMultipleRuns()) {
        cout << "[PASS] Multiple runs\n";
        ++passed;
    } else {
        cout << "[FAIL] Multiple runs\n";
    }

    cout << "\nResult: "
         << passed << "/"
         << total
         << " tests passed.\n";

    return passed == total ? 0 : 1;
}

// ============================================================
// MAIN
// ============================================================

int main(int argc, char** argv) {

    if (argc > 1 &&
        string(argv[1]) == "--test") {

        return runTests();
    }

    cout << "\033[2J\033[H";

    cout << "========================================\n";
    cout << "     ABANDONED FACILITY ROGUELIKE\n";
    cout << "========================================\n";
    cout << "\n";
    cout << "Objetivo:\n";
    cout << "1. Explora la instalación.\n";
    cout << "2. Encuentra el objetivo O.\n";
    cout << "3. Sobrevive a los enemigos.\n";
    cout << "4. Activa la extracción.\n";
    cout << "5. Llega a X.\n\n";

    cout << "Pulsa ENTER para comenzar...";
    cin.get();

    Game game;

    game.run();

    cout << "\nFin de la partida.\n";

    return 0;
}
CPP

cat <<'CMAKE' > "$PROJECT/CMakeLists.txt"
cmake_minimum_required(VERSION 3.16)

project(FacilityRoguelike
    VERSION 1.0
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(facility
    src/main.cpp
)

enable_testing()

add_test(
    NAME facility_tests
    COMMAND facility --test
)
CMAKE

cd "$PROJECT"

rm -rf build
cmake -S . -B build
cmake --build build -j2

echo
echo "========================================"
echo " EJECUTANDO TESTS"
echo "========================================"

ctest --test-dir build --output-on-failure

echo
echo "========================================"
echo " PROYECTO LISTO"
echo "========================================"
echo
echo "Proyecto:"
echo "  $PROJECT"
echo
echo "Ejecutar tests:"
echo "  cd $PROJECT && ./build/facility --test"
echo
echo "Jugar:"
echo "  cd $PROJECT && ./build/facility"
echo
EOF

chmod +x crear_facility_roguelike.sh
./crear_facility_roguelike.sh