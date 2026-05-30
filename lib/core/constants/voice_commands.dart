class VoiceCommands {
  VoiceCommands._();

  static const List<String> predefinedCommands = [
    'Sarah ponte a hacer la tarea',
    'Sarah ordene su cama',
    'Sarah tu comida está servida',
  ];

  static bool matchesAny(String recognizedText) {
    return predefinedCommands
        .any((cmd) => recognizedText.toLowerCase().contains(cmd.toLowerCase()));
  }
}
