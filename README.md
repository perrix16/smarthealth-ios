# SmartHealth iOS

iOS app for SmartHealth - Health data tracking and monitoring application built with SwiftUI

## 📱 About

SmartHealth iOS is a native iOS application that connects to the SmartHealth backend to provide comprehensive health data tracking and monitoring capabilities.

## 🚀 Features

- **User Authentication**: Secure JWT-based authentication
- **Health Data Tracking**: Monitor and track various health metrics
- **Real-time Sync**: Synchronize data with SmartHealth backend
- **SwiftUI Interface**: Modern, native iOS interface
- **Rate Limiting**: Built-in rate limiting for API calls

## 🛠 Tech Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Architecture**: MVVM
- **Networking**: URLSession
- **Minimum iOS**: 16.0

## 🔧 Setup

### Prerequisites

- Xcode 15.0 or later
- iOS 16.0+ device or simulator
- Apple Developer account (Team ID: F85ZH3S3X)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/perrix16/smarthealth-ios.git
cd smarthealth-ios
```

2. Open the project in Xcode:
```bash
open SmartHealth.xcodeproj
```

3. **IMPORTANTE - Limpiar caché de Firebase/CocoaPods:**

```bash
# Eliminar caché de Xcode
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Eliminar archivos de CocoaPods (si existen)
rm -f Podfile.lock
rm -rf Pods/
rm -rf SmartHealth.xcworkspace
```

**⚠️ Nota**: Este proyecto ya NO usa Firebase. Usa integración directa con TrySolid API.


3. Configure your Team ID:
   - Select the project in Xcode
   - Go to Signing & Capabilities
   - Select your development team

4. **Build and run en Xcode:**

Después de abrir el proyecto en Xcode:

```
1. Cmd + Shift + K  → Clean Build Folder
2. Cmd + B          → Build (compilar)
3. Selecciona tu iPhone o simulador en la barra superior
4. Cmd + R          → Run (ejecutar)
```

**Atajos de teclado útiles:**
- `Cmd + B` - Compilar el proyecto
- `Cmd + R` - Ejecutar la app
- `Cmd + .` - Detener la ejecución
- `Cmd + Shift + K` - Limpiar build
- `Cmd + Shift + O` - Abrir archivo rápidamente
## 🌐 Backend

The app connects to the SmartHealth backend:
- **Production URL**: `https://smarthealth.codapt.app`
- **Backend Framework**: Solid
- **Authentication**: JWT

## 📁 Project Structure

```
SmartHealth/
├── Models/
│   ├── User.swift
│   ├── HealthData.swift
│   └── APIResponse.swift
├── Services/
│   ├── NetworkManager.swift
│   ├── AuthService.swift
│   └── HealthDataService.swift
├── Views/
│   ├── LoginView.swift
│   ├── DashboardView.swift
│   └── HealthDataView.swift
├── ViewModels/
│   ├── AuthViewModel.swift
│   └── HealthDataViewModel.swift
└── App/
    ├── SmartHealthApp.swift
    └── ContentView.swift
```

## 🔐 Security

- JWT token-based authentication
- Secure token storage using Keychain
- HTTPS-only API communication
- Rate limiting on authentication endpoints

## 👨‍💻 Development

### API Endpoints

- `POST /api/auth/login` - User authentication
- `GET /api/auth/profile` - Get user profile
- `GET /api/health/data` - Fetch health data
- `POST /api/health/data` - Submit health data

### Environment Configuration

Update `NetworkManager.swift` to switch between environments:
```swift
private let baseURL = "https://smarthealth.codapt.app"
```

## 📄 License

No license specified

## 👤 Author

**Salvatore** (perrix16)
- Company: WITO
- Location: Valencia/Dénia, Spain

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

---

Built with ❤️ using Swift and SwiftUI
