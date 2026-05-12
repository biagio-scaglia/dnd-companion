class BackupResult {
  final bool success;
  final String message;
  final Map<String, int>? mergeDetails;

  BackupResult({
    required this.success,
    required this.message,
    this.mergeDetails,
  });
}
