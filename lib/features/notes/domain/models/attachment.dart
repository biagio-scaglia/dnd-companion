class Attachment {
  final String id;
  final String fileName;
  final String filePath;
  final String type; // e.g., 'image', 'pdf', 'text'
  final DateTime dateAdded;

  const Attachment({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.type,
    required this.dateAdded,
  });

  Attachment copyWith({
    String? id,
    String? fileName,
    String? filePath,
    String? type,
    DateTime? dateAdded,
  }) {
    return Attachment(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      type: type ?? this.type,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'filePath': filePath,
      'type': type,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      filePath: json['filePath'] as String,
      type: json['type'] as String,
      dateAdded: DateTime.parse(json['dateAdded'] as String),
    );
  }
}
