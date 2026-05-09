enum SessionStatus { bozza, completata, archiviata }

class CampaignSession {
  final String id;
  final String title;
  final int? number;
  final String? campaign;
  final DateTime realDate;
  final String? inGameDate;
  final String? location;
  final String shortRecap;
  final List<String> mainEvents;
  final List<String> metNpcs;
  final List<String> visitedLocations;
  final String? loot;
  final List<String> completedObjectives;
  final List<String> openObjectives;
  final String? notes;
  final SessionStatus status;
  final bool isImportant;
  final bool isPinned;
  final List<String> tags;
  final List<String> involvedCharacterIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CampaignSession({
    required this.id,
    required this.title,
    this.number,
    this.campaign,
    required this.realDate,
    this.inGameDate,
    this.location,
    required this.shortRecap,
    this.mainEvents = const [],
    this.metNpcs = const [],
    this.visitedLocations = const [],
    this.loot,
    this.completedObjectives = const [],
    this.openObjectives = const [],
    this.notes,
    required this.status,
    this.isImportant = false,
    this.isPinned = false,
    this.tags = const [],
    this.involvedCharacterIds = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  CampaignSession copyWith({
    String? id,
    String? title,
    int? number,
    String? campaign,
    DateTime? realDate,
    String? inGameDate,
    String? location,
    String? shortRecap,
    List<String>? mainEvents,
    List<String>? metNpcs,
    List<String>? visitedLocations,
    String? loot,
    List<String>? completedObjectives,
    List<String>? openObjectives,
    String? notes,
    SessionStatus? status,
    bool? isImportant,
    bool? isPinned,
    List<String>? tags,
    List<String>? involvedCharacterIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CampaignSession(
      id: id ?? this.id,
      title: title ?? this.title,
      number: number ?? this.number,
      campaign: campaign ?? this.campaign,
      realDate: realDate ?? this.realDate,
      inGameDate: inGameDate ?? this.inGameDate,
      location: location ?? this.location,
      shortRecap: shortRecap ?? this.shortRecap,
      mainEvents: mainEvents ?? this.mainEvents,
      metNpcs: metNpcs ?? this.metNpcs,
      visitedLocations: visitedLocations ?? this.visitedLocations,
      loot: loot ?? this.loot,
      completedObjectives: completedObjectives ?? this.completedObjectives,
      openObjectives: openObjectives ?? this.openObjectives,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      isImportant: isImportant ?? this.isImportant,
      isPinned: isPinned ?? this.isPinned,
      tags: tags ?? this.tags,
      involvedCharacterIds: involvedCharacterIds ?? this.involvedCharacterIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'number': number,
      'campaign': campaign,
      'realDate': realDate.toIso8601String(),
      'inGameDate': inGameDate,
      'location': location,
      'shortRecap': shortRecap,
      'mainEvents': mainEvents,
      'metNpcs': metNpcs,
      'visitedLocations': visitedLocations,
      'loot': loot,
      'completedObjectives': completedObjectives,
      'openObjectives': openObjectives,
      'notes': notes,
      'status': status.toString(),
      'isImportant': isImportant,
      'isPinned': isPinned,
      'tags': tags,
      'involvedCharacterIds': involvedCharacterIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CampaignSession.fromJson(Map<String, dynamic> json) {
    return CampaignSession(
      id: json['id'] as String,
      title: json['title'] as String,
      number: json['number'] as int?,
      campaign: json['campaign'] as String?,
      realDate: json['realDate'] != null 
          ? DateTime.parse(json['realDate'] as String)
          : (json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.now()),
      inGameDate: json['inGameDate'] as String?,
      location: json['location'] as String?,
      shortRecap: json['shortRecap'] as String? ?? json['summary'] as String? ?? '',
      mainEvents: json['mainEvents'] != null ? List<String>.from(json['mainEvents']) : [],
      metNpcs: json['metNpcs'] != null ? List<String>.from(json['metNpcs']) : [],
      visitedLocations: json['visitedLocations'] != null ? List<String>.from(json['visitedLocations']) : [],
      loot: json['loot'] as String?,
      completedObjectives: json['completedObjectives'] != null ? List<String>.from(json['completedObjectives']) : [],
      openObjectives: json['openObjectives'] != null ? List<String>.from(json['openObjectives']) : [],
      notes: json['notes'] as String?,
      status: json['status'] != null 
          ? SessionStatus.values.firstWhere((e) => e.toString() == json['status'], orElse: () => SessionStatus.completata)
          : SessionStatus.completata,
      isImportant: json['isImportant'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      involvedCharacterIds: json['involvedCharacterIds'] != null ? List<String>.from(json['involvedCharacterIds']) : [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : DateTime.now(),
    );
  }
}
