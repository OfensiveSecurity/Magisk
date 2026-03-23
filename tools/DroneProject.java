import java.util.Scanner;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.IOException;
import java.time.LocalDateTime

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