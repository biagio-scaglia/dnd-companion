class CampaignSession {
  final String id;
  final String title;
  final DateTime date;
  final String summary;

  const CampaignSession({
    required this.id,
    required this.title,
    required this.date,
    required this.summary,
  });

  CampaignSession copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? summary,
  }) {
    return CampaignSession(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      summary: summary ?? this.summary,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'summary': summary,
    };
  }

  factory CampaignSession.fromJson(Map<String, dynamic> json) {
    return CampaignSession(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      summary: json['summary'] as String,
    );
  }
}
