---
classification:
  projectType: mobile_app
  domain: edtech
  complexity: low
  projectContext: greenfield
stepsCompleted:
  - step-01-init
  - step-02-discovery
  - step-02b-vision
  - step-02c-executive-summary
  - step-03-success
  - step-04-journeys
  - step-05-domain
  - step-06-innovation
  - step-07-project-type
  - step-08-scoping
  - step-09-functional
  - step-10-nonfunctional
  - step-11-polish
inputDocuments:
  - source: Sarah App.md
    path: /home/gustavo/Documentos/Proyectos/sarah_app/_bmad-output/planning/Sarah App.md
documentCounts:
  briefs: 1
  research: 0
  brainstorming: 0
  projectDocs: 0
workflowType: 'prd'
---

# Product Requirements Document - sarah_app

**Author:** Gustavo
**Date:** 2026-05-30

## Resumen Ejecutivo

Sarah App es una aplicación móvil en Flutter que usa **audio motivacional en bucle** para guiar a niños en tareas del hogar. Los padres gestionan las tareas desde la app; el niño solo **presiona botones grandes y escucha** — la app anuncia la tarea, motiva con mensajes progresivos en bucle y celebra el logro al completarla.

Resuelve la **fricción padre-hijo** en la asignación y seguimiento de tareas, promoviendo la **autonomía infantil** con interacción táctil mínima. Dirigida a niños que necesitan **estructura y guía auditiva** para mantener el enfoque.

### Qué la hace especial

El niño solo presiona botones grandes estilo clay y escucha. No requiere leer ni navegar. La app anuncia la tarea, motiva durante el proceso con un bucle de 5 audios y cierra con celebración visual (trofeo + confeti). Es un acompañante interactivo con estética Claymorphism y paleta unisex morada.

### Clasificación del Proyecto

- **Tipo:** Mobile App (Flutter)
- **Dominio:** EdTech
- **Complejidad:** Baja (MVP)
- **Contexto:** Greenfield

## Criterios de Éxito

### Éxito de Usuario

- El niño completa la tarea guiado por audio y botones grandes sin intervención del padre
- Los padres gestionan tareas desde la app de forma intuitiva

### Éxito de Negocio

- MVP funcional en **2 semanas**
- **Client Validation:** el padre valida que el concepto resuelve la fricción y fomenta la autonomía

### Éxito Técnico

- Bucle de audio se reproduce correctamente con pausas exactas de 10s
- Animación de celebración (trofeo + confeti) se muestra al completar
- Transiciones entre estados (idle → playing → completed) sin errores

### Resultados Medibles

- Tasa de finalización de tareas sin intervención parental
- Ciclo completo de tarea (inicio a fin) sin errores
- Tiempo de inicio de la app < 3s

## User Journeys

### Journey 1: Sarah completa una tarea

**Persona:** Sarah, 6 años, necesita estructura para mantenerse enfocada.

- **Apertura:** Sarah llega a casa. Los padres ya asignaron "ordenar tu cama" desde la app.
- **Acción:** Sarah abre la app y presiona el botón clay grande **"¡Comenzar!"**.
- **Descubrimiento:** Ve su tarea "ordenar tu cama" en una clay card y presiona **"¡Empezar tarea!"**.
- **Clímax:** La app reproduce `task_started` una vez y luego inicia el bucle motivacional (`good_job` → `howisyourtask` → `keep_going` → `cheers` → `almost_done`) con pausas de 10s. Sarah ve el cronómetro y escucha la guía mientras trabaja.
- **Resolución:** Sarah presiona **"¡Tarea completada!"**, la app reproduce `all_done`, muestra trofeo con confeti y regresa al inicio.

### Journey 2: El padre asigna una tarea

**Persona:** Mamá/Papá, necesita reducir la fricción en las rutinas diarias.

- **Apertura:** Es de mañana y necesita que Sarah ordene su cuarto después de la escuela.
- **Acción:** Abre la app, va al modo padres, selecciona "ordenar tu cama" y la asigna.
- **Clímax:** La app confirma la asignación. El padre sabe que Sarah recibirá la guía auditiva al presionar el botón.
- **Resolución:** El padre continúa su día sin supervisar. La app gestiona el recordatorio y la motivación.

## Alcance del Producto

### MVP (Fase 1) — 2 semanas

- Pantalla de inicio con saludo "¡Hola Sarah!" + estrellas + botón clay circular 190dp
- Información de tarea activa en clay card
- Botón "¡Empezar tarea!" que inicia el bucle de audio
- 7 audios motivacionales pregrabados con bucle continuo y pausas de 10s
- Cronómetro de tiempo transcurrido
- Botón "¡Tarea completada!" con animación de trofeo + confeti
- Gestión de tareas por el padre (asignar, crear, listar)
- Almacenamiento local offline
- Estilo visual Claymorphism con paleta unisex morada
- Temas separados childTheme / parentTheme

### Fase 2 (Post-MVP)

