#!/bin/bash
# Triturar logs de acceso web y de sistema
sudo shred -u -z -n 3 /var/log/apache2/access.log
sudo shred -u -z -n 3 /var/log/auth.log
sudo touch /var/log/apache2/access.log
sudo touch /var/log/auth.log
