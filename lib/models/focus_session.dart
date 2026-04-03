class AuraFocusSession {
  final String id;
  final int durationMinutes;
  final bool isCompleted;
  final DateTime startedAt;
  final DateTime? completedAt;

  AuraFocusSession({
    required this.id,
    required this.durationMinutes,
    required this.startedAt,
    this.isCompleted = false,
    this.completedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'durationMinutes': durationMinutes,
        'isCompleted': isCompleted,
        'startedAt': startedAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
      };

  factory AuraFocusSession.fromJson(Map<String, dynamic> json) =>
      AuraFocusSession(
        id: json['id'],
        durationMinutes: json['durationMinutes'],
        isCompleted: json['isCompleted'],
        startedAt: DateTime.parse(json['startedAt']),
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'])
            : null,
      );
}
