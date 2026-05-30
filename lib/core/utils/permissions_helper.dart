import 'dart:io';

Future<bool> requestMicrophonePermission() async {
  if (Platform.isAndroid) {
    return true;
  }
  return true;
}
