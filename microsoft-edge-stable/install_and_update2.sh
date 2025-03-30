#!/bin/bash

# Configuración de rutas
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
ICON_LOCAL_PATH="$SCRIPT_DIR/microsoft-edge.svg"
ICON_SYSTEM_PATH="/usr/share/icons/hicolor/48x48/apps/microsoft-edge.svg"
TEMP_DIR="/tmp/microsoft-edge-install"
DEB_PACKAGE="$TEMP_DIR/microsoft-edge.deb"
BASE_URL="https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/" # URL base

# Detectar arquitectura del sistema
ARCH=$(uname -m)
case "$ARCH" in
    x86_64) ARCH="amd64" ;;
    aarch64) ARCH="arm64" ;;
    *) error "Arquitectura no soportada: $ARCH" ;;
esac

# Listado de dependencias
DEPENDENCIES=("dpkg" "curl" "wget")

# Función para mostrar mensajes de error y salir
error() {
    echo "Error: $1"
    exit 1
}

# Función para verificar ejecución como superusuario
require_superuser() {
    if [ "$EUID" -ne 0 ]; then
        error "Por favor, ejecuta este script como superusuario (sudo)."
    fi
}

# Función para verificar e instalar dependencias
install_dependencies() {
    echo "Verificando dependencias necesarias..."
    for dependency in "${DEPENDENCIES[@]}"; do
        if ! pacman -Q "$dependency" &>/dev/null; then
            echo "Instalando dependencia $dependency..."
            pacman -Sy --needed --quiet "$dependency" || error "No se pudo instalar $dependency."
        else
            echo "La dependencia $dependency ya está instalada."
        fi
    done
}

# Función para descargar e instalar Microsoft Edge
install_edge() {
    echo "Buscando la última versión de Microsoft Edge para la arquitectura: $ARCH..."
    local url
    url=$(curl -s "$BASE_URL" | grep -oP "microsoft-edge-stable.*?$ARCH\.deb" | sort -V | tail -n 1) || error "No se pudo encontrar la última versión de Microsoft Edge para la arquitectura $ARCH."

    local current_version
    local latest_version
    current_version=$(microsoft-edge-stable --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+\.\d+')
    latest_version=$(echo "$url" | grep -oP '\d+\.\d+\.\d+\.\d+')

    if [ "$current_version" == "$latest_version" ]; then
        echo "Microsoft Edge ya está actualizado a la versión $current_version."
        return
    fi

    echo "Preparando directorio temporal..."
    mkdir -p "$TEMP_DIR"

    echo "Descargando Microsoft Edge versión $latest_version..."
    wget -q "${BASE_URL}${url}" -O "$DEB_PACKAGE" || error "No se pudo descargar el paquete."

    echo "Desempaquetando Microsoft Edge..."
    dpkg -x "$DEB_PACKAGE" "$TEMP_DIR" || error "No se pudo desempaquetar el paquete."

    echo "Instalando archivos en el sistema..."
    cp -r "$TEMP_DIR/"* / || error "No se pudo instalar los archivos en el sistema."

    echo "Limpieza de archivos temporales..."
    rm -rf "$TEMP_DIR"
}

# Función para gestionar el ícono
manage_icon() {
    if [ -f "$ICON_SYSTEM_PATH" ]; then
        echo "El ícono ya existe en la ubicación del sistema: $ICON_SYSTEM_PATH."
    else
        if [ -f "$ICON_LOCAL_PATH" ]; then
            echo "Copiando ícono desde: $ICON_LOCAL_PATH..."
            cp "$ICON_LOCAL_PATH" "$ICON_SYSTEM_PATH" || error "No se pudo copiar el ícono."
        else
            error "No se encontró el archivo del ícono junto al script: $ICON_LOCAL_PATH."
        fi
    fi
}

# Ejecución del script
require_superuser
install_dependencies
install_edge
manage_icon

echo "Microsoft Edge y su ícono se han instalado correctamente."
