# Sarah App

App móvil que guía a niños por voz a completar tareas del hogar, fomentando la autonomía infantil y reduciendo la fricción padre-hijo.

## Funcionalidades

### Modo Niño
1. **Pantalla de inicio** — Botón grande y pulsante para comenzar.
2. **Selección de tarea** — Muestra la tarea activa asignada por los padres.
3. **Guía motivacional** — Al presionar "Comenzar", reproduce `task_started` una vez. Durante la tarea, los audios `good_job`, `keep_going` y `almost_done` se reproducen en bucle continuo con pausas de 10s. Al presionar "¡Tarea completada!", se reproduce `all_done` y finaliza la tarea.
4. **Cronómetro** — Muestra el tiempo transcurrido durante la tarea.
5. **Finalización** — Botón "¡Tarea completada!" para marcar la tarea como hecha, con animación de celebración.

### Modo Padres
1. **Lista de tareas** — Vista con todas las tareas creadas, estado de completitud y asignación activa.
2. **Asignar tarea** — Seleccionar y asignar una tarea a Sarah con confirmación.
3. **Agregar tarea** — Crear nuevas tareas desde un formulario.
4. **Persistencia local** — Las tareas se guardan automáticamente con SharedPreferences.

## Tecnologías

- **Framework:** Flutter
- **Lenguaje:** Dart
- **State Management:** flutter_bloc (modo niño/padre), StatefulWidget + setState (estados locales)
- **Audio:** audioplayers (reproducción de anuncios motivacionales)
- **Persistencia:** shared_preferences
- **Offline:** 100% sin conexión

## Arquitectura

Híbrida: Clean Architecture para lógica de negocio (domain/data), Simple Flutter para vistas, BLoC para el estado global de modo.

```
lib/
├── main.dart
├── app.dart
├── routes.dart
├── core/          → Constantes, tema, utilerías
├── domain/        → Entidades, repositorios abstractos, casos de uso
├── data/          → Repositorios concretos, datasources locales
├── presentation/  → Screens, widgets, BLoC de modo
└── services/      → AudioPlaybackService (wrapper de audioplayers)
```
