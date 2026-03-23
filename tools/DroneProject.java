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
