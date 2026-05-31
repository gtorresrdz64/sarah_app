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
**Date:** 2026-05-26

## Resumen Ejecutivo

Sarah App es una aplicación móvil en Flutter que usa **comandos de voz** para guiar a niños en tareas del hogar. Los padres gestionan las tareas desde la app; el niño solo **escucha** — la app anuncia la tarea, motiva con mensajes progresivos y reconoce el logro al completarla.

Resuelve la **fricción padre-hijo** en la asignación y seguimiento de tareas, promoviendo la **autonomía infantil** sin supervisión constante ni pantallas interactivas. Dirigida a niños que necesitan **estructura y guía auditiva** para mantener el enfoque.

### Qué la hace especial

El niño solo necesita escuchar. No requiere leer, tocar la pantalla ni interactuar activamente. La app anuncia la tarea, motiva durante el proceso y cierra con reconocimiento del logro. Es un acompañante por voz que reemplaza la supervisión parental constante.

### Clasificación del Proyecto

- **Tipo:** Mobile App (Flutter)
- **Dominio:** EdTech
- **Complejidad:** Baja (MVP)
- **Contexto:** Greenfield

## Criterios de Éxito

### Éxito de Usuario

- El niño completa la tarea guiado por voz sin intervención del padre
- Los padres gestionan tareas desde la app de forma intuitiva

### Éxito de Negocio

- MVP funcional en **2 semanas**
- **Client Validation:** el padre valida que el concepto resuelve la fricción y fomenta la autonomía

### Éxito Técnico

- Reconocimiento preciso de los 3 comandos de voz
- Timeout de 10s funciona correctamente
- Anuncios se reproducen sin cortes con pausas exactas de 10s

### Resultados Medibles

- Tasa de finalización de tareas sin intervención parental
- Precisión de reconocimiento de voz > 90%
- Ciclo completo de tarea (inicio a fin) sin errores

## User Journeys

### Journey 1: Sarah completa una tarea

**Persona:** Sarah, 6 años, necesita estructura para mantenerse enfocada.

- **Apertura:** Sarah llega a casa. Los padres ya asignaron "ordenar tu cama" desde la app.
- **Acción:** Sarah abre la app y presiona *Iniciar*.
- **Descubrimiento:** La app activa el micrófono y espera hasta 10s.
- **Clímax:** Sarah dice "Sarah ordene su cama". La app reconoce el comando e inicia los anuncios motivacionales con pausas de 10s.
- **Resolución:** Sarah completa la tarea guiada. La app regresa a la pantalla de inicio.

### Journey 2: El padre asigna una tarea

**Persona:** Mamá/Papá, necesita reducir la fricción en las rutinas diarias.

- **Apertura:** Es de mañana y necesita que Sarah ordene su cuarto después de la escuela.
- **Acción:** Abre la app, selecciona "ordenar tu cama" y la asigna.
- **Clímax:** La app confirma la asignación. El padre sabe que Sarah recibirá la guía por voz al activar la app.
- **Resolución:** El padre continúa su día sin supervisar. La app gestiona el recordatorio y la motivación.

## Alcance del Producto

### MVP (Fase 1) — 2 semanas

- Pantalla de inicio con botón de iniciar
- Reconocimiento de voz offline con 3 frases exactas predefinidas
- Timeout de 10s si no detecta comando válido, con indicación visual
- 5 anuncios motivacionales pregrabados con pausas de 10s
- Gestión de tareas por el padre (asignar tarea)
- Almacenamiento local offline
- Regreso a pantalla de inicio al finalizar el ciclo

### Fase 2 (Post-MVP)

- Reconocimiento de voz flexible (NLP)
- Notificaciones push y WhatsApp al completar tarea

### Fase 3 (Expansión)

- Múltiples perfiles de niños
- Comandos y tareas personalizables
- Multilenguaje
- Gamificación y estadísticas para padres

### Estrategia de Riesgos

- **Técnico:** Reconocimiento limitado a frases exactas. Fallback a botones manuales si falla.
- **Mercado:** Client Validation en 2 semanas define el éxito del concepto.
- **Recursos:** Si es necesario, reducir a 2-3 anuncios y 1 tarea predefinida.

## Requerimientos Técnicos (Mobile App)

### Plataforma

- **Framework:** Flutter
- **Target MVP:** Android
- **Offline:** 100% sin conexión a internet

### Permisos de Dispositivo

- Micrófono (captura de comandos de voz)
- Parlante (reproducción de anuncios)

### Arquitectura

- Reconocimiento de voz on-device (sin APIs cloud)
- Almacenamiento local de tareas (sin backend)
- Reproducción de audio con pausas programadas de 10s y bucle continuo
- UI mínima: pantalla de inicio con botón, sin distracciones

## Requerimientos Funcionales

### Recepción de Comandos de Voz
- FR1: El niño puede iniciar la escucha de voz desde la pantalla de inicio
- FR2: El sistema puede detectar "Sarah ponte a hacer la tarea"
- FR3: El sistema puede detectar "Sarah ordene su cama"
- FR4: El sistema puede detectar "Sarah tu comida está servida"
- FR5: El sistema puede esperar hasta 10s por un comando válido
- FR6: El sistema puede regresar al inicio si no detecta un comando en 10s

### Guía por Audio
- FR7: El sistema puede reproducir "Sarah nos han asignado la tarea de [tarea], iniciemos ya" al presionar Comenzar
- FR8: El sistema puede reproducir en bucle continuo "Empecemos, vas a ver que rápido salimos de esta tarea", "Excelente Sarah, vas muy bien" y "Ya casi terminamos" con pausas de 10s
- FR9: El sistema puede detener el bucle de audio al presionar "Tarea completada"
- FR10: El sistema puede reproducir "Bien hecho Sarah, lo hiciste muy bien" solo al presionar "Tarea completada"
- FR11: El sistema puede reproducir los anuncios en menos de 1s desde su activación
- FR12: El sistema puede hacer una pausa de 10s entre cada anuncio
- FR13: El sistema puede regresar al inicio al finalizar el último anuncio

### Gestión de Tareas (Padres)
- FR14: El padre puede ver las tareas disponibles
- FR15: El padre puede asignar una tarea a Sarah
- FR16: El padre puede ver la tarea actualmente asignada

### Navegación y Estados
- FR17: El sistema puede mostrar una pantalla de inicio con botón de iniciar
- FR18: El sistema puede indicar que está escuchando
- FR19: El sistema puede indicar que está reproduciendo anuncios
- FR20: El sistema puede indicar que la tarea ha sido completada

### Persistencia Local
- FR21: El sistema puede almacenar tareas localmente en el dispositivo
- FR22: El sistema funciona completamente sin conexión a internet

## Requerimientos No Funcionales

### Rendimiento
- NFR1: Reconocimiento de voz responde en < 2s desde que el niño termina de hablar
- NFR2: Anuncios de audio comienzan en < 1s desde su activación
- NFR3: Pausas de 10s con precisión de ±0.5s
- NFR4: App inicia y está lista en < 3s

### Accesibilidad
- NFR5: Interfaz con contraste alto y colores llamativos para niños
- NFR6: Botones grandes y fáciles de presionar
- NFR7: Anuncios de audio claros y en volumen audible
- NFR8: Timeout de 10s indicado visualmente (animación o cuenta regresiva)

### Confiabilidad
- NFR9: La app no crashea durante el ciclo completo voz-anuncios-fin
- NFR10: Las tareas asignadas persisten incluso si la app se cierra
