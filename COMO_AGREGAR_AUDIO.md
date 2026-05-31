# Guía para Agregar Archivos de Audio - Sarah App

Esta guía te ayudará a agregar y configurar correctamente los 7 archivos de audio motivacionales para el modo infantil de la aplicación **Sarah App**.

## 1. Requisitos de los Archivos de Audio

Para que la aplicación funcione correctamente y reproduzca la guía por voz en secuencia, se requieren exactamente **7 archivos de audio** con nombres y extensiones específicos.

### Nombres y Textos Sugeridos:

| Constante en el Código | Nombre de Archivo Exacto | Texto Sugerido para Grabación / TTS |
|---|---|---|
| `AudioAssets.taskStarted` | **`task_started.mp3`** | "¡Hola Sarah! Nos han asignado una tarea muy importante, ¡iniciemos ya!" |
| `AudioAssets.goodJob` | **`good_job.mp3`** | "¡Excelente Sarah, vas muy bien!" |
| `AudioAssets.howIsYourTask` | **`howisyourtask.mp3`** | "¿Cómo vas con tu tarea?" |
| `AudioAssets.keepGoing` | **`keep_going.mp3`** | "Sigue así, ya casi lo tienes." |
| `AudioAssets.cheers` | **`cheers.mp3`** | "¡Ánimo, tú puedes!" |
| `AudioAssets.almostDone` | **`almost_done.mp3`** | "¡Ya casi terminamos!" |
| `AudioAssets.allDone` | **`all_done.mp3`** | "¡Bien hecho Sarah, lo hiciste muy bien!" |

> **Nota:** La aplicación está configurada para reproducir estos audios con el siguiente orden y comportamiento:
> 1. `task_started.mp3` se reproduce una única vez al presionar el botón **"¡Empezar tarea!"** (en la pantalla de tarea activa).
> 2. Los audios intermedios (`good_job.mp3`, `howisyourtask.mp3`, `keep_going.mp3`, `cheers.mp3` y `almost_done.mp3`) se reproducen de forma secuencial y en bucle continuo (loop) durante el transcurso de la tarea, con un intervalo de **10 segundos** entre el inicio de cada reproducción.
> 3. `all_done.mp3` se reproduce únicamente al presionar el botón **"¡Tarea completada!"**, deteniendo inmediatamente cualquier audio intermedio que se encuentre reproduciéndose.

---

## 2. Instrucciones Paso a Paso para Agregar los Archivos

### Paso 2.1: Crear el directorio de audios
Abre tu terminal y asegúrate de que exista la carpeta `assets/audio` en la raíz de tu proyecto. Si no existe, puedes crearla con el siguiente comando:

```bash
mkdir -p assets/audio
```

### Paso 2.2: Guardar los archivos de audio
Copia tus 7 archivos `.mp3` grabados o generados dentro del directorio recién creado:
`assets/audio/`

Por ejemplo:
- `assets/audio/task_started.mp3`
- `assets/audio/good_job.mp3`
- `assets/audio/howisyourtask.mp3`
- `assets/audio/keep_going.mp3`
- `assets/audio/cheers.mp3`
- `assets/audio/almost_done.mp3`
- `assets/audio/all_done.mp3`

### Paso 2.3: Verificar en la terminal
Puedes verificar que los archivos estén en la ubicación correcta ejecutando:

```bash
ls -la assets/audio/
```

Deberías ver listados los 7 archivos `.mp3` mencionados anteriormente.

---

## 3. Configuración del Proyecto (Ya Realizada)

Para tu tranquilidad, los siguientes pasos ya se encuentran configurados en el proyecto, pero es importante que los conozcas:

1. **Declaración en `pubspec.yaml`**:
   Los archivos de esta carpeta ya están habilitados en Flutter dentro de la sección de recursos:
   ```yaml
   flutter:
     assets:
       - assets/audio/
   ```

2. **Mapeo de Constantes**:
   En el archivo `lib/core/constants/audio_assets.dart` ya se encuentran mapeadas las rutas correctas correspondientes a cada uno de los archivos.

---

## 4. Ejecución y Pruebas

Una vez que hayas copiado los archivos en la carpeta `assets/audio/`, ejecuta los siguientes comandos para actualizar las referencias y compilar la aplicación:

```bash
# 1. Obtener y actualizar dependencias
flutter pub get

# 2. Ejecutar la aplicación en tu dispositivo o emulador
flutter run
```

---

## 5. Solución de Problemas Comunes

* **Error: `AssetNotFoundException`**
  * *Solución:* Revisa minuciosamente los nombres de los archivos. Deben estar en minúsculas y usar guiones bajos exactos (por ejemplo, `keep_going.mp3` y no `keepGoing.mp3` ni `keep_going.MP3`).
* **No se reproduce el sonido:**
  * *Solución:* Asegúrate de que el volumen de multimedia de tu dispositivo de pruebas o emulador esté activado.
  * *Solución:* Verifica que los archivos `.mp3` estén codificados correctamente y se puedan reproducir en otros reproductores de audio estándar.
