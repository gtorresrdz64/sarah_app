# Sarah App

App móvil con estilo **Claymorphism** y paleta **unisex morada** que guía a niños con audio motivacional en bucle mientras completan tareas del hogar, fomentando la autonomía infantil y reduciendo la fricción padre-hijo.

## Funcionalidades

### Modo Niño
1. **Pantalla de inicio** — Saludo "¡Hola Sarah!" con estrellas flotantes + botón clay circular 190dp con glow ring pulsante.
2. **Tarea activa** — Muestra la tarea asignada en una clay card con botón "¡Empezar tarea!".
3. **Guía motivacional en bucle** — Al presionar "Empezar tarea", reproduce `task_started` una vez. Durante la tarea, los audios `good_job`, `howisyourtask`, `keep_going`, `cheers` y `almost_done` se reproducen en bucle continuo con pausas de 10s. Orbe de ondas + cronómetro + mensajes motivacionales rotativos.
4. **Finalización** — Botón "¡Tarea completada!" verde bouncing. Al presionarlo, reproduce `all_done`, muestra trofeo con elastic pop + confeti + texto "¡Lo lograste!" y regresa al inicio tras 3s.

### Modo Padres
1. **Lista de tareas** — Vista con todas las tareas creadas, estado de completitud y asignación activa.
2. **Asignar tarea** — Seleccionar y asignar una tarea a Sarah con confirmación.
3. **Agregar tarea** — Crear nuevas tareas desde un formulario.
4. **Persistencia local** — Las tareas se guardan automáticamente con SharedPreferences.

## Tecnologías

- **Framework:** Flutter
- **Lenguaje:** Dart
- **State Management:** flutter_bloc (modo niño/padre), StatefulWidget + setState (estados locales)
- **Audio:** audioplayers (reproducción de 7 audios motivacionales en bucle)
- **Persistencia:** shared_preferences
- **Estilo:** Claymorphism (bordes 3-4px, sombras dobles, border-radius 20-24px)
- **Paleta:** Púrpura vivo (#8B5CF6), lavanda (#818CF8), dorado (#FBBF24), rosa arcilla (#F472B6)
- **Offline:** 100% sin conexión

## Arquitectura

Híbrida: Clean Architecture para lógica de negocio (domain/data), Simple Flutter para vistas con estilo Claymorphism, BLoC para el estado global de modo.

```
lib/
├── main.dart
├── app.dart
├── routes.dart
├── core/          → Constantes de audio, paleta de colores, tema child/parent
├── domain/        → Entidades, repositorios abstractos, casos de uso
├── data/          → Repositorios concretos, datasources locales
├── presentation/  → Screens niño/padre, widgets clay, BLoC de modo
└── services/      → AudioPlaybackService (wrapper de audioplayers)
```