- Notificaciones al completar tarea
- Personalización de avatar infantil

### Fase 3 (Expansión)

- Múltiples perfiles de niños
- Más tipos de tareas y personalización de audio
- Multilenguaje
- Gamificación y estadísticas para padres

### Estrategia de Riesgos

- **Técnico:** Audio no se reproduce en algunos dispositivos — fallback a vibración/notificación visual.
- **Mercado:** Client Validation en 2 semanas define el éxito del concepto.
- **Recursos:** Si es necesario, reducir a 5 audios y animación más simple.

## Requerimientos Técnicos (Mobile App)

### Plataforma

- **Framework:** Flutter
- **Target MVP:** Android
- **Offline:** 100% sin conexión a internet

### Permisos de Dispositivo

- Parlante (reproducción de anuncios)
- Ningún otro permiso requerido

### Arquitectura

- Híbrida: Clean Architecture (domain/data) + Simple Flutter (presentation) + BLoC (modo niño/padre)
- Almacenamiento local de tareas con SharedPreferences (sin backend)
- Reproducción de audio con pausas programadas de 10s y bucle continuo
- UI Claymorphism minimalista con paleta unisex morada
- Temas separados childTheme / parentTheme

## Requerimientos Funcionales

### Pantalla de Inicio (Niño)
- FR1: El sistema puede mostrar un saludo "¡Hola Sarah!" con estrellas decorativas flotantes
- FR2: El sistema puede mostrar un botón clay circular grande (190dp) con icono play y texto "¡Comenzar!"
- FR3: El sistema puede mostrar un chip "Modo padres" en la esquina superior derecha
- FR4: El sistema puede mostrar un banner de racha "¡Sigue así, campeona!" en la parte inferior

### Asignación y Visualización de Tarea
- FR5: El sistema puede mostrar el nombre de la tarea activa asignada en una clay card
- FR6: El sistema puede mostrar un botón "¡Empezar tarea!" púrpura
- FR7: El sistema puede indicar que no hay tareas asignadas con mensaje amigable

### Guía por Audio en Bucle
- FR8: El sistema puede reproducir `task_started` una sola vez al presionar "Empezar tarea"
- FR9: El sistema puede reproducir en bucle continuo la secuencia [good_job, howisyourtask, keep_going, cheers, almost_done] con pausas de 10s
- FR10: El sistema puede detener el bucle de audio inmediatamente al presionar "Tarea completada"
- FR11: El sistema puede reproducir `all_done` solo al presionar "Tarea completada"
- FR12: El sistema puede reproducir los anuncios en menos de 1s desde su activación
- FR13: El sistema puede hacer una pausa de 10s entre cada anuncio

### Seguimiento Visual
- FR14: El sistema puede mostrar un cronómetro con el tiempo transcurrido durante la tarea
- FR15: El sistema puede mostrar un orbe animado con ondas de sonido mientras reproduce audio
- FR16: El sistema puede mostrar mensajes motivacionales rotativos ("¡Tú puedes!", "¡Vas genial!", etc.)

### Finalización de Tarea
- FR17: El sistema puede mostrar un botón "¡Tarea completada!" verde con animación bouncing en estado playing
- FR18: El sistema puede marcar la tarea como completada al presionar el botón
- FR19: El sistema puede mostrar una animación de trofeo con elastic pop + confeti al completar
- FR20: El sistema puede mostrar texto "¡Lo lograste!" + "¡Eres una campeona!" y regresar al inicio tras 3s

### Gestión de Tareas (Padres)
- FR21: El padre puede ver las tareas disponibles en una lista
- FR22: El padre puede asignar una tarea a Sarah
- FR23: El padre puede ver la tarea actualmente asignada
- FR24: El padre puede crear nuevas tareas desde un formulario

### Persistencia Local
- FR25: El sistema puede almacenar tareas localmente en el dispositivo
- FR26: El sistema funciona completamente sin conexión a internet

## Requerimientos No Funcionales

### Rendimiento
- NFR1: Anuncios de audio comienzan en < 1s desde su activación
- NFR2: Pausas de 10s con precisión de ±0.5s
- NFR3: App inicia y está lista en < 3s
- NFR4: Animaciones (trofeo, confeti) se renderizan a 60fps

### Accesibilidad
- NFR5: Interfaz con contraste alto (texto #2E1065 sobre fondo #FAF5FF)
- NFR6: Botones grandes clay-style (mínimo 72px altura, 190dp el circular)
- NFR7: Anuncios de audio claros y en volumen audible
- NFR8: Feedback visual + auditivo siempre presente

### Estilo Visual
- NFR9: Estilo Claymorphism con bordes 3-4px, sombras dobles, border-radius 20-24px
- NFR10: Paleta unisex morada: púrpura vivo (#8B5CF6), lavanda (#818CF8), dorado (#FBBF24)

### Confiabilidad
- NFR11: La app no crashea durante el ciclo completo audio-animación-fin
- NFR12: Las tareas asignadas persisten incluso si la app se cierra
