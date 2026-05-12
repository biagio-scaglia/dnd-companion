class BackupManifest {
  final int formatVersion;
  final String appVersion;
  final DateTime createdAt;
  final String deviceInfo;
  final Map<String, int> counts;

  BackupManifest({
    required this.formatVersion,
    required this.appVersion,
    required this.createdAt,
    required this.deviceInfo,
    required this.counts,
  });

  Map<String, dynamic> toJson() {
    return {
      'formatVersion': formatVersion,
      'appVersion': appVersion,
      'createdAt': createdAt.toIso8601String(),
      'deviceInfo': deviceInfo,
      'counts': counts,
    };
  }

  factory BackupManifest.fromJson(Map<String, dynamic> json) {
    return BackupManifest(
      formatVersion: json['formatVersion'] as int,
      appVersion: json['appVersion'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      deviceInfo: json['deviceInfo'] as String,
      counts: Map<String, int>.from(json['counts'] as Map),
    );
  }
}
