import java.util.Scanner;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.IOException;
import java.time.LocalDateTime
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener
import javax.swing.*;
import java.awt.*;
import javax.swing.Timer;

public class DroneGui extends JFrame {
    private int battery = 100;
    private double altitude = 0.0;
    private boolean isFlying = false;

    // Componentes visuales
    private JLabel statusLabel;
    private JTextArea logArea;
    private JProgressBar batteryBar; // Nueva barra de progreso

    public DroneGui() {
        setTitle("Nokia Drone Phone 5G - Flight Control");
        setSize(450, 550);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLayout(new BorderLayout(10, 10));

        // 1. Panel Superior: Estado y Barra de Batería
        JPanel topPanel = new JPanel(new GridLayout(2, 1));
        statusLabel = new JLabel("Estado: En Tierra | Altitud: 0m", SwingConstants.CENTER);
        
        batteryBar = new JProgressBar(0, 100);
        batteryBar.setValue(100);
        batteryBar.setStringPainted(true); // Muestra el texto "%"
        batteryBar.setForeground(Color.GREEN);
        
        topPanel.add(statusLabel);
        topPanel.add(batteryBar);
        add(topPanel, BorderLayout.NORTH);

        // 2. Panel Central: Log
        logArea = new JTextArea();
        logArea.setEditable(false);
        add(new JScrollPane(logArea), BorderLayout.CENTER);

        // 3. Panel Inferior: Botones de colores
        JPanel buttonPanel = new JPanel(new GridLayout(2, 2, 5, 5));
        JButton btnTakeoff = createStyledButton("DESPEGAR", Color.GREEN);
        JButton btnLand = createStyledButton("ATERRIZAR", Color.RED);
        JButton btnPhoto = createStyledButton("FOTO", new Color(30, 144, 255));
        JButton btnCharge = createStyledButton("CARGAR", Color.YELLOW);

        buttonPanel.add(btnTakeoff);
        buttonPanel.add(btnLand);
        buttonPanel.add(btnPhoto);
        buttonPanel.add(btnCharge);
        add(buttonPanel, BorderLayout.SOUTH);

        // --- LÓGICA ---
        btnTakeoff.addActionListener(e -> {
            if (!isFlying && battery > 10) {
                isFlying = true;
                altitude = 2.0;
                consumeEnergy(10);
                updateUI("Despegue iniciado.");
            }
        });

        btnLand.addActionListener(e -> {
            if (isFlying) {
                isFlying = false;
                altitude = 0;
                updateUI("Aterrizaje completado.");
            }
        });

        btnCharge.addActionListener(e -> {
            if (!isFlying) {
                battery = 100;
                batteryBar.setValue(100);
                batteryBar.setForeground(Color.GREEN);
                updateUI("Batería recargada.");
            }
        });

        setVisible(true);
    }

    // Método auxiliar para crear botones con estilo
    private JButton createStyledButton(String text, Color bg) {
        JButton btn = new JButton(text);
        btn.setBackground(bg);
        btn.setOpaque(true);
        btn.setBorderPainted(false);
        return btn;
    }

    private void consumeEnergy(int amount) {
        battery -= amount;
        if (battery < 0) battery = 0;
        batteryBar.setValue(battery);
        
        // Cambiar color de la barra según nivel
        if (battery < 25) batteryBar.setForeground(Color.RED);
        else if (battery < 50) batteryBar.setForeground(Color.ORANGE);
    }

    private void updateUI(String msg) {
        statusLabel.setText(String.format("Estado: %s | Altitud: %.1fm", 
                            (isFlying ? "VOLANDO" : "TIERRA"), altitude));
        logArea.append("> " + msg + "\n");
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new DroneGui());
    }
}

public class DroneGui extends JFrame {
    // Variables del Drone
    private int battery = 100;
    private double altitude = 0.0;
    private boolean isFlying = false;

    // Elementos de la Interfaz
    private JLabel statusLabel;
    private JTextArea logArea;

    public DroneGui() {
        // Configuración de la Ventana
        setTitle("Nokia Drone Phone 5G - Panel de Control");
        setSize(400, 500);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLayout(new BorderLayout());

        // 1. Panel Superior: Estado
        statusLabel = new JLabel("Estado: En Tierra | Batería: 100% | Altitud: 0m", SwingConstants.CENTER);
        statusLabel.setFont(new Font("Arial", Font.BOLD, 14));
        add(statusLabel, BorderLayout.NORTH);

        // 2. Panel Central: Log de actividad
        logArea = new JTextArea();
        logArea.setEditable(false);
        add(new JScrollPane(logArea), BorderLayout.CENTER);

        // 3. Panel Inferior: Botones
        JPanel buttonPanel = new JPanel();
        buttonPanel.setLayout(new GridLayout(2, 2, 10, 10));

        JButton btnTakeoff = new JButton("DESPEGAR");
        JButton btnLand = new JButton("ATERRIZAR");
        JButton btnPhoto = new JButton("TOMAR FOTO");
        JButton btnCharge = new JButton("CARGAR");

        buttonPanel.add(btnTakeoff);
        buttonPanel.add(btnLand);
        buttonPanel.add(btnPhoto);
        buttonPanel.add(btnCharge);
        add(buttonPanel, BorderLayout.SOUTH);

        // --- LÓGICA DE LOS BOTONES ---

        btnTakeoff.addActionListener(e -> {
            if (!isFlying && battery > 10) {
                isFlying = true;
                altitude = 2.0;
                battery -= 5;
                updateUI("¡Despegue exitoso!");
            } else {
                updateUI("ERROR: No se puede despegar.");
            }
        });

        btnLand.addActionListener(e -> {
            if (isFlying) {
                isFlying = false;
                altitude = 0;
                updateUI("Drone aterrizado.");
            }
        });

        btnPhoto.addActionListener(e -> {
            if (isFlying && altitude >= 2.0) {
                battery -= 3;
                updateUI("FOTO CAPTURADA Y ENVIADA POR 5G.");
            } else {
                updateUI("ERROR: El drone debe estar en el aire.");
            }
        });

        btnCharge.addActionListener(e -> {
            if (!isFlying) {
                battery = 100;
                updateUI("Batería cargada al 100%.");
            } else {
                updateUI("ERROR: ¡No cargues en pleno vuelo!");
            }
        });

        setVisible(true);
    }

