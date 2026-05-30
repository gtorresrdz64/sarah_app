class PlayGuidance {
  final List<String> audioSteps;
  final Duration pauseBetweenSteps;

  const PlayGuidance({
    this.audioSteps = const [],
    this.pauseBetweenSteps = const Duration(seconds: 10),
  });
}
