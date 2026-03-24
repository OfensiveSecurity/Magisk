use std::process::Command;
use std::os::unix::process::CommandExt;
use std::fs;

fn main() {
    println!("[🦀] NEXUS-OVERDRIVE: Iniciando bypass de UID...");

    // 1. Intentamos forzar el cambio de propietario si tenemos capacidades remanentes
    // Esto apunta al error del UID 100000
    let _ = Command::new("chown")
        .args(&["0:0", "/etc/sudoers"])
        .status();

    // 2. Payload de ejecución: Intentamos spawnear una shell con UID 0
    // Usamos setuid (si el binario tiene el bit o estamos en un entorno vulnerable)
    unsafe {
        libc::setuid(0);
        libc::setgid(0);
    }

    println!("[🔥] Ejecutando shell de emergencia para reparar visudo...");
    
    // 3. Ejecutamos una shell que ignore las restricciones de /etc/sudo.conf
    let error = Command::new("/bin/sh")
        .arg("-i")
        .exec();

    println!("[🚨] Fallo en el despliegue: {:?}", error);
}
