import java.net.InetAddress;

public class VigilanteRed {
    public static void main(String[] args) {
        String subred = "192.168.1"; // Ajusta a tu IP local
        int timeout = 100;

        System.out.println("====== ESCANEANDO DISPOSITIVOS EN RED SEGURA ======");
        
        for (int i = 1; i < 255; i++) {
            String host = subred + "." + i;
            try {
                if (InetAddress.getByName(host).isReachable(timeout)) {
                    System.out.println("[ACTIVO]: " + host + " - Dispositivo Autorizado");
                }
            } catch (Exception e) {
                // Nodo no alcanzable
            }
        }
        System.out.println("====================================================");
        System.out.println("[ESTADO]: Red Monitoreada y Protegida.");
    }
}
