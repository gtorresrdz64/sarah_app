---
stepsCompleted:
  - step-01-init
  - step-02-context
  - step-03-starter
inputDocuments:
  - source: PRD
    path: /home/gustavo/Documentos/Proyectos/sarah_app/_bmad-output/planning/prd.md
  - source: UX Design Specification
    path: /home/gustavo/Documentos/Proyectos/sarah_app/_bmad-output/planning/ux-design-specification.md
  - source: Epics & Stories
    path: /home/gustavo/Documentos/Proyectos/sarah_app/_bmad-output/planning/epics.md
workflowType: 'architecture'
project_name: 'sarah_app'
user_name: 'Gustavo'
date: '2026-05-30'
---

# Architecture Decision Document

_Collaboratively built through step-by-step discovery. Sections are appended as we work through each architectural decision together._

## Project Context Analysis

### Requirements Overview

**Functional Requirements:** 26 FRs cubriendo inicio con saludo, visualización de tarea activa, guía por audio en bucle, estados visuales (idle/playing/completed), gestión de padres, persistencia.

**Non-Functional Requirements:** 12 NFRs cubriendo rendimiento (< 1s audio, ±0.5s pausas, < 3s inicio), accesibilidad (contraste alto #2E1065/#FAF5FF, botones 72-190dp), estilo visual (Claymorphism, paleta morada), confiabilidad (sin crashes, persistencia).

**Scale & Complexity:**
- Primary domain: Mobile App (Flutter Android)
- Complexity level: Baja
- Estimated architectural components: 4 (UI niño, UI padre, audio, almacenamiento local)

### Technical Constraints & Dependencies

- Offline 100% (sin conexión a internet)
- Interacción táctil con botones clay (sin reconocimiento de voz)
- Sin backend, sin API, sin sincronización cloud
- Sin autenticación de usuarios

### Cross-Cutting Concerns Identified

- Estados de UI (idle/playing/completed)
- Gestión de reproducción de audio con pausas programadas y bucle
- Animaciones Claymorphism (pulse ring, press effect, confetti particle system)
- Persistencia local de datos de tareas
- Temas separados childTheme / parentTheme

## Starter Decision: Hybrid Architecture

Se adoptó un enfoque **híbrido** combinando tres patrones según la responsabilidad:

| Capa | Patrón | Motivación |
|------|--------|-----------|
| Lógica de negocio | **Clean Architecture** | Separación dominio/datos, testabilidad, independencia de frameworks |
| Capa visual | **Simple Flutter** | MVP rápido, una acción por pantalla, sin over-engineering |
| Cambio de modo (niño↔padre) | **BLoC** | Estado global compartido, transiciones limpias, fácil de testear |

### Decisiones Clave

1. **Clean Architecture para lógica**: Separamos `domain/` (entidades, repositorios abstractos, casos de uso), `data/` (implementaciones concretas, almacenamiento local con shared_preferences/sqflite), y `presentation/` (widgets y BLoCs). Esto permite testear la lógica de dominio y persistencia sin depender de Flutter.
2. **Simple Flutter para vistas**: Las pantallas son widgets planos sin capas adicionales. No introducimos MVC/MVVM en UI porque cada pantalla tiene una sola acción.
3. **BLoC solo para modo**: Un `ModeBloc` global con dos estados (`ChildMode`, `ParentMode`). Los widgets escuchan cambios y reconstruyen la navegación raíz.

## Folder Structure

```
lib/
├── main.dart                      # Punto de entrada, configuración de BlocProvider
├── app.dart                       # Widget raíz con BlocListener + navigatorKey para cambio de modo
│
├── core/
│   ├── constants/
│   │   ├── voice_commands.dart    # (Legacy — frases de voz predefinidas, sin usar)
│   │   ├── audio_assets.dart      # Rutas a los 7 audios pregrabados
│   │   └── app_colors.dart        # Paleta Claymorphism unisex morada
│   ├── theme/
│   │   └── app_theme.dart         # childTheme y parentTheme con estilo clay
│   └── utils/
│       └── permissions_helper.dart  # (Legacy — permisos de micrófono, sin usar)
│
├── domain/
│   ├── entities/
│   │   └── task.dart              # Entidad Task: id, name, isCompleted, assignedAt
│   ├── repositories/
│   │   └── task_repository.dart   # Abstracto: getTasks, addTask, updateTask, deleteTask
│       └── usecases/
│       ├── listen_command.dart    # (Legacy — sin usar, del flujo de voz anterior)
│       ├── play_guidance.dart     # DTO para configuración de guía (legacy)
│       ├── get_tasks.dart         # Obtener todas las tareas
│       └── complete_task.dart     # Marcar tarea como completada
│
├── data/
│   ├── repositories/
│   │   └── task_repository_impl.dart  # Implementación con SharedPreferences
│   └── datasources/
│       └── local_datasource.dart      # Wrapper de persistencia local
│
├── presentation/
│   ├── bloc/
│   │   └── mode_bloc.dart         # BLoC global: ChildMode / ParentMode
│   ├── child/
│   │   ├── screens/
│   │   │   ├── child_home_screen.dart       # Pantalla inicio niño (botón grande)
│   │   │   └── child_task_screen.dart       # Pantalla tarea: comenzar → audio + timer → completar
│   │   └── widgets/
│   │       ├── listening_indicator.dart      # Indicador sonar (legacy, sin usar en flujo actual)
│   │       └── completion_animation.dart     # Trofeo elastic + confeti particle system
│   └── parent/
│       ├── screens/
│       │   ├── parent_home_screen.dart       # Lista de tareas del hijo
│       │   └── parent_add_task_screen.dart   # Asignar nueva tarea
│       └── widgets/
│           ├── task_card.dart                # Card de tarea individual
│           └── task_form.dart                # Formulario para nueva tarea
│
├── services/
│   ├── voice_recognition_service.dart    # (Legacy — sin usar, del flujo de voz anterior)
│   └── audio_playback_service.dart       # Wrapper de audioplayers para reproducción y bucle
│
└── routes.dart                         # Definición de rutas por modo
```

## Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│                                                             │
│  ┌──────────────────────────────┐  ┌────────────────────┐  │
│  │     Child Screens/Widgets    │  │  Parent Screens/    │  │
│  │     (Simple Flutter)         │  │  Widgets            │  │
│  └─────────────┬────────────────┘  │  (Simple Flutter)   │  │
│                │                   └──────────┬─────────┘  │
│                │                              │            │
│  ┌─────────────┴──────────────────────────────┴─────────┐  │
│  │                   ModeBloc (BLoC)                     │  │
│  │         ChildMode │ ParentMode (estado global)        │  │
│  └────────────────────────┬──────────────────────────────┘  │
│                           │                                  │
├───────────────────────────┼──────────────────────────────────┤
│                  DOMAIN LAYER                                │
│  ┌────────────────────────┴──────────────────────────────┐  │
│  │                    Use Cases                           │  │
│  │  listen_command  │ play_guidance  │ get_tasks  │ ...  │  │
│  └────────┬─────────┘──────┬────────┘──────┬────────────┘  │
│           │                │               │                │
│  ┌────────┴────────────────┴───────────────┴────────────┐  │
│  │              TaskRepository (abstract)                │  │
│  └───────────────────────┬──────────────────────────────┘  │
│                          │                                  │
├──────────────────────────┼──────────────────────────────────┤
│                DATA LAYER                                   │
│  ┌──────────────────────┴──────────────────────────────┐  │
│  │              TaskRepositoryImpl                      │  │
│  └──────────────────────┬──────────────────────────────┘  │
│                         │                                  │
│  ┌──────────────────────┴──────────────────────────────┐  │
│  │              LocalDataSource (SharedPreferences)     │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                    SERVICES                                 │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ AudioPlayback (audioplayers)                         │  │
│  │ Reproducción y bucle de 7 audios motivacionales      │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

### Modo Niño: Completar tarea

```
ChildHomeScreen (saludo + botón clay 190dp) → Navigator.push a ChildTaskScreen
  → TaskRepository.getTasks → muestra tarea activa en clay card
  → Niño presiona "¡Empezar tarea!" → AudioPlaybackService.play(task_started una vez)
  → Bucle infinito [good_job, howisyourtask, keep_going, cheers, almost_done] con pausas 10s
  → Niño presiona "¡Tarea completada!" (botón verde bouncing) → CompleteTask usecase → TaskRepositoryImpl.updateTask
  → Detiene bucle → AudioPlaybackService.play(all_done)
  → Animación trofeo + confeti → 3s → Navigator.pop
```

### Modo Padre: Asignar tarea

```
Formulario → addTask usecase → TaskRepositoryImpl → LocalDataSource.save
  → actualiza lista en ParentHomeScreen
```

### Cambio de Modo

```
Toggle → ModeBloc.add(ModeChanged) → BlocBuilder en app.dart
  → reconstruye Navigator con ChildRoutes o ParentRoutes
```

## State Management Strategy

| Estado | Mecanismo | Ámbito |
|--------|-----------|--------|
| Modo (niño/padre) | `ModeCubit` + `BlocListener` | Global |
| Lista de tareas | StatefulWidget + setState | Por pantalla (ParentHomeScreen) |
| Estado de tarea (idle/playing/completed) | StatefulWidget + setState | ChildTaskScreen |
| Reproducción de audio | Llamadas directas al servicio | ChildTaskScreen |

Los datos de tareas se cargan desde `TaskRepository` en el `initState` de cada pantalla y se cachean localmente. No hay estado compartido entre niño y padre más allá de la persistencia.

## Navigation & Routes

```
/child/home         → ChildHomeScreen
/child/task         → ChildTaskScreen (sin parámetros, carga tarea activa sola)
/parent/home        → ParentHomeScreen
/parent/add-task    → ParentAddTaskScreen
```

Las rutas se definen con `onGenerateRoute` en `routes.dart`. El cambio de modo se maneja con `BlocListener` en `app.dart` que navega usando `pushNamedAndRemoveUntil` con un `GlobalKey<NavigatorState>`.

## Dependencies (pubspec.yaml)

| Paquete | Propósito |
|---------|-----------|
| `audioplayers` | Reproducción de audio pregrabado |
| `shared_preferences` | Persistencia simple de tareas |
| `flutter_bloc` | BLoC state management para modo |
| `equatable` | Comparación de estados BLoC |

> Nota: `speech_to_text` está en pubspec.yaml como dependencia legacy (del flujo de voz original) pero no se usa en el flujo activo.

## Security & Permissions

- Sin permisos especiales requeridos (la interacción es táctil y reproducción de audio)
- Sin almacenamiento de datos sensibles
- Sin comunicación de red

## ADRs (Architecture Decision Records)

### ADR-001: Clean Architecture para lógica, no para UI

**Contexto:** Necesitamos testear lógica de dominio y persistencia sin depender de Flutter.

**Decisión:** Aplicamos Clean Architecture solo en `domain/` y `data/`. La capa `presentation/` usa widgets de Flutter simples + BLoC para el modo global.

**Consecuencia:** Los casos de uso son puro Dart y testeables con `dart test`. Las pantallas son rápidas de prototipar con estilo Claymorphism.

### ADR-002: BLoC limitado al cambio de modo con BlocListener para navegación

**Contexto:** El modo niño/padre afecta todo el árbol de widgets (navigation raíz). El cambio de `initialRoute` en un `MaterialApp` reconstruido no fuerza la navegación.

**Decisión:** Un solo `ModeCubit` global con `BlocProvider`. El `MaterialApp` usa un `GlobalKey<NavigatorState>` y un `BlocListener` que ejecuta `pushNamedAndRemoveUntil` cuando el modo cambia. El `BlocBuilder` solo controla el tema.

**Consecuencia:** La navegación entre modos funciona correctamente. Se elimina la dependencia de `initialRoute` para cambios de modo.

### ADR-003: Persistencia con SharedPreferences

**Contexto:** MVP offline sin backend. Datos simples (lista de tareas con nombre y estado).

**Decisión:** Usamos `shared_preferences` con serialización JSON. Suficiente para < 50 tareas.

**Consecuencia:** Sin dependencia de SQLite. Migración trivial a sqflite si escalamos. Datos se pierden si se borra la app (aceptable para MVP).
