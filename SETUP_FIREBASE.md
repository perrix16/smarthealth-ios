# Firebase Auth Setup - SmartHealth iOS

## Resumen
Guía completa para configurar Firebase Authentication en el proyecto SmartHealth iOS usando **solo terminal**.

---

## 1. Descargar GoogleService-Info.plist

```bash
# El archivo GoogleService-Info.plist ya está descargado desde Firebase Console
# Ubicación: ~/Downloads/GoogleService-Info.plist

# Copiarlo al proyecto
cp ~/Downloads/GoogleService-Info.plist ~/smarthealth-ios/SmartHealth/
```

---

## 2. Añadir Firebase SDK usando CocoaPods

### Opción A: CocoaPods (Recomendado)

```bash
cd ~/smarthealth-ios

# Crear Podfile si no existe
cat > Podfile << 'EOF'
platform :ios, '13.0'

target 'SmartHealth' do
  use_frameworks!
  
  # Firebase
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
end
EOF

# Instalar dependencias
pod install

# IMPORTANTE: A partir de ahora usa el .xcworkspace en lugar del .xcodeproj
open SmartHealth.xcworkspace
```

### Opción B: Swift Package Manager (SPM)

```bash
cd ~/smarthealth-ios

# Añadir dependencia usando xcodebuild
xed SmartHealth.xcodeproj

# Luego en Xcode (GUI necesaria):
# File > Add Package Dependencies
# URL: https://github.com/firebase/firebase-ios-sdk
# Seleccionar: FirebaseAuth, FirebaseCore
```

---

## 3. Actualizar código del proyecto

Los archivos ya están actualizados en GitHub:
- ✅ `SmartHealth/AppDelegate.swift` - Firebase init
- ✅ `Services/AuthService.swift` - Firebase Auth hybrid
- ✅ `Models/User.swift` - firebaseUID añadido

```bash
# Pull cambios del repo
cd ~/smarthealth-ios
git pull origin main
```

---

## 4. Compilar el proyecto

### Usando Xcode (GUI)

```bash
# Si usaste CocoaPods:
open SmartHealth.xcworkspace

# Si usaste SPM o proyecto original:
open SmartHealth.xcodeproj

# Luego: Cmd+B (compilar) o Cmd+R (ejecutar)
```

### Usando Terminal (xcodebuild)

```bash
cd ~/smarthealth-ios

# Si usaste CocoaPods:
xcodebuild -workspace SmartHealth.xcworkspace \
  -scheme SmartHealth \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  build

# Si NO usaste CocoaPods:
xcodebuild -project SmartHealth.xcodeproj \
  -scheme SmartHealth \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  build
```

---

## 5. Ejecutar en simulador (Terminal)

```bash
# Listar simuladores disponibles
xcrun simctl list devices

# Abrir simulador
open -a Simulator

# Compilar y ejecutar
xcodebuild -workspace SmartHealth.xcworkspace \
  -scheme SmartHealth \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  clean build

# Instalar en simulador
xcrun simctl install booted ~/Library/Developer/Xcode/DerivedData/SmartHealth-*/Build/Products/Debug-iphonesimulator/SmartHealth.app

# Ejecutar app
xcrun simctl launch booted com.smarthealth.app
```

---

## 6. Verificar configuración

### Checklist:
- [ ] GoogleService-Info.plist en carpeta SmartHealth/
- [ ] Pod install completado (si usas CocoaPods)
- [ ] import Firebase en AppDelegate.swift
- [ ] FirebaseApp.configure() en didFinishLaunching
- [ ] AuthService actualizado con Firebase Auth
- [ ] User model con firebaseUID

### Test rápido:

```bash
# Ver logs del simulador
xcrun simctl spawn booted log stream --predicate 'processImagePath contains "SmartHealth"'
```

---

## 7. Troubleshooting

### Error: "No such module 'Firebase'"

```bash
# Limpiar build
rm -rf ~/Library/Developer/Xcode/DerivedData/SmartHealth-*

# Reinstalar pods
cd ~/smarthealth-ios
pod deintegrate
pod install

# Rebuild
xcodebuild -workspace SmartHealth.xcworkspace -scheme SmartHealth clean build
```

### Error: CocoaPods no instalado

```bash
sudo gem install cocoapods
pod setup
```

---

## Comandos completos en orden

```bash
# 1. Preparar proyecto
cd ~/smarthealth-ios
git pull origin main
cp ~/Downloads/GoogleService-Info.plist SmartHealth/

# 2. Instalar Firebase (CocoaPods)
cat > Podfile << 'EOF'
platform :ios, '13.0'
target 'SmartHealth' do
  use_frameworks!
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
end
EOF
pod install

# 3. Compilar y ejecutar
open SmartHealth.xcworkspace
# Cmd+R para ejecutar
```

---

## Credenciales de prueba

**Email**: test@smarthealth.com  
**Password**: Test1234!

Estas credenciales están habilitadas en Firebase Console > Authentication > Email/Password.
