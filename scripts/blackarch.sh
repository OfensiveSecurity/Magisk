#!/bin/bash
yat2m --select=gcrypt.3 --store mi_documentacion.texi
llvm-mca -mcpu=haswell -timeline operaciones.s
bzcat archivo.txt.bz2 | more
bzcat archivo.txt.bz2 | less
cat manual.texi | yat2m --source="Proyecto GNU" --release="v2.4" - | groff -man -Tascii | less
# Configura less para preprocesar archivos comprimidos
export LESSOPEN="| /usr/bin/lesspipe %s 2>&
# Ejemplo procesando un archivo comprimido
echo "mis_datos/secuencia.fastq.gz" | rush 'echo Ruta: {/} Archivo: {%} SinExtension: {:}'
# Salida: Ruta: mis_datos Archivo: secuencia.fastq.gz SinExtension: secuencia
cat fuente.psf | psfgettable - tabla_salida.txt
pacman-key --init
klist
netcap
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
echo 'alias sn="$HOME/.cargo/bin/sn"' >> ~/.bashrc
echo $$
llvm-install-name-tool -id "@rpath/libmi_library.dylib" libmi_libreria.dylib
pgrep -l bash
seq 1 3 | rush -v prefijo=ID_ -v sufijo=_2026 'echo {prefijo}{}{sufijo}'
psfgettable /usr/share/consolefonts/Lat2-Terminus16.psf.gz tabla.txt.gz
# Salida: ID_1_2026, ID_2_2026, etc.
arp -vn
arp -a
arp -i wlan0 -n
sudo arp -d 192.168.1.50
sudo arp -s 192.168.1.100 00:11:22:33:44:55
# Crear un archivo de ejemplo
echo "192.168.1.200 aa:bb:cc:dd:ee:ff" > mis_direcciones.txt
# Cargar el archivo a la tabla ARP
sudo arp -f mis_direcciones.txt
lf
cmatrix
ol
psfgettable /usr/share/consolefonts/Lat2-Terminus16.psf.gz | less
pacman-key --init
pacman-key --populate termux
pacman-key --populate
dpkg -i --force-overwrite /data/data/com.termux/cache/apt/archives/tin-summer_1.21.14-1_arm.deb
nfc-relay-picc
# Envía números del 1 al 10 en paralelo a 'echo'
seq 1 10 | rush echo {}
proot-distro login archlinux
proot-distro login archlinux -- pacman -Syu --noconfirm
