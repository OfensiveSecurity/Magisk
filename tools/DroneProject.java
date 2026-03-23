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