    private void updateUI(String message) {
        statusLabel.setText(String.format("Estado: %s | Batería: %d%% | Alt: %.1fm", 
                            (isFlying ? "VOLANDO" : "TIERRA"), battery, altitude));
        logArea.append("> " + message + "\n");
    }

    public static void main(String[] args) {
        // Ejecutar la interfaz en el hilo de despacho de eventos
        SwingUtilities.invokeLater(() -> new DroneGui());
    }
}
// Interfaz para definir el comportamiento de vuelo
interface FlightControl {
    void takeoff();
    void land();
    void moveTo(double x, double y, double z);
}

// Clase principal del dispositivo
class NokiaDronePhone implements FlightControl {
    private String model = "Nokia Drone Phone 5G";
    private int batteryLevel = 100;
    private boolean isFlying = false;

    // Simulación de conexión 5G
    public void check5GConnection() {
        System.out.println("Conectando a red 5G de baja latencia...");
        System.out.println("Señal estable. Latencia: 1ms");
    }

    @Override
    public void takeoff() {
        if (!isFlying && batteryLevel > 10) {
            isFlying = true;
            System.out.println(model + " iniciando motores y despegando.");
        } else {
            System.out.println("Batería insuficiente o ya en vuelo.");
        }
    }

    @Override
    public void land() {
        if (isFlying) {
            isFlying = false;
            System.out.println(model + " descendiendo de forma segura.");
        }
    }

    @Override
    public void moveTo(double x, double y, double z) {
        if (isFlying) {
            System.out.println("Moviendo drone a coordenadas: X:" + x + " Y:" + y + " Z:" + z);
        } else {
            System.out.println("Error: El dispositivo debe estar en el aire para moverse.");
        }
    }
}

// Clase para ejecutar la prueba
public class DroneProject {
    public static void main(String[] args) {
        NokiaDronePhone myDrone = new NokiaDronePhone();

        // Ejecución de tareas
        myDrone.check5GConnection();
        myDrone.takeoff();
        myDrone.moveTo(10.5, 20.0, 5.0);
        myDrone.land();
    }
}
interface FlightControl {
    void takeoff();
    void land();
    void moveTo(double x, double y, double z);
    void takeSnapshot(); // Nueva funcionalidad
}

class NokiaDronePhone implements FlightControl {
    private String model = "Nokia Drone Phone 5G";
    private double currentAltitude = 0.0;
    private boolean isFlying = false;

    @Override
    public void takeoff() {
        if (!isFlying) {
            isFlying = true;
            currentAltitude = 2.0; // Despega a 2 metros por defecto
            System.out.println(model + " en el aire a " + currentAltitude + "m.");
        }
    }

    @Override
    public void moveTo(double x, double y, double z) {
        if (isFlying) {
            this.currentAltitude = z;
            System.out.println("Navegando a Altura: " + z + "m");
        }
    }

    @Override
    public void takeSnapshot() {
        if (isFlying && currentAltitude >= 5.0) {
            System.out.println("[CÁMARA] Capturando foto de alta resolución a " + currentAltitude + "m...");
            System.out.println("[5G] Enviando imagen a la nube Nokia en tiempo real...");
        } else if (!isFlying) {
            System.out.println("Error: El drone está en el suelo.");
        } else {
            System.out.println("Error: Altura insuficiente para foto panorámica (mínimo 5m).");
        }
    }

    @Override
    public void land() {
        if (isFlying) {
            isFlying = false;
            currentAltitude = 0;
            System.out.println(model + " ha aterrizado.");
        }
    }
}

public class DroneProject {
    public static void main(String[] args) {
        NokiaDronePhone myDrone = new NokiaDronePhone();

        myDrone.takeoff();
        
        // Intentar tomar foto a baja altura (fallará)
        myDrone.takeSnapshot(); 

        // Subir y tomar foto (tendrá éxito)
        myDrone.moveTo(0, 0, 8.5); 
        myDrone.takeSnapshot();

        myDrone.land();
    }
}
interface FlightControl {
    void takeoff();
    void land();
    void moveTo(double x, double y, double z);
    void takeSnapshot();
}

class NokiaDronePhone implements FlightControl {
    private String model = "Nokia Drone Phone 5G";
    private double currentAltitude = 0.0;
    private boolean isFlying = false;
    private boolean has5GSignal = true; // Estado de la conexión

