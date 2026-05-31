---
stepsCompleted:
  - step-01-validate-prerequisites
  - step-02-design-epics
  - step-03-create-stories
  - step-04-final-validation
inputDocuments:
  - source: PRD
    path: /home/gustavo/Documentos/Proyectos/sarah_app/_bmad-output/planning/prd.md
  - source: UX Design Specification
    path: /home/gustavo/Documentos/Proyectos/sarah_app/_bmad-output/planning/ux-design-specification.md
workflowType: 'epics'
---

# sarah_app - Epic Breakdown

## Overview

Este documento contiene el desglose completo de épicas e historias para sarah_app, descomponiendo los requerimientos del PRD, UX Design y Arquitectura en historias implementables.

## Requirements Inventory

### Functional Requirements

FR1: El niño puede iniciar la escucha de voz desde la pantalla de inicio
FR2: El sistema puede detectar "Sarah ponte a hacer la tarea"
FR3: El sistema puede detectar "Sarah ordene su cama"
FR4: El sistema puede detectar "Sarah tu comida está servida"
FR5: El sistema puede esperar hasta 10s por un comando válido
FR6: El sistema puede regresar al inicio si no detecta un comando en 10s
FR7: El sistema puede reproducir "Sarah nos han asignado la tarea de [tarea], iniciemos ya"
FR8: El sistema puede reproducir "Empecemos, vas a ver que rápido salimos de esta tarea"
FR9: El sistema puede reproducir "Excelente Sarah, vas muy bien"
FR10: El sistema puede reproducir "Ya casi terminamos"
FR11: El sistema puede reproducir "Bien hecho Sarah, lo hiciste muy bien"
FR12: El sistema puede hacer una pausa de 10s entre cada anuncio
FR13: El sistema puede regresar al inicio al finalizar el último anuncio
FR14: El padre puede ver las tareas disponibles
FR15: El padre puede asignar una tarea a Sarah
FR16: El padre puede ver la tarea actualmente asignada
FR17: El sistema puede mostrar una pantalla de inicio con botón de iniciar
FR18: El sistema puede indicar que está escuchando
FR19: El sistema puede indicar que está reproduciendo anuncios
FR20: El sistema puede indicar que la tarea ha sido completada
FR21: El sistema puede almacenar tareas localmente en el dispositivo
FR22: El sistema funciona completamente sin conexión a internet

### NonFunctional Requirements

NFR1: Reconocimiento de voz responde en < 2s desde que el niño termina de hablar
NFR2: Anuncios de audio comienzan en < 1s desde su activación
NFR3: Pausas de 10s con precisión de ±0.5s
NFR4: App inicia y está lista en < 3s
NFR5: Interfaz con contraste alto y colores llamativos para niños
NFR6: Botones grandes y fáciles de presionar
NFR7: Anuncios de audio claros y en volumen audible
NFR8: Timeout de 10s indicado visualmente (animación o cuenta regresiva)
NFR9: La app no crashea durante el ciclo completo voz-anuncios-fin
NFR10: Las tareas asignadas persisten incluso si la app se cierra

### Additional Requirements

No Architecture document found. No additional technical requirements extracted.

### UX Design Requirements

