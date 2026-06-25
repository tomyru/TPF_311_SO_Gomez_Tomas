#!/bin/bash
set -e

echo "=== INICIANDO CONFIGURACIÓN DE DISCOS Y MONTAJES ==="
echo "---------------------------------------------------------"

# SECCIÓN 1: CONFIGURACIÓN DE "SERVICIOS" (/dev/sdc1)
echo "[Servicios] Formateando /dev/sdc1 en ext4..."
sudo mkfs.ext4 -F /dev/sdc1

echo "[Servicios] Obteniendo el UUID de /dev/sdc1..."
UUID_SDC1=$(sudo blkid -s UUID -o value /dev/sdc1)

echo "[Servicios] Agregando a /etc/fstab para persistencia..."
echo "UUID=$UUID_SDC1  /home/vagrant/dev/Servicios  ext4  defaults  0  2" | sudo tee -a /etc/fstab

echo "[Servicios] Montando partición y creando subcarpetas..."
sudo mount /home/vagrant/dev/Servicios
sudo mkdir -p /home/vagrant/dev/Servicios/{Base_de_Datos,Cache,Web}
echo "---------------------------------------------------------"

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

echo "---------------------------------------------------------"

# AJUSTE FINAL DE PERMISOS
echo "Asignando la propiedad de todas las carpetas al usuario 'vagrant'..."
sudo chown -R vagrant:vagrant /home/vagrant/dev/

echo "---------------------------------------------------------"
echo "PROCESO FINALIZADO"