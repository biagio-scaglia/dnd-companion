class Attachment {
  final String id;
  final String linkedEntityId;
  final String linkedEntityType; // 'note', 'session', 'character'
  final String fileName;
  final String storedPath;
  final String? mimeType;
  final String? extension;
  final int? fileSize;
  final DateTime createdAt;
  final String sourceType; // 'image', 'file', 'link', etc.
  final String? note;

  const Attachment({
    required this.id,
    required this.linkedEntityId,
    required this.linkedEntityType,
    required this.fileName,
    required this.storedPath,
    this.mimeType,
    this.extension,
    this.fileSize,
    required this.createdAt,
    required this.sourceType,
    this.note,
  });

  Attachment copyWith({
    String? id,
    String? linkedEntityId,
    String? linkedEntityType,
    String? fileName,
    String? storedPath,
    String? mimeType,
    String? extension,
    int? fileSize,
    DateTime? createdAt,
    String? sourceType,
    String? note,
  }) {
    return Attachment(
      id: id ?? this.id,
      linkedEntityId: linkedEntityId ?? this.linkedEntityId,
      linkedEntityType: linkedEntityType ?? this.linkedEntityType,
      fileName: fileName ?? this.fileName,
      storedPath: storedPath ?? this.storedPath,
      mimeType: mimeType ?? this.mimeType,
      extension: extension ?? this.extension,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      sourceType: sourceType ?? this.sourceType,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'linkedEntityId': linkedEntityId,
      'linkedEntityType': linkedEntityType,
      'fileName': fileName,
      'storedPath': storedPath,
      'mimeType': mimeType,
      'extension': extension,
      'fileSize': fileSize,
      'createdAt': createdAt.toIso8601String(),
      'sourceType': sourceType,
      'note': note,
    };
  }

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] as String,
      linkedEntityId: json['linkedEntityId'] as String? ?? '',
      linkedEntityType: json['linkedEntityType'] as String? ?? 'note',
      fileName: json['fileName'] as String,
      storedPath: json['storedPath'] as String? ?? json['filePath'] as String? ?? '',
      mimeType: json['mimeType'] as String?,
      extension: json['extension'] as String?,
      fileSize: json['fileSize'] as int?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : json['dateAdded'] != null 
              ? DateTime.parse(json['dateAdded'] as String)
              : DateTime.now(),
      sourceType: json['sourceType'] as String? ?? json['type'] as String? ?? 'file',
      note: json['note'] as String?,
    );
  }
}
