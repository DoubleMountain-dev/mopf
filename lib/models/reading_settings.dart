// lib/models/reading_settings.dart

enum FontFamily { serif, sansSerif, monospace }

enum BackgroundTheme { sepia, dark, light, night }

class ReadingSettings {
  final FontFamily fontFamily;
  final double fontSize;
  final double lineHeight;
  final BackgroundTheme backgroundTheme;
  final bool nightMode;
  final bool autoScroll;

  const ReadingSettings({
    this.fontFamily = FontFamily.serif,
    this.fontSize = 16.0,
    this.lineHeight = 1.8,
    this.backgroundTheme = BackgroundTheme.sepia,
    this.nightMode = false,
    this.autoScroll = false,
  });

  ReadingSettings copyWith({
    FontFamily? fontFamily,
    double? fontSize,
    double? lineHeight,
    BackgroundTheme? backgroundTheme,
    bool? nightMode,
    bool? autoScroll,
  }) {
    return ReadingSettings(
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      backgroundTheme: backgroundTheme ?? this.backgroundTheme,
      nightMode: nightMode ?? this.nightMode,
      autoScroll: autoScroll ?? this.autoScroll,
    );
  }
}