- UX-DR1: Implementar paleta unisex morada: primario púrpura vivo (#8B5CF6), secundario lavanda (#818CF8), acento dorado (#FBBF24), rosa arcilla (#F472B6), fondo blanco lavanda (#FAF5FF), textos púrpura profundo (#2E1065)
- UX-DR2: Implementar estilo Claymorphism: bordes 3-4px, sombras dobles (outer drop + ambient), border-radius 20-24px, efecto de presión al tocar (0.93x scale, 120ms)
- UX-DR3: Configurar tema Flutter con childTheme y parentTheme separados
- UX-DR4: Implementar botón clay de inicio: púrpura, 190dp circular, borde 4px más oscuro, glow ring pulsante, icono play + texto "¡Comenzar!"
- UX-DR5: Implementar clay card para tarea: border-radius 24, padding 24, borde 3px semi-transparente, sombras dobles
- UX-DR6: Implementar orbe de ondas de audio: 3 anillos concéntricos expandiéndose (púrpura, lavanda, dorado) con core orb e icono volume_up
- UX-DR7: Implementar animación de celebración: trofeo con elasticOut scale + confeti particle system (18 partículas CustomPainter, colores de la paleta)
- UX-DR8: Implementar pill motivacional: mensajes rotativos con fade transition cada 5s
- UX-DR9: Implementar cronómetro: texto 52px w900 con tabular figures en clay card
- UX-DR10: Implementar 3 estados visuales: idle (tarea + empezar), playing (orbe + timer + botón completar bouncing), completed (trofeo + confeti + texto)

### FR Coverage Map

FR1: Epic 1 - Mostrar saludo con estrellas flotantes
FR2: Epic 1 - Botón clay circular 190dp "¡Comenzar!"
FR3: Epic 1 - Chip "Modo padres" en esquina
FR4: Epic 1 - Banner de racha "¡Sigue así, campeona!"
FR5: Epic 1 - Mostrar nombre de tarea activa en clay card
FR6: Epic 1 - Botón "¡Empezar tarea!" púrpura
FR7: Epic 1 - Mensaje "No hay tareas asignadas" si no hay tarea
FR8: Epic 1 - Reproducir task_started una vez
FR9: Epic 1 - Bucle continuo good_job/howisyourtask/keep_going/cheers/almost_done
FR10: Epic 1 - Detener bucle al presionar completar
FR11: Epic 1 - Reproducir all_done al completar
FR12: Epic 1 - Pausa de 10s entre anuncios
FR13: Epic 1 - Audio comienza en < 1s
FR14: Epic 1 - Cronómetro de tiempo transcurrido
FR15: Epic 1 - Orbe animado con ondas de sonido
FR16: Epic 1 - Mensajes motivacionales rotativos
FR17: Epic 1 - Botón "¡Tarea completada!" verde bouncing
FR18: Epic 1 - Marcar tarea completada
FR19: Epic 1 - Animación trofeo + confeti
FR20: Epic 1 - Regreso al inicio tras 3s
FR21: Epic 2 - Ver tareas disponibles
FR22: Epic 2 - Asignar tarea a Sarah
FR23: Epic 2 - Ver tarea asignada
FR24: Epic 2 - Crear nuevas tareas
FR25: Epic 2 - Almacenar tareas localmente
FR26: Epic 2 - Funcionar sin conexión

## Epic 1: Flujo de Tareas Táctil con Audio

El niño puede iniciar la app, ver un saludo, presionar botones clay grandes para navegar y recibir guía motivacional en bucle hasta completar la tarea.

### Story 1.1: Pantalla de inicio con saludo y botón clay

Como **niño (Sarah)**,
Quiero **ver una pantalla alegre con mi nombre, estrellas y un botón grande para comenzar**,
Para **sentirme bienvenida y poder iniciar mi tarea sin ayuda**.

**Criterios de Aceptación:**

**Dado** que la app se abre,
**Cuando** la pantalla de inicio se muestra,
**Entonces** debe mostrar el texto "¡Hola Sarah!" en 36px w900 con estrellas decorativas flotantes arriba
**Y** debe haber un botón clay circular grande (190dp) de color púrpura (#8B5CF6) en el centro
**Y** el botón debe tener borde 4px más oscuro (#7C3AED), sombras dobles, icono play + texto "¡Comenzar!"
**Y** debe tener un glow ring pulsante (opacidad 0.45→0.0, escala 1.0→1.35, 1400ms loop)
**Y** debe tener efecto de presión al tocar (escala 0.93x, 120ms ease-out)
**Dado** que hay una tarea asignada,
**Cuando** el niño presiona "¡Comenzar!",
**Entonces** debe navegar a la pantalla de tarea activa

### Story 1.2: Visualización de tarea activa e inicio de guía

Como **niño (Sarah)**,
Quiero **ver qué tarea me asignaron y poder empezar cuando esté lista**,
Para **saber exactamente qué tengo que hacer y sentirme en control**.

**Criterios de Aceptación:**

**Dado** que entro a la pantalla de tarea,
**Cuando** hay una tarea activa asignada,
**Entonces** debe mostrar una clay card (border-radius 24, borde 3px, sombras dobles) con icono de tarea + nombre de la tarea en 28px w800
**Y** debe mostrar un botón clay púrpura "¡Empezar tarea!" con icono play
**Dado** que no hay tareas asignadas,
**Cuando** se carga la pantalla,
**Entonces** debe mostrar un mensaje "No hay tareas asignadas" con icono de bandeja vacía
**Y** debe mostrar texto "Pídele a un adulto que te asigne una"
**Dado** que presiono "¡Empezar tarea!",
**Cuando** comienza la guía,
**Entonces** debe reproducir `task_started` una sola vez
**Y** debe iniciar el cronómetro de tiempo transcurrido

### Story 1.3: Guía motivacional por audio en bucle

Como **niño (Sarah)**,
Quiero **escuchar anuncios motivacionales que se repiten mientras hago mi tarea**,
Para **sentirme guiada, motivada y acompañada hasta terminar**.

**Criterios de Aceptación:**

**Dado** que la guía está activa,
**Cuando** termina `task_started`,
**Entonces** después de 10s debe reproducir `good_job`
**Y** luego debe reproducir en bucle continuo la secuencia [good_job, howisyourtask, keep_going, cheers, almost_done] con pausas de 10s ±0.5s entre cada anuncio
**Y** cada anuncio debe comenzar en menos de 1s desde su activación
**Dado** que el bucle está activo,
**Cuando** el usuario presiona "¡Tarea completada!",
**Entonces** debe detener el bucle inmediatamente
**Y** debe reproducir `all_done`
**Y** el bucle debe continuar indefinidamente hasta que se presione completar

### Story 1.4: Estados visuales durante la tarea

Como **niño (Sarah)**,
Quiero **ver en la pantalla el progreso de mi tarea con animaciones divertidas**,
Para **saber que la app está activa, cuánto tiempo llevo, y celebrar cuando termino**.

**Criterios de Aceptación:**

**Dado** que estoy en estado "playing",
**Cuando** el audio se reproduce,
**Entonces** debe mostrar un orbe animado con 3 anillos concéntricos expandiéndose (púrpura, lavanda, dorado) con core orb e icono volume_up
**Y** debe mostrar un cronómetro grande (52px w900, tabular figures) en una clay card
**Y** debe mostrar mensajes motivacionales rotativos ("¡Tú puedes!", "¡Vas genial!", etc.) con fade transition cada 5s
**Y** debe mostrar un botón "¡Tarea completada!" verde (verde menta #34D399) con animación bouncing (escala 1.0↔1.04, 900ms)
**Dado** que la tarea fue completada,
**Cuando** presiono "¡Tarea completada!",
**Entonces** debe mostrar animación de trofeo con elasticOut scale + confeti particle system (18 partículas de colores de la paleta)
**Y** debe mostrar texto "¡Lo lograste!" + "¡Eres una campeona!"
**Y** después de 3s debe regresar a la pantalla de inicio

## Epic 2: Gestión de Tareas para Padres

El padre puede ver las tareas disponibles, asignar una tarea a Sarah, y la app persiste los datos localmente sin conexión a internet.

### Story 2.1: Vista de tareas para padres

Como **padre o madre**,
Quiero **ver una lista de tareas disponibles y saber cuál está asignada actualmente**,
Para **saber qué tarea debe completar Sarah y gestionar las rutinas**.

**Criterios de Aceptación:**

**Dado** que abro la sección de gestión de tareas,
**Cuando** la vista se carga,
**Entonces** debe mostrar una lista (ListView) con las tareas disponibles
**Y** debe indicar claramente cuál tarea está actualmente asignada a Sarah
**Y** debe tener botones de texto/icono estándar Material Design

### Story 2.2: Asignar tarea a Sarah

Como **padre o madre**,
Quiero **seleccionar una tarea y asignársela a Sarah**,
Para **que cuando Sarah abra la app, sepa qué tarea debe completar**.

**Criterios de Aceptación:**

**Dado** que estoy en la lista de tareas,
**Cuando** selecciono una tarea y confirmo la asignación,
**Entonces** debe mostrar un diálogo de confirmación (AlertDialog)
**Y** al confirmar, la tarea queda asignada a Sarah
**Y** la vista debe actualizarse mostrando la nueva tarea activa

### Story 2.3: Almacenamiento local y modo offline

Como **padre o madre**,
Quiero **que las tareas se guarden en el dispositivo y la app funcione sin internet**,
Para **que Sarah pueda usar la app en cualquier momento sin conexión**.

**Criterios de Aceptación:**

**Dado** que asigno una tarea,
**Cuando** la app guarda los datos,
**Entonces** debe almacenar la tarea localmente en el dispositivo
**Y** las tareas deben persistir incluso si la app se cierra
**Dado** que el dispositivo no tiene conexión a internet,
**Cuando** la app se abre,
**Entonces** debe funcionar completamente sin conexión
