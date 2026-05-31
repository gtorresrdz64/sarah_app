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

UX-DR1: Implementar sistema de colores Material Design con primario naranja (#FF8C00), secundario azul (#42A5F5), acento verde (#66BB6A), textos gris oscuro (#212121)
UX-DR2: Configurar tema Flutter con tipografía sans-serif, botones 28-32px bold, títulos 24px, texto padre 14-16px
UX-DR3: Implementar botón de inicio animado: naranja, 80dp, animación de pulsación suave con icono de play
UX-DR4: Implementar indicador de escucha con ondas de sonido animadas + barra de progreso regresiva de 10s
UX-DR5: Implementar pantalla de celebración con check verde animado + texto "¡Completada!"
UX-DR6: Configurar espaciado base 16dp, layout centrado, botones mínimo 64dp altura con radio 16dp
UX-DR7: Implementar 4 estados visuales: inicio (botón grande), escuchando (ondas + barra), reproduciendo (progreso), completado (celebración)
UX-DR8: Implementar pantalla de gestión para padres con ListView de tareas + botón asignar
UX-DR9: Contraste alto (> 4.5:1), botones grandes (64-80dp), feedback visual + auditivo combinado
UX-DR10: Adaptar layout a pantallas Android 360-480px, orientación portrait, escalado con MediaQuery

### FR Coverage Map

FR1: Epic 1 - Iniciar escucha de voz
FR2: Epic 1 - Detectar comando "Sarah ponte a hacer la tarea"
FR3: Epic 1 - Detectar comando "Sarah ordene su cama"
FR4: Epic 1 - Detectar comando "Sarah tu comida está servida"
FR5: Epic 1 - Timeout de 10s por comando
FR6: Epic 1 - Regreso al inicio si timeout
FR7: Epic 1 - Anuncio 1: "iniciemos ya"
FR8: Epic 1 - Anuncio 2: "Empecemos, vas a ver..."
FR9: Epic 1 - Anuncio 3: "Excelente Sarah, vas muy bien"
FR10: Epic 1 - Anuncio 4: "Ya casi terminamos"
FR11: Epic 1 - Anuncio 5: "Bien hecho..."
FR12: Epic 1 - Pausa de 10s entre anuncios
FR13: Epic 1 - Regreso al inicio al finalizar
FR14: Epic 2 - Ver tareas disponibles
FR15: Epic 2 - Asignar tarea
FR16: Epic 2 - Ver tarea asignada
FR17: Epic 1 - Pantalla de inicio con botón
FR18: Epic 1 - Indicar estado "escuchando"
FR19: Epic 1 - Indicar estado "reproduciendo"
FR20: Epic 1 - Indicar estado "completado"
FR21: Epic 2 - Almacenar tareas localmente
FR22: Epic 2 - Funcionar sin conexión

## Epic 1: Flujo de Tareas por Voz

El niño puede iniciar la app, decir el comando de voz correspondiente a la tarea asignada, y recibir guía motivacional paso a paso hasta completarla.

### Story 1.1: Pantalla de inicio con botón de iniciar

Como **niño (Sarah)**,
Quiero **ver una pantalla con un botón grande para presionar y comenzar**,
Para **poder iniciar el proceso de completar mi tarea sin ayuda**.

**Criterios de Aceptación:**

**Dado** que la app se abre,
**Cuando** la pantalla de inicio se muestra,
**Entonces** debe haber un botón grande (80dp) de color naranja en el centro con animación de pulsación suave
**Y** el botón debe tener un icono de play y texto "Presiona para comenzar"

### Story 1.2: Escucha y reconocimiento de comandos de voz

Como **niño (Sarah)**,
Quiero **que la app escuche mi comando de voz después de presionar el botón y reconozca si digo la tarea correcta**,
Para **poder activar la guía para completar la tarea**.

**Criterios de Aceptación:**

**Dado** que presioné el botón de inicio,
**Cuando** la app entra en modo escucha,
**Entonces** debe mostrar la animación de ondas de sonido y la barra de progreso regresiva de 10s
**Y** debe detectar el comando "Sarah ponte a hacer la tarea"
**Y** debe detectar el comando "Sarah ordene su cama"
**Y** debe detectar el comando "Sarah tu comida está servida"
**Y** debe reconocer el comando en menos de 2s desde que termino de hablar
**Dado** que pasaron 10s sin detectar un comando válido,
**Cuando** el timeout se cumple,
**Entonces** la app debe regresar suavemente a la pantalla de inicio sin mensaje de error

### Story 1.3: Guía motivacional por audio con pausas

Como **niño (Sarah)**,
Quiero **escuchar anuncios motivacionales mientras completo la tarea**,
Para **sentirme guiada y motivada hasta terminar**.

**Criterios de Aceptación:**

**Dado** que el comando de voz fue reconocido,
**Cuando** comienza la guía,
**Entonces** debe reproducir `task_started` una sola vez
**Y** al terminar, debe reproducir en bucle continuo la secuencia [good_job, keep_going, almost_done] con pausas de 10s ±0.5s entre cada anuncio
**Y** cada anuncio debe comenzar en menos de 1s desde su activación
**Dado** que el bucle está activo,
**Cuando** el usuario presiona "¡Tarea completada!",
**Entonces** debe detener el bucle inmediatamente
**Y** debe reproducir `all_done` y mostrar la pantalla de celebración

### Story 1.4: Estados visuales del ciclo de tarea

Como **niño (Sarah)**,
Quiero **ver en la pantalla en qué etapa del proceso estoy**,
Para **saber si estoy siendo escuchado, si la app está hablando, o si ya terminé**.

**Criterios de Aceptación:**

**Dado** que la app está en modo escucha,
**Cuando** se activa la escucha,
**Entonces** debe mostrar ondas de sonido animadas + barra de progreso regresiva
**Dado** que la app está reproduciendo anuncios,
**Cuando** comienza la guía,
**Entonces** debe mostrar un indicador de progreso visual
**Dado** que la tarea fue completada,
**Cuando** termina el último anuncio,
**Entonces** debe mostrar una pantalla con check verde animado y texto "¡Completada!"
**Y** después de 2s debe regresar a la pantalla de inicio

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
