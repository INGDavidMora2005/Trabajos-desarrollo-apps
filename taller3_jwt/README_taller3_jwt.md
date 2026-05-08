# Taller 3: Autenticación JWT en Flutter

## Descripción del Taller

Este taller implementa un módulo completo de autenticación JWT desde cero en una aplicación Flutter. El proyecto incluye login, registro, manejo de tokens seguros, y evidencia visual del almacenamiento de datos.

## Dependencias Utilizadas

- **shared_preferences: ^2.3.0**: Para almacenar datos no sensibles del usuario (nombre, email, fecha de login).
- **flutter_secure_storage: ^9.2.2**: Para almacenar tokens de autenticación de manera segura y cifrada.
- **http: ^1.2.0**: Para realizar peticiones HTTP a la API de autenticación.
- **provider: ^6.1.2**: Para manejar el estado de autenticación en la aplicación.

## Instrucciones para Crear un Usuario de Prueba

1. Abrir la aplicación y hacer clic en "¿No tienes cuenta? Regístrate".
2. Llenar el formulario con datos válidos:
   - Nombre: "Usuario de Prueba"
   - Correo electrónico: "prueba@example.com"
   - Contraseña: "password123"
3. Hacer clic en "Registrar" (nota: actualmente muestra un mensaje de que no está implementado, pero en producción llamaría a la API).
4. Para probar login real, usar credenciales válidas en la API externa.

## Estructura de Carpetas

```
lib/
├── main.dart                          ← Punto de entrada modificado
├── core/
│   └── storage/
│       ├── preferences_service.dart   ← Servicio SharedPreferences
│       └── secure_storage_service.dart ← Servicio SecureStorage
└── features/
    └── auth/
        ├── data/
        │   ├── models/
        │   │   └── user_model.dart     ← Modelo de usuario
        │   └── services/
        │       └── auth_service.dart   ← Servicio de autenticación
        └── presentation/
            ├── providers/
            │   └── auth_provider.dart  ← Provider de estado
            └── screens/
                ├── login_screen.dart       ← Pantalla de login
                └── storage_evidence_screen.dart ← Pantalla de evidencia
```

## Capturas de Pantalla Esperadas

### 1. Pantalla de Login
- Fondo con gradiente azul/índigo
- Card centrada con ícono de candado
- Campos de email y contraseña con validación
- Botón de login con indicador de carga
- Enlace para registro

### 2. Pantalla de Registro (Diálogo)
- AlertDialog con campos: nombre, email, contraseña
- Botones de cancelar y registrar

### 3. Pantalla de Evidencia de Almacenamiento
- AppBar con título
- Tres cards mostrando:
  - Datos del usuario (SharedPreferences)
  - Estado del token (SecureStorage)
  - Información explicativa
- Botón rojo de cerrar sesión

## Flujo de la Aplicación

```
Inicio
  ↓
¿Tiene token?
  ├─ Sí → Pantalla de Evidencia
  └─ No → Pantalla de Login
      ↓
    Login exitoso
      ↓
    Pantalla de Evidencia
      ↓
    Cerrar sesión
      ↓
    Pantalla de Login
```

### Diagrama ASCII

```
+----------------+     +----------------+     +---------------------+
|   Login Screen | --> | Auth Provider  | --> |   Auth Service      |
|                |     |                |     |                     |
| - Email/Password|     | - login()      |     | - POST /login       |
| - Validation   |     | - logout()     |     | - POST /register    |
| - Register link|     | - checkStatus()|     | - Handle responses  |
+----------------+     +----------------+     +---------------------+
       |                        |                        |
       |                        |                        |
       v                        v                        v
+----------------+     +----------------+     +---------------------+
|Evidence Screen | <-- | Secure Storage | <-- | Preferences Service |
|                |     |                |     |                     |
| - User data    |     | - Tokens       |     | - User info         |
| - Token status |     | - Encrypted    |     | - Non-sensitive     |
| - Logout btn   |     |                |     |                     |
+----------------+     +----------------+     +---------------------+
```