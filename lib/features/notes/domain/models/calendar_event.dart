class CalendarEvent {
  final String id;
  final String title;
  final DateTime date;
  final bool hasSession;
  final bool hasReminder;
  final bool isImportant;

  const CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    this.hasSession = false,
    this.hasReminder = false,
    this.isImportant = false,
  });

  CalendarEvent copyWith({
    String? id,
    String? title,
    DateTime? date,
    bool? hasSession,
    bool? hasReminder,
    bool? isImportant,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      hasSession: hasSession ?? this.hasSession,
      hasReminder: hasReminder ?? this.hasReminder,
      isImportant: isImportant ?? this.isImportant,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'hasSession': hasSession,
      'hasReminder': hasReminder,
      'isImportant': isImportant,
    };
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      hasSession: json['hasSession'] as bool? ?? false,
      hasReminder: json['hasReminder'] as bool? ?? false,
      isImportant: json['isImportant'] as bool? ?? false,
    );
  }
}
