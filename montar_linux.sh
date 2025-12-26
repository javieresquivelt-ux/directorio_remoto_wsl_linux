#!/usr/bin/env bash

REMOTE_USER="miusuario"
- REMOTE_HOST="192.168.10.10"
- REMOTE_DIR="/var/www/miproyecto"
- LOCAL_DIR="$HOME/proyecto_remoto"

# Crear punto de montaje si no existe
mkdir -p "$LOCAL_DIR"

# Opcional: comprobar que estás en tu red (ejemplo, ping al servidor)
if ! ping -c 1 -W 1 "$REMOTE_HOST" >/dev/null 2>&1; then
  echo "⚠ No se puede alcanzar $REMOTE_HOST. ¿Estás en tu red de casa/oficina?"
  exit 1
fi

# Si ya está montado, no volver a montar
if mountpoint -q "$LOCAL_DIR"; then
  echo "✅ Ya está montado en $LOCAL_DIR"
  exit 0
fi

sshfs -o idmap=user "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR" "$LOCAL_DIR" && \
  echo "✅ Montado en $LOCAL_DIR"
