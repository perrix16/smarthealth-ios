#!/bin/bash

# Script para limpiar completamente Xcode y sincronizar con GitHub
# Autor: SmartHealth iOS Team
# Fecha: 2025-12-13

echo "🧹 Limpiando proyecto SmartHealth iOS..."

# 1. Cerrar Xcode si está abierto
echo "1️⃣ Cerrando Xcode..."
killall Xcode 2>/dev/null || true
sleep 2

# 2. Hacer git pull para traer últimos cambios
echo "2️⃣ Sincronizando con GitHub (git pull)..."
git fetch origin
git reset --hard origin/main
git pull origin main

# 3. Limpiar DerivedData
echo "3️⃣ Eliminando DerivedData de Xcode..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 4. Eliminar archivos de CocoaPods si existen
echo "4️⃣ Eliminando archivos de CocoaPods..."
rm -f Podfile.lock
rm -rf Pods/
rm -rf SmartHealth.xcworkspace

# 5. Limpiar módulos de Xcode
echo "5️⃣ Limpiando módulos precompilados..."
rm -rf ~/Library/Developer/Xcode/DerivedData/ModuleCache.noindex

# 6. Abrir proyecto limpio
echo "6️⃣ Abriendo proyecto limpio..."
open SmartHealth.xcodeproj

echo "✅ ¡Limpieza completada!"
echo "📱 Ahora en Xcode:"
echo "   1. Cmd + Shift + K (Clean Build Folder)"
echo "   2. Cmd + B (Build)"
echo "   3. Cmd + R (Run)"
