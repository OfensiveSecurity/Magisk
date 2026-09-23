# BloodHound collection (from Linux)
bloodhound-python -u user -p 'Pass' -d domain.local -dc dc.domain.local -c All --zip

# NetExec enumeration + BloodHound
nxc ldap dc.domain.local -u user -p 'Pass' --bloodhound --collection All

# Certipy AD CS enum
certipy find -u user@domain.local -p 'Pass' -dc-ip <DC_IP> -vulnerable -bloodhound

# Impacket Kerberoast
impacket-GetUserSPNs domain.local/user:Pass -dc-ip <DC_IP> -request

# bloodyAD example
bloodyAD --host dc.domain.local -d domain.local -u user -p 'Pass' get writable
