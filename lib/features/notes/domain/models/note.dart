class Note {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final List<String> tags;
  final bool isImportant;
  final String? sessionId;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.tags = const [],
    this.isImportant = false,
    this.sessionId,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? date,
    List<String>? tags,
    bool? isImportant,
    String? sessionId,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      tags: tags ?? this.tags,
      isImportant: isImportant ?? this.isImportant,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'tags': tags,
      'isImportant': isImportant,
      'sessionId': sessionId,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      date: DateTime.parse(json['date'] as String),
      tags: List<String>.from(json['tags'] ?? []),
      isImportant: json['isImportant'] as bool? ?? false,
      sessionId: json['sessionId'] as String?,
    );
  }
}
