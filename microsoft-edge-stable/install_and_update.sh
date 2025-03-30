#!/bin/bash

# Obtener la ruta del directorio donde se encuentra el script
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Función para mostrar mensajes de error
error() {
    echo "Error: $1"
    exit 1
}

# Verificar si se tiene acceso de superusuario
if [ "$EUID" -ne 0 ]; then
    error "Por favor, ejecuta este script como superusuario (sudo)."
fi

# Función para verificar si una dependencia está instalada
check_dependency() {
    if pacman -Q "$1" >/dev/null 2>&1; then
        echo "La dependencia $1 ya está instalada."
        return 0
    else
        echo "Instalando la dependencia $1..."
        pacman -Sy --needed --quiet "$1" || error "No se pudo instalar $1."
        return 1
    fi
}

# Dependencias necesarias
echo "Verificando e instalando dependencias necesarias..."
check_dependency dpkg
check_dependency curl
check_dependency wget

# Descargar la última versión de Microsoft Edge
echo "Buscando la última versión de Microsoft Edge..."
URL=$(curl -s https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/ | grep -oP '(?<=href=")microsoft-edge-stable.*?amd64\.deb' | sort -V | tail -n 1)

if [ -z "$URL" ]; then
    error "No se pudo encontrar la última versión de Microsoft Edge."
fi

# Verificar si ya se tiene instalada la última versión
CURRENT_VERSION=$(microsoft-edge-stable --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+\.\d+')
LATEST_VERSION=$(echo "$URL" | grep -oP '\d+\.\d+\.\d+\.\d+')

if [ "$CURRENT_VERSION" == "$LATEST_VERSION" ]; then
    echo "Ya tienes instalada la última versión de Microsoft Edge ($CURRENT_VERSION)."
    exit 0
fi

echo "Descargando la versión $LATEST_VERSION de Microsoft Edge..."
wget -q "https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/$URL" -O microsoft-edge.deb || error "No se pudo descargar el paquete."

# Extraer e instalar el paquete .deb
echo "Extrayendo e instalando Microsoft Edge..."
mkdir -p edge_extracted
dpkg -x microsoft-edge.deb edge_extracted || error "No se pudo extraer el paquete."
cp -r edge_extracted/* / || error "No se pudo copiar los archivos al sistema."

# Limpiar archivos temporales
echo "Limpiando archivos temporales..."
rm -rf microsoft-edge.deb edge_extracted

# Verificar instalación
echo "Verificando instalación..."
if command -v microsoft-edge-stable >/dev/null 2>&1; then
    echo "Microsoft Edge se ha instalado o actualizado correctamente a la versión $LATEST_VERSION."
    echo "Puedes ejecutarlo con 'microsoft-edge-stable'."
else
    error "La instalación o actualización falló."
fi

# Ruta del ícono en el sistema
ICON_SYSTEM_PATH="/usr/share/icons/hicolor/48x48/apps/microsoft-edge.svg"

# Ruta del ícono junto al script
ICON_LOCAL_PATH="$SCRIPT_DIR/microsoft-edge.svg"

# Validar si el ícono ya está en el sistema
if [ -f "$ICON_SYSTEM_PATH" ]; then
    echo "El ícono ya existe en la ubicación del sistema: $ICON_SYSTEM_PATH."
else
    # Validar si el ícono existe junto al script
    if [ -f "$ICON_LOCAL_PATH" ]; then
        echo "Copiando el ícono desde: $ICON_LOCAL_PATH..."
        sudo cp "$ICON_LOCAL_PATH" "$ICON_SYSTEM_PATH" || error "No se pudo copiar el ícono."
    else
        error "No se encontró el archivo del ícono junto al script: $ICON_LOCAL_PATH."
    fi
fi
