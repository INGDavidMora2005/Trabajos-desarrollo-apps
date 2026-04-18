# Taller 2 — Asincronía en Flutter: Future, Timer e Isolates

**Autor:** David Mora Duque  
**Asignatura:** Desarrollo de Aplicaciones Móviles  
**Repositorio:** [URL del repo]

---

## 📋 Descripción General

Este proyecto demuestra el uso de conceptos avanzados de asincronía en Flutter:
- **Future / async / await**: Para operaciones asíncronas no bloqueantes
- **Timer**: Para cronómetros precisos con actualizaciones periódicas
- **Isolates**: Para ejecutar tareas CPU-intensivas en hilos separados

La aplicación permite explorar cada concepto de manera interactiva, mostrando logs en consola y en pantalla para entender el flujo de ejecución.

---

## 🏗️ Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada
├── app.dart                     # Configuración global de la app
├── core/
│   └── theme/
│       └── app_theme.dart       # Tema Material 3
└── features/
    ├── home/
    │   └── home_screen.dart     # Pantalla principal con navegación
    ├── async_demo/
    │   ├── async_screen.dart    # Demo de Future/async/await
    │   └── data_service.dart    # Servicio con métodos asíncronos
    ├── timer/
    │   ├── timer_screen.dart    # Cronómetro con Timer
    │   └── timer_controller.dart # Controlador del timer
    └── isolate_demo/
        ├── isolate_screen.dart  # Demo de Isolates
        └── heavy_task.dart      # Funciones top-level para Isolates
```

---

## 🔄 ¿Cuándo usar cada herramienta?

### Future / async / await
- Para operaciones I/O (red, archivos, bases de datos)
- Cuando necesitas esperar resultados sin bloquear la UI
- Para coordinar múltiples operaciones asíncronas
- Ejemplo: consultas HTTP, lecturas de archivos

### Timer
- Para actualizaciones periódicas precisas
- Cronómetros, contadores regresivos
- Animaciones basadas en tiempo
- Tareas programadas que se ejecutan cada X tiempo

### Isolate
- Tareas CPU-intensivas que podrían congelar la UI
- Procesamiento de datos grandes
- Cálculos matemáticos complejos
- Operaciones que toman más de 16ms (para mantener 60fps)

---

## 📱 Pantallas y Flujos

### 1. Home Screen
Pantalla principal con 3 tarjetas navegables:
- **Future / Async / Await**: Demo de operaciones asíncronas
- **Timer — Cronómetro**: Cronómetro con precisión de centésimas
- **Isolate — Tarea Pesada**: Ejecución en segundo plano

### 2. Future / Async / Await Screen
**Flujo: idle → loading → success/error**
- Estados visuales con indicadores
- 3 tipos de operaciones: simple, con error posible, múltiples en paralelo
- Logs en tiempo real mostrando el orden de ejecución
- Demostración de manejo de errores con try/catch

### 3. Timer Screen
**Flujo: detenido → corriendo → pausado → reiniciado**
- Cronómetro con formato MM:SS:cc
- Estados: corriendo (verde), pausado (naranja), detenido (gris)
- Sistema de vueltas/laps
- Timer.periodic con intervalos de 100ms

### 4. Isolate Screen
**Flujo: idle → spawning → progress → completed**
- Dos tareas opcionales: cálculo de primos o suma acumulativa
- Comunicación bidireccional con SendPort/ReceivePort
- Reporte de progreso cada 10%
- Comparación con ejecución en UI thread (bloqueante)

---

## 🚀 Cómo ejecutar el proyecto

1. Asegurarse de tener Flutter instalado y en PATH
2. Clonar el repositorio
3. Ejecutar `flutter pub get`
4. Ejecutar `flutter run` (o usar VS Code/Fleet)

---

## 📦 Dependencias

- **Flutter SDK**: >=3.0.0 <4.0.0
- **cupertino_icons**: ^1.0.2
- **flutter_lints**: ^3.0.0

---

## 🌿 Flujo Git (GitFlow)

Este proyecto sigue GitFlow:
- `main`: Rama de producción
- `dev`: Rama de desarrollo
- `feature/*`: Ramas de funcionalidades
- Pull Requests de `feature/*` → `dev`

---

## 📝 Notas de Implementación

- Todas las funciones Isolate son **top-level** (no métodos de clase)
- Verificación de `mounted` antes de `setState` en operaciones async
- Manejo de errores obligatorio con try/catch
- Dispose de timers e isolates para evitar memory leaks
- Tema Material 3 con soporte para modo oscuro/claro
- UI responsiva y accesible

---

¡Explora cada feature para entender cómo Flutter maneja la concurrencia y la asincronía!