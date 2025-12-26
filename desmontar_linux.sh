#!/usr/bin/env bash

LOCAL_DIR="$HOME/proyecto_remoto"

if mountpoint -q "$LOCAL_DIR"; then
  fusermount -u "$LOCAL_DIR" && echo "✅ Desmontado $LOCAL_DIR"
else
  echo "ℹ $LOCAL_DIR no está montado"
fi
