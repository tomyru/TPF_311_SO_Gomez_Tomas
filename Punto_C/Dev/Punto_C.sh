#!/bin/bash
set -e

echo "Creando grupos..."
sudo groupadd g_dev
sudo groupadd g_infra

echo "Creando usuario u_dev..."
PASS_DEV=$(openssl passwd -6 "u_dev")
sudo useradd -m -g g_dev -G g_infra -p "$PASS_DEV" -s /bin/bash u_dev

echo "PROCESO FINALIZADO"