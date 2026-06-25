#!/bin/bash
set -e
# =====================================================================
# SECCIÓN 1: CONFIGURACIÓN DE "SERVICIOS" (/dev/sdc1)
echo "[Servicios] Formateando /dev/sdc1 en ext4..."
sudo mkfs.ext4 -F /dev/sdc1

echo "[Servicios] Obteniendo el UUID de /dev/sdc1..."
UUID_SDC1=$(sudo blkid -s UUID -o value /dev/sdc1)

echo "[Servicios] Agregando a /etc/fstab para persistencia..."
echo "UUID=$UUID_SDC1  /home/vagrant/dev/Servicios  ext4  defaults  0  2" | sudo tee -a /etc/fstab

echo "[Servicios] Montando partición y creando estructura inicial..."
sudo mount /home/vagrant/dev/Servicios
sudo mkdir -p /home/vagrant/dev/Servicios/{Base_de_Datos,Cache,Web}

# =====================================================================
# SECCIÓN 2: CONFIGURACIÓN DE "MONITOREO" (/dev/sdc2)
echo "[Monitoreo] Formateando /dev/sdc2 en ext4..."
sudo mkfs.ext4 -F /dev/sdc2

echo "[Monitoreo] Obteniendo el UUID de /dev/sdc2..."
UUID_SDC2=$(sudo blkid -s UUID -o value /dev/sdc2)

echo "[Monitoreo] Agregando a /etc/fstab para persistencia..."
echo "UUID=$UUID_SDC2  /home/vagrant/dev/Monitoreo  ext4  defaults  0  2" | sudo tee -a /etc/fstab

echo "[Monitoreo] Montando partición y creando subcarpetas..."
sudo mount /home/vagrant/dev/Monitoreo
sudo mkdir -p /home/vagrant/dev/Monitoreo/{Alertas,Logs,Metricas}

# =====================================================================
# SECCIÓN 3: CONFIGURACIÓN DE LA PARTICIÓN LÓGICA 1 EN "WEB" (/dev/sdc5)
echo "[Web] Formateando partición lógica /dev/sdc5 en ext4..."
sudo mkfs.ext4 -F /dev/sdc5

echo "[Web] Obteniendo el UUID de /dev/sdc5..."
UUID_SDC5=$(sudo blkid -s UUID -o value /dev/sdc5)

echo "[Web] Agregando a /etc/fstab para persistencia anidada..."
echo "UUID=$UUID_SDC5  /home/vagrant/dev/Servicios/Web  ext4  defaults  0  2" | sudo tee -a /etc/fstab

echo "[Web] Montando la partición lógica dentro de Servicios/Web..."
sudo mount /home/vagrant/dev/Servicios/Web

# =====================================================================
# SECCIÓN 4: CONFIGURACIÓN DE LA PARTICIÓN LÓGICA 2 EN "CACHE" (/dev/sdc6)
echo "[Cache] Formateando partición lógica /dev/sdc6 en ext4..."
sudo mkfs.ext4 -F /dev/sdc6

echo "[Cache] Obteniendo el UUID de /dev/sdc6..."
UUID_SDC6=$(sudo blkid -s UUID -o value /dev/sdc6)

echo "[Cache] Agregando a /etc/fstab para persistencia anidada..."
echo "UUID=$UUID_SDC6  /home/vagrant/dev/Servicios/Cache  ext4  defaults  0  2" | sudo tee -a /etc/fstab

echo "[Cache] Montando la partición lógica dentro de Servicios/Cache..."
sudo mount /home/vagrant/dev/Servicios/Cache

# =====================================================================
# SECCIÓN 5: CONFIGURACIÓN DE LA PARTICIÓN LÓGICA 3 EN "LOGS" (/dev/sdc7)
echo "[Logs] Formateando partición lógica /dev/sdc7 en ext4..."
sudo mkfs.ext4 -F /dev/sdc7

echo "[Logs] Obteniendo el UUID de /dev/sdc7..."
UUID_SDC7=$(sudo blkid -s UUID -o value /dev/sdc7)

echo "[Logs] Agregando a /etc/fstab para persistencia anidada..."
echo "UUID=$UUID_SDC7  /home/vagrant/dev/Monitoreo/Logs  ext4  defaults  0  2" | sudo tee -a /etc/fstab

echo "[Logs] Montando la partición lógica dentro de Monitoreo/Logs..."
sudo mount /home/vagrant/dev/Monitoreo/Logs

# =====================================================================
# SECCIÓN 6: AJUSTE FINAL DE PERMISOS GLOBAL
echo "Asignando la propiedad de todas las estructuras al usuario 'vagrant'..."
sudo chown -R vagrant:vagrant /home/vagrant/dev/

echo "PROCESO FINALIZADO"