    // Método para simular pérdida de señal externa
    public void simulateSignalLoss() {
        System.out.println("\n[ALERTA] !!! SEÑAL 5G PERDIDA !!!");
        this.has5GSignal = false;
        emergencyProcedure();
    }

    private void emergencyProcedure() {
        if (isFlying) {
            System.out.println("[SEGURIDAD] Iniciando protocolo de aterrizaje automático por pérdida de enlace...");
            land();
        }
    }

    @Override
    public void takeoff() {
        if (has5GSignal && !isFlying) {
            isFlying = true;
            currentAltitude = 2.0;
            System.out.println(model + " despechando exitosamente.");
        } else {
            System.out.println("Error: No se puede despegar sin señal o ya está en vuelo.");
        }
    }

    @Override
    public void moveTo(double x, double y, double z) {
        if (has5GSignal && isFlying) {
            this.currentAltitude = z;
            System.out.println("Navegando a
interface FlightControl {
    void takeoff();
    void land();
    void moveTo(double z);
    void takeSnapshot();
}

class NokiaDronePhone implements FlightControl {
    private double currentAltitude = 0.0;
    private boolean isFlying = false;

    @Override
    public void takeoff() {
        if (!isFlying) {
            isFlying = true;
            currentAltitude = 2.0;
            System.out.println("[SISTEMA] Motores encendidos. Altura actual: " + currentAltitude + "m");
        } else {
            System.out.println("[ERROR] El drone ya está en el aire.");
        }
    }

    @Override
    public void moveTo(double z) {
        if (isFlying) {
            this.currentAltitude = z;
            System.out.println("[SISTEMA] Ajustando altitud a: " + z + "m");
        } else {
            System.out.println("[ERROR] Debe despegar primero.");
        }
    }

    @Override
    public void takeSnapshot() {
        if (isFlying && currentAltitude >= 5.0) {
            System.out.println("[CÁMARA] ¡Foto capturada a " + currentAltitude + "m! Enviando por 5G...");
        } else {
            System.out.println("[AVISO] No se pudo tomar la foto. Verifique que la altura sea mayor a 5m.");
        }
    }

    @Override
    public void land() {
        if (isFlying) {
            isFlying = false;
            currentAltitude = 0;
            System.out.println("[SISTEMA] Aterrizaje completado con éxito.");
        }
    }
}

public class DroneProject {
    public static void main(String[] args) {
        NokiaDronePhone myDrone = new NokiaDronePhone();
        Scanner reader = new Scanner(System.in);
        String command = "";

        System.out.println("--- Panel de Control Nokia Drone Phone 5G ---");
        System.out.println("Comandos: despegar, subir, foto, aterrizar, salir");

        while (!command.equals("salir")) {
            System.out.print("\nIngrese comando > ");
            command = reader.nextLine().toLowerCase();

            switch (command) {
                case "despegar":
                    myDrone.takeoff();
                    break;
                case "subir":
                    System.out.print("¿A qué altura (metros)?: ");
                    double alt = reader.nextDouble();
                    reader.nextLine(); // Limpiar el buffer
                    myDrone.moveTo(alt);
                    break;
                case "foto":
                    myDrone.takeSnapshot();
                    break;
                case "aterrizar":
                    myDrone.land();
                    break;
                case "salir":
                    System.out.println("Cerrando conexión 5G... ¡Adiós!");
                    break;
                default:
                    System.out.println("Comando no reconocido.");
            }
        }
        reader.close();
    }
}
interface FlightControl {
    void takeoff();
    void land();
    void moveTo(double z);
    void takeSnapshot();
}

class NokiaDronePhone implements FlightControl {
    private double currentAltitude = 0.0;
    private boolean isFlying = false;
    private int batteryLife = 100; // Nueva variable de energía

    // Método interno para reducir batería y verificar estado crítico
    private void consumeBattery(int amount) {
        batteryLife -= amount;
        if (batteryLife < 0) batteryLife = 0;
        
        System.out.println("[ENERGÍA] Nivel actual: " + batteryLife + "%");

        if (batteryLife <= 5 && isFlying) {
            System.out.println("[CRÍTICO] Batería al 5%. Iniciando aterrizaje de emergencia...");
            land();
        } else if (batteryLife <= 20) {
            System.out.println("[ALERTA] Batería baja. Por favor, regrese al punto de inicio.");
        }
    }

    @Override
    public void takeoff() {
        if (!isFlying && batteryLife > 10) {
            isFlying = true;
            currentAltitude = 2.0;
            System.out.println("[SISTEMA] Despeje exitoso.");
            consumeBattery(5); // El despegue consume más energía
        } else {
            System.out.println("[ERROR] Batería insuficiente para despegar.");
        }
    }

    @Override
    public void moveTo(double z) {
        if (isFlying) {
            this.currentAltitude = z;
            System.out.println("[SISTEMA] Volando a " + z + "m.");
            consumeBattery(2); // Moverse consume energía constante
        }
    }

    @Override
    public void takeSnapshot() {
        if (isFlying && currentAltitude >= 5.0) {
            System.out.println("[CÁMARA] Procesando foto 5G...");
            consumeBattery(3); // El procesamiento de imagen consume energía
        }
    }

    @Override
    public void land() {
        if (isFlying) {
            isFlying = false;
            currentAltitude = 0;
            System.out.println("[SISTEMA] Drone en tierra. Motores apagados.");
        }
    }
}

public class DroneProject {
    public static void main(String[] args) {
        NokiaDronePhone myDrone = new NokiaDronePhone();
        Scanner reader = new Scanner(System.in);
        String command = "";

        System.out.println("--- Panel Nokia Drone 5G (v2.0 - Gestión de Energía) ---");

        while (!command.equals("salir")) {
            System.out.print("\nComando (despegar, subir, foto, aterrizar, salir) > ");
            command = reader.nextLine().toLowerCase();

            switch (command) {
                case "despegar": myDrone.takeoff(); break;
                case "subir":
                    System.out.print("Altura: ");
                    double alt = reader.nextDouble();
                    reader.nextLine();
                    myDrone.moveTo(alt);
                    break;
                case "foto": myDrone.takeSnapshot(); break;
                case "aterrizar": myDrone.land(); break;
                case "salir": System.out.println("Cerrando..."); break;
                default: System.out.println("Comando inválido.");
            }
        }
        reader.close();
    }
}
class NokiaDronePhone {
    private double currentAltitude = 0.0;
    private boolean isFlying = false;
    private int batteryLife = 100;
    private final String LOG_FILE = "vuelo_log.txt";

    // Método para escribir en el archivo de texto
    private void logAction(String action) {
        try (FileWriter fw = new FileWriter(LOG_FILE, true);
             PrintWriter pw = new PrintWriter(fw)) {
            String timestamp = LocalDateTime.now().toString();
            pw.println("[" + timestamp + "] " + action + " | Batería: " + batteryLife + "%");
        } catch (IOException e) {
            System.out.println("[ERROR] No se pudo escribir en el log: " + e.getMessage());
        }
    }

    private void consumeBattery(int amount) {
        batteryLife -= amount;
        if (batteryLife < 0) batteryLife = 0;
        
        System.out.println("[ENERGÍA] " + batteryLife + "%");
        if (batteryLife <= 5 && isFlying) {
            logAction("ATERRIZAJE FORZOSO POR BATERÍA CRÍTICA");
            land();
        }
    }

    public void takeoff() {
        if (!isFlying && batteryLife > 10) {
            isFlying = true;
            currentAltitude = 2.0;
            System.out.println("[SISTEMA] Despeje.");
            logAction("DESPEGE EXITOSO");
            consumeBattery(5);
        }
    }

    public void moveTo(double z) {
        if (isFlying) {
            this.currentAltitude = z;
            System.out.println("[SISTEMA] Altura: " + z + "m");
            logAction("CAMBIO ALTITUD A " + z + "m");
            consumeBattery(2);
        }
    }

    public void takeSnapshot() {
        if (isFlying && currentAltitude >= 5.0) {
            System.out.println("[CÁMARA] Foto capturada.");
            logAction("FOTO TOMADA A " + currentAltitude + "m");
            consumeBattery(3);
        }
    }

    public void land() {
        if (isFlying) {
            isFlying = false;
            currentAltitude = 0;
            System.out.println("[SISTEMA] Aterrizado.");
            logAction("ATERRIZAJE MANUAL");
        }
    }
}

public class DroneProject {
    public static void main(String[] args) {
        NokiaDronePhone myDrone = new NokiaDronePhone();
        Scanner reader = new Scanner(System.in);
        String command = "";

        System.out.println("--- Nokia Drone 5G (v3.0 - Log de Vuelo Activo) ---");

        while (!command.equals("salir")) {
            System.out.print("\nComando > ");
            command = reader.nextLine().toLowerCase();

            switch (command) {
                case "despegar": myDrone.takeoff(); break;
                case "subir":
                    System.out.print("Altura: ");
                    double alt = reader.nextDouble(); reader.nextLine();
                    myDrone.moveTo(alt);
                    break;
                case "foto": myDrone.takeSnapshot(); break;
                case "aterrizar": myDrone.land(); break;
                case "salir": break;
                default: System.out.println("Comando inválido.");
            }
        }
        reader.close();
    }
}
class NokiaDronePhone {
    private double currentAltitude = 0.0;
    private boolean isFlying = false;
    private int batteryLife = 100;
    private final String LOG_FILE = "vuelo_log.txt";
    private Random random = new Random();

    private void logAction(String action) {
        try (FileWriter fw = new FileWriter(LOG_FILE, true);
             PrintWriter pw = new PrintWriter(fw)) {
            pw.println("[" + LocalDateTime.now() + "] " + action + " | Bat: " + batteryLife + "%");
        } catch (IOException e) {
            System.out.println("[ERROR LOG]");
        }
    }

    // Nuevo método para verificar el clima
    private boolean isWeatherSafe() {
        int windSpeed = random.nextInt(50); // Genera viento de 0 a 49 km/h
        System.out.println("[METEOROLOGÍA] Viento detectado: " + windSpeed + " km/h");
        
        if (windSpeed > 25) {
            System.out.println("[PELIGRO] Viento demasiado fuerte. Despegue cancelado por seguridad.");
            logAction("DESPEGUE ABORTADO: Viento de " + windSpeed + " km/h");
            return false;
        }
        System.out.println("[OK] Condiciones climáticas óptimas.");
        return true;
    }

    public void takeoff() {
        if (!isFlying && batteryLife > 10) {
            // Solo despega si el clima es seguro
            if (isWeatherSafe()) {
                isFlying = true;
                currentAltitude = 2.0;
                System.out.println("[SISTEMA] En el aire.");
                logAction("DESPEGUE EXITOSO");
                batteryLife -= 5;
            }
        } else {
            System.out.println("[ERROR] No se puede despegar (Batería baja o ya en vuelo).");
        }
    }

    public void moveTo(double z) {
        if (isFlying) {
            this.currentAltitude = z;
            System.out.println("[SISTEMA] Altitud: " + z + "m");
            logAction("MOVIMIENTO A " + z + "m");
            batteryLife -= 2;
        }
    }

    public void land() {
        if (isFlying) {
            isFlying = false;
            currentAltitude = 0;
            System.out.println("[SISTEMA] Aterrizado.");
            logAction("ATERRIZAJE");
        }
    }
}

public class DroneProject {
    public static void main(String[] args) {
        NokiaDronePhone myDrone = new NokiaDronePhone();
        Scanner reader = new Scanner(System.in);
        String command = "";

        System.out.println("--- Nokia Drone 5G (v4.0 - Sensor de Viento) ---");

        while (!command.equals("salir")) {
            System.out.print("\nComando (despegar, subir, aterrizar, salir) > ");
            command = reader.nextLine().toLowerCase();

            switch (command) {
                case "despegar": myDrone.takeoff(); break;
                case "subir":
                    System.out.print("Altura: ");
                    double alt = reader.nextDouble(); reader.nextLine();
                    myDrone.moveTo(alt);
                    break;
                case "aterrizar": myDrone.land(); break;
                case "salir": break;
                default: System.out.println("Comando no reconocido.");
            }
        }
        reader.close();
    }
}
class NokiaDronePhone {
    private double currentAltitude = 0.0;
    private boolean isFlying = false;
    private int batteryLife = 100;
    private final String LOG_FILE = "vuelo_log.txt";
    private Random random = new Random();

    private void logAction(String action) {
        try (FileWriter fw = new FileWriter(LOG_FILE, true);
             PrintWriter pw = new PrintWriter(fw)) {
            pw.println("[" + LocalDateTime.now() + "] " + action + " | Bat: " + batteryLife + "%");
        } catch (IOException e) {
            System.out.println("[ERROR LOG]");
        }
    }

    // Nuevo método para detectar si es de noche
    private void checkNightMode() {
        LocalTime now = LocalTime.now();
        // Definimos la noche de 18:00 a 06:00
        if (now.isAfter(LocalTime.of(18, 0)) || now.isBefore(LocalTime.of(6, 0))) {
            System.out.println("[SENSOR] Poca luz detectada. ACTIVANDO LUCES LED NOCTURNAS.");
            logAction("LUCES LED: ENCENDIDAS (MODO NOCTURNO)");
        } else {
            System.out.println("[SENSOR] Luz diurna detectada. Luces LED en modo ahorro.");
        }
    }

    private boolean isWeatherSafe() {
        int windSpeed = random.nextInt(50);
        System.out.println("[METEOROLOGÍA] Viento: " + windSpeed + " km/h");
        return windSpeed <= 25;
    }

    public void takeoff() {
        if (!isFlying && batteryLife > 10) {
            checkNightMode(); // Verificamos luces al despegar
            if (isWeatherSafe()) {
                isFlying = true;
                currentAltitude = 2.0;
                System.out.println("[SISTEMA] En el aire.");
                logAction("DESPEGUE EXITOSO");
                batteryLife -= 5;
            } else {
                System.out.println("[PELIGRO] Viento fuerte. Abortando.");
            }
        }
    }

    public void moveTo(double z) {
        if (isFlying) {
            this.currentAltitude = z;
            System.out.println("[SISTEMA] Altura: " + z + "m");
            batteryLife -= 2;
        }
    }

    public void land() {
        if (isFlying) {
            isFlying = false;
            currentAltitude = 0;
            System.out.println("[SISTEMA] Aterrizado.");
            logAction("ATERRIZAJE");
        }
    }
}

public class DroneProject {
    public static void main(String[] args) {
        NokiaDronePhone myDrone = new NokiaDronePhone();
        Scanner reader = new Scanner(System.in);
        String command = "";

        System.out.println("--- Nokia Drone 5G (v5.0 - Sensor de Luz) ---");

        while (!command.equals("salir")) {
            System.out.print("\nComando (despegar, subir, aterrizar, salir) > ");
            command = reader.nextLine().toLowerCase();

            switch (command) {
                case "despegar": myDrone.takeoff(); break;
                case "subir":
                    System.out.print("Altura: ");
                    double alt = reader.nextDouble(); reader.nextLine();
                    myDrone.moveTo(alt);
                    break;
                case "aterrizar": myDrone.land(); break;
                case "salir": break;
                default: System.out.println("Comando inválido.");
            }
        }
        reader.close();
    }
}

class NokiaDronePhone {
    private double posX = 0.0, posY = 0.0, posZ = 0.0; // Coordenadas GPS
    private boolean isFlying = false;
    private int batteryLife = 100;
    private final String LOG_FILE = "vuelo_log.txt";

    private void logAction(String action) {
        try (FileWriter fw = new FileWriter(LOG_FILE, true);
             PrintWriter pw = new PrintWriter(fw)) {
            pw.println("[" + LocalDateTime.now() + "] " + action + " | GPS:(" + posX + "," + posY + ") | Bat: " + batteryLife + "%");
        } catch (IOException e) { System.out.println("[ERROR LOG]"); }
    }

    // Método para calcular distancia al punto de inicio (0,0)
    public double getDistanceFromHome() {
        return Math.sqrt(Math.pow(posX, 2) + Math.pow(posY, 2));
    }

    public void takeoff() {
        if (!isFlying && batteryLife > 10) {
            isFlying = true;
            posZ = 2.0;
            System.out.println("[GPS] Punto de inicio fijado en (0,0).");
            logAction("DESPEGUE");
            batteryLife -= 5;
        }
    }

    public void moveGPS(double x, double y, double z) {
        if (isFlying) {
            this.posX = x;
            this.posY = y;
            this.posZ = z;
            
            double dist = getDistanceFromHome();
            System.out.printf("[GPS] Nueva posición: (%.1f, %.1f) | Altura: %.1f m\n", posX, posY, posZ);
            System.out.printf("[GPS] Distancia a casa: %.2f metros\n", dist);

            if (dist > 100) {
                System.out.println("[ALERTA] Límite de rango 5G alcanzado (100m).");
            }
            
            logAction("MOVIMIENTO GPS");
            batteryLife -= 3;
        } else {
            System.out.println("[ERROR] El drone está en el suelo.");
        }
    }

    public void land() {
        if (isFlying) {
            isFlying = false;
            posZ = 0;
            System.out.println("[SISTEMA] Aterrizado en: (" + posX + ", " + posY + ")");
            logAction("ATERRIZAJE");
        }
    }
}

public class DroneProject {
    public static void main(String[] args) {
        NokiaDronePhone myDrone = new NokiaDronePhone();
        Scanner reader = new Scanner(System.in);
        String command = "";

        System.out.println("--- Nokia Drone 5G (v6.0 - Geolocalización GPS) ---");

        while (!command.equals("salir")) {
            System.out.print("\nComando (despegar, mover, aterrizar, salir) > ");
            command = reader.nextLine().toLowerCase();

            switch (command) {
                case "despegar": myDrone.takeoff(); break;
                case "mover":
                    System.out.print("Coordenada X: "); double x = reader.nextDouble();
                    System.out.print("Coordenada Y: "); double y = reader.nextDouble();
                    System.out.print("Altura Z: "); double z = reader.nextDouble();
                    reader.nextLine(); // Limpiar buffer
                    myDrone.moveGPS(x, y, z);
                    break;
                case "aterrizar": myDrone.land(); break;
                case "salir": break;
                default: System.out.println("Comando no reconocido.");
            }
        }
        reader.close();
    }
}
class NokiaDronePhone {
    private double posX = 0.0, posY = 0.0, posZ = 0.0;
    private boolean isFlying = false;
    private int batteryLife = 100;
    private final String LOG_FILE = "vuelo_log.txt";

    private void logAction(String action) {
        try (FileWriter fw = new FileWriter(LOG_FILE, true);
             PrintWriter pw = new PrintWriter(fw)) {
            pw.println("[" + LocalDateTime.now() + "] " + action + " | Pos:(" + posX + "," + posY + ") | Bat: " + batteryLife + "%");
        } catch (IOException e) { System.out.println("[ERROR LOG]"); }
    }

    // --- NUEVO MÉTODO: RETURN TO HOME ---
    public void returnToHome() {
        if (!isFlying) {
            System.out.println("[ERROR] El drone ya está en tierra.");
            return;
        }

        System.out.println("\n[SISTEMA] !!! RTH ACTIVADO !!!");
        System.out.println("[GPS] Calculando ruta de regreso al punto (0,0)...");

        // Simulamos el trayecto de regreso
        this.posX = 0.0;
        this.posY = 0.0;
        this.posZ = 2.0; // Baja a altura de seguridad antes de aterrizar

        System.out.println("[GPS] Llegada a punto de inicio confirmada.");
        logAction("EJECUTADO RETURN TO HOME (RTH)");
        
        land(); // Aterrizaje automático al llegar
    }

    public void takeoff() {
        if (!isFlying && batteryLife > 10) {
            isFlying = true;
            posZ = 2.0;
            System.out.println("[SISTEMA] Despeje completado.");
            logAction("DESPEGUE");
            batteryLife -= 5;
        }
    }

    public void moveGPS(double x, double y, double z) {
        if (isFlying) {
            this.posX = x; this.posY = y; this.posZ = z;
            System.out.printf("[GPS] Ubicación: (%.1f, %.1f) Altura: %.1f m\n", posX, posY, posZ);
            batteryLife -= 3;
        }
    }

    public void land() {
        if (isFlying) {
            isFlying = false;
            posX = 0; posY = 0; posZ = 0;
            System.out.println("[SISTEMA] Motores apagados. Drone a salvo.");
        }
    }
}

public class DroneProject {
    public static void main(String[] args) {
        NokiaDronePhone myDrone = new NokiaDronePhone();
        Scanner reader = new Scanner(System.in);
        String command = "";

        System.out.println("--- Nokia Drone 5G (v7.0 - Sistema RTH) ---");

        while (!command.equals("salir")) {
            System.out.print("\nComando (despegar, mover, rth, salir) > ");
            command = reader.nextLine().toLowerCase();

            switch (command) {
                case "despegar": myDrone.takeoff(); break;
                case "mover":
                    System.out.print("X: "); double x = reader.nextDouble();
                    System.out.print("Y: "); double y = reader.nextDouble();
                    System.out.print("Z: "); double z = reader.nextDouble();
                    reader.nextLine();
                    myDrone.moveGPS(x, y, z);
                    break;
                case "rth":
                    myDrone.returnToHome();
                    break;
                case "salir": break;
                default: System.out.println("Comando no reconocido.");
            }
        }
        reader.close();
    }
}
class NokiaDronePhone {
    private double posX = 0.0, posY = 0.0, posZ = 0.0;
    private boolean isFlying = false;
    private int batteryLife = 100;
    private Random sensorSim = new Random();
    private final String LOG_FILE = "vuelo_log.txt";

    private void logAction(String action) {
        try (FileWriter fw = new FileWriter(LOG_FILE, true);
             PrintWriter pw = new PrintWriter(fw)) {
            pw.println("[" + LocalDateTime.now() + "] " + action + " | Bat: " + batteryLife + "%");
        } catch (IOException e) { System.out.println("[ERR LOG]"); }
    }

    // --- NUEVO MÉTODO: ESCÁNER DE PROXIMIDAD ---
    private boolean isPathClear() {
        // Simula la lectura de un sensor LiDAR (distancia en metros)
        double distanceToObstacle = 1.0 + (10.0 - 1.0) * sensorSim.nextDouble();
        
        System.out.printf("[SENSORES] Escaneando entorno... Objeto más cercano a: %.2f m\n", distanceToObstacle);

        if (distanceToObstacle < 2.0) {
            System.out.println("[ALERTA] ¡OBSTÁCULO DETECTADO! Maniobra de frenado activo.");
            logAction("EVITACIÓN DE COLISIÓN ACTIVADA");
            return false;
        }
        return true;
    }

    public void takeoff() {
        if (!isFlying && batteryLife > 10) {
            isFlying = true;
            posZ = 2.0;
            System.out.println("[SISTEMA] Drone en el aire.");
            logAction("DESPEGUE");
            batteryLife -= 5;
        }
    }

    public void moveGPS(double x, double y, double z) {
        if (isFlying) {
            // Antes de mover, verificamos si el camino está despejado
            if (isPathClear()) {
                this.posX = x; this.posY = y; this.posZ = z;
                System.out.printf("[SISTEMA] Movimiento exitoso a (%.1f, %.1f, %.1f)\n", posX, posY, posZ);
                batteryLife -= 3;
            } else {
                System.out.println("[SISTEMA] Movimiento cancelado para evitar choque.");
            }
        }
    }

    public void land() {
        if (isFlying) {
            isFlying = false;
            System.out.println("[SISTEMA] Aterrizado.");
            logAction("ATERRIZAJE");
        }
    }
}

public class DroneProject {
    public static void main(String[] args) {
        NokiaDronePhone myDrone = new NokiaDronePhone();
        Scanner reader = new Scanner(System.in);
        String command = "";

        System.out.println("--- Nokia Drone 5G (v8.0 - Escáner de Obstáculos) ---");

        while (!command.equals("salir")) {
            System.out.print("\nComando (despegar, mover, aterrizar, salir) > ");
            command = reader.nextLine().toLowerCase();

            switch (command) {
                case "despegar": myDrone.takeoff(); break;
                case "mover":
                    System.out.print("Nueva X: "); double x = reader.nextDouble();
                    System.out.print("Nueva Y: "); double y = reader.nextDouble();
                    System.out.print("Nueva Z: "); double z = reader.nextDouble();
                    reader.nextLine();
                    myDrone.moveGPS(x, y, z);
                    break;
                case "aterrizar": myDrone.land(); break;
                case "salir": break;
                default: System.out.println("Comando inválido.");
            }
        }
        reader.close();
    }
}
class NokiaDronePhone {
    private double posX = 0.0, posY = 0.0, posZ = 0.0;
    private boolean isFlying = false;
    private int batteryLife = 100;
    private final String LOG_FILE = "vuelo_log.txt";

    private void logAction(String action) {
        try (FileWriter fw = new FileWriter(LOG_FILE, true);
             PrintWriter pw = new PrintWriter(fw)) {
            pw.println("[" + LocalDateTime.now() + "] " + action + " | Bat: " + batteryLife + "%");
        } catch (IOException e) { System.out.println("[ERR LOG]"); }
    }

    // --- NUEVO MÉTODO: CARGA RÁPIDA ---
    public void chargeBattery() {
        if (isFlying) {
            System.out.println("[CRÍTICO] ¡No se puede cargar mientras el drone está volando!");
            logAction("INTENTO DE CARGA FALLIDO (EN VUELO)");
        } else {
            System.out.println("[SISTEMA] Conectado a base Nokia Fast Charge...");
            batteryLife = 100;
            System.out.println("[SISTEMA] Batería cargada al 100%. Listo para la misión.");
            logAction("BATERÍA CARGADA AL 100%");
        }
    }

    public void takeoff() {
        if (!isFlying && batteryLife > 10) {
            isFlying = true;
            posZ = 2.0;
            System.out.println("[SISTEMA] Despegue exitoso. Batería: " + batteryLife + "%");
            logAction("DESPEGUE");
            batteryLife -= 5;
        } else {
            System.out.println("[ERROR] Batería baja o ya en vuelo.");
        }
    }

    public void land() {
        if (isFlying) {
            isFlying = false;
            posX = 0; posY = 0; posZ = 0;
            System.out.println("[SISTEMA] Drone en tierra.");
            logAction("ATERRIZAJE");
        }
    }

    public void status() {
        System.out.println("\n--- ESTADO DEL DISPOSITIVO ---");
        System.out.println("Modelo: Nokia Drone Phone 5G");
        System.out.println("Batería: " + batteryLife + "%");
        System.out.println("Estado: " + (isFlying ? "En vuelo" : "En tierra"));
        System.out.println("Posición: (" + posX + ", " + posY + ", " + posZ + ")");
    }
}

public class DroneProject {
    public static void main(String[] args) {
        NokiaDronePhone myDrone = new NokiaDronePhone();
        Scanner reader = new Scanner(System.in);
        String command = "";

        System.out.println("--- Nokia Drone 5G (v9.0 - Sistema de Carga) ---");

        while (!command.equals("salir")) {
            System.out.print("\nComando (despegar, aterrizar, cargar, estado, salir) > ");
            command = reader.nextLine().toLowerCase();

            switch (command) {
                case "despegar": myDrone.takeoff(); break;
                case "aterrizar": myDrone.land(); break;
                case "cargar": myDrone.chargeBattery(); break;
                case "estado": myDrone.status(); break;
                case "salir": break;
                default: System.out.println("Comando no reconocido.");
            }
        }
        reader.close();
    }
}
class NokiaDronePhone {
    private boolean isFlying = false;
    private int batteryLife = 100;
    private boolean systemReady = false; // Flag de seguridad
    private final String LOG_FILE = "vuelo_log.txt";

    private void logAction(String action) {
        try (FileWriter fw = new FileWriter(LOG_FILE, true);
             PrintWriter pw = new PrintWriter(fw)) {
            pw.println("[" + LocalDateTime.now() + "] " + action);
        } catch (IOException e) { System.out.println("[ERR LOG]"); }
    }

    // --- MÉTODO DE AUTODIAGNÓSTICO ---
    public void runSelfDiagnostics() {
        System.out.println("\n[SISTEMA] Iniciando autodiagnóstico de seguridad...");
        
        boolean sensorsOk = true; 
        boolean network5GOk = true;
        boolean batteryOk = (batteryLife > 20);

        System.out.println("1. Sensores Inerciales: [OK]");
        System.out.println("2. Conexión 5G Nokia: [OK]");
        System.out.println("3. Nivel de Energía: [" + (batteryOk ? "OK" : "FALLO") + "]");

        if (sensorsOk && network5GOk && batteryOk) {
            this.systemReady = true;
            System.out.println("[SISTEMA] >>> TODO OK. Drone listo para despegar.\n");
            logAction("DIAGNÓSTICO: EXITOSO");
        } else {
            this.systemReady = false;
            System.out.println("[SISTEMA] >>> FALLO DE SEGURIDAD. Revise la batería.\n");
            logAction("DIAGNÓSTICO: FALLIDO");
        }
    }

    public void takeoff() {
        if (!systemReady) {
            System.out.println("[CUIDADO] Debe ejecutar el 'diagnóstico' antes de intentar despegar.");
            return;
        }
        
        if (!isFlying && batteryLife > 10) {
            isFlying = true;
            System.out.println("[SISTEMA] Motores al 100%. Despegando...");
            logAction("DESPEGUE CONFIRMADO");
            batteryLife -= 5;
        }
    }

    public void land() {
        if (isFlying) {
            isFlying = false;
            systemReady = false; // Se requiere nuevo diagnóstico para el siguiente vuelo
            System.out.println("[SISTEMA] Aterrizaje completado. Sensores en reposo.");
            logAction("ATERRIZAJE");
        }
    }
}

public class DroneProject {
    public static void main(String[] args) {
        NokiaDronePhone myDrone = new NokiaDronePhone();
        Scanner reader = new Scanner(System.in);
        String command = "";

        System.out.println("--- Nokia Drone Phone 5G (v10.0 - FINAL) ---");

        while (!command.equals("salir")) {
            System.out.print("Comando (diagnostico, despegar, aterrizar, salir) > ");
            command = reader.nextLine().toLowerCase();

            switch (command) {
                case "diagnostico": myDrone.runSelfDiagnostics(); break;
                case "despegar": myDrone.takeoff(); break;
                case "aterrizar": myDrone.land(); break;
                case "salir": System.out.println("Sistema apagado."); break;
                default: System.out.println("Comando no reconocido.");
            }
        }
        reader.close();
    }
}
// --- Panel Inferior: Botones con Colores ---
JPanel buttonPanel = new JPanel();
buttonPanel.setLayout(new GridLayout(2, 2, 10, 10));

JButton btnTakeoff = new JButton("DESPEGAR");
btnTakeoff.setBackground(Color.GREEN);
btnTakeoff.setForeground(Color.BLACK); // Texto negro sobre fondo verde

JButton btnLand = new JButton("ATERRIZAR");
btnLand.setBackground(Color.RED);
btnLand.setForeground(Color.WHITE); // Texto blanco sobre fondo rojo

JButton btnPhoto = new JButton("TOMAR FOTO");
btnPhoto.setBackground(new Color(30, 144, 255)); // Azul brillante
btnPhoto.setForeground(Color.WHITE);

JButton btnCharge = new JButton("CARGAR");
btnCharge.setBackground(Color.YELLOW);
btnCharge.setForeground(Color.BLACK);

buttonPanel.add(btnTakeoff);
buttonPanel.add(btnLand);
buttonPanel.add(btnPhoto);
buttonPanel.add(btnCharge);
add(buttonPanel, BorderLayout.SOUTH);
