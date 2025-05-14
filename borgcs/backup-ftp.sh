#!/bin/bash

export BORG_REPO=/home/usuario/projecte-asix/admin/repo
export BORG_PASSPHRASE='admin'

mkdir -p "$BORG_REPO"

# Inicialitza si no existeix
if [ ! -d "$BORG_REPO/data" ]; then
    borg init --encryption=repokey "$BORG_REPO"
fi

# Crear backup amb borg
borg create --stats "$BORG_REPO"::"backup-$(date +%Y-%m-%d_%H-%M-%S)" /etc /home/usuario/projecte-asix

# Crear nom de fitxer únic
FECHA=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVO="/home/usuario/projecte-asix/admin/backup-${FECHA}.tar.gz"

# Comprimir el repo
tar -czf "$ARCHIVO" "$BORG_REPO"

# Enviar al servidor FTP
rclone copy "$ARCHIVO" ftpserver:backup
