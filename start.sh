#!/usr/bin/env bash
# Arranca el emulador (crea el contenedor si no existe) y espera a que esté listo
set -e
if docker ps -a --format '{{.Names}}' | grep -qx aws-emulator; then
  docker start aws-emulator >/dev/null
else
  mkdir -p "$HOME/.aws/emulator"
  docker run -d --name aws-emulator --memory=2g --memory-swap=2g \
    -p 127.0.0.1:9297:9297 -e HOME="$HOME" \
    -v "$HOME/.aws/emulator:$HOME/.aws/emulator" aws-emulator -p 9297 >/dev/null
fi
for i in $(seq 30); do
  curl -sf --cacert ~/.aws/emulator/9297/ca.pem https://127.0.0.1:9297/__admin/health >/dev/null && { echo "emulador listo en https://127.0.0.1:9297"; exit 0; }
  sleep 1
done
echo "el emulador no respondió" >&2; exit 1
