import 'package:sarah_app/core/constants/voice_commands.dart';

class ListenCommand {
  String? execute(String recognizedText) {
    for (final command in VoiceCommands.predefinedCommands) {
      if (recognizedText.toLowerCase().contains(command.toLowerCase())) {
        return command;
      }
    }
    return null;
  }
}
