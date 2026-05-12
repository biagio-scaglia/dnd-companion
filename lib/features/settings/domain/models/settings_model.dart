class SettingsModel {
  final bool darkTheme;
  final String accentColor; // magic, nature, highlight
  final bool animationsEnabled;
  final bool hapticFeedback;
  final bool confirmDestructiveActions;
  final bool compactMode;
  final String locale; // 'it' or 'en'

  SettingsModel({
    this.darkTheme = true,
    this.accentColor = 'magic',
    this.animationsEnabled = true,
    this.hapticFeedback = true,
    this.confirmDestructiveActions = true,
    this.compactMode = false,
    this.locale = 'it',
  });

  SettingsModel copyWith({
    bool? darkTheme,
    String? accentColor,
    bool? animationsEnabled,
    bool? hapticFeedback,
    bool? confirmDestructiveActions,
    bool? compactMode,
    String? locale,
  }) {
    return SettingsModel(
      darkTheme: darkTheme ?? this.darkTheme,
      accentColor: accentColor ?? this.accentColor,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      confirmDestructiveActions: confirmDestructiveActions ?? this.confirmDestructiveActions,
      compactMode: compactMode ?? this.compactMode,
      locale: locale ?? this.locale,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'darkTheme': darkTheme,
      'accentColor': accentColor,
      'animationsEnabled': animationsEnabled,
      'hapticFeedback': hapticFeedback,
      'confirmDestructiveActions': confirmDestructiveActions,
      'compactMode': compactMode,
      'locale': locale,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      darkTheme: json['darkTheme'] ?? true,
      accentColor: json['accentColor'] ?? 'magic',
      animationsEnabled: json['animationsEnabled'] ?? true,
      hapticFeedback: json['hapticFeedback'] ?? true,
      confirmDestructiveActions: json['confirmDestructiveActions'] ?? true,
      compactMode: json['compactMode'] ?? false,
      locale: json['locale'] ?? 'it',
    );
  }
}
