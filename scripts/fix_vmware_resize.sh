#!/bin/bash                                                                                     # Ruta del archivo de configuración de Xorg
XORG_CONF="/usr/share/X11/xorg.conf.d/20-vmware.conf"
if [ ! -f "$XORG_CONF" ]; then                                                              echo "Aplicando parche para auto-resizing de VMware..."
    sudo bash -c "cat << 'CONF' > $XORG_CONF                                            Section \"Device\"
    Identifier \"vmware\"
    Driver \"modesetting\"
EndSection
CONF"
    echo "Configuración creada. Reinicia la sesión X para aplicar."
else
    echo "El parche ya existe en $XORG_CONF"                                            fi