class AuraMood {
  final String id;
  final int mood; // 1-5: 1=sad, 2=frustrated, 3=neutral, 4=happy, 5=excited
  final String? note;
  final DateTime recordedAt;

  AuraMood({
    required this.id,
    required this.mood,
    this.note,
    required this.recordedAt,
  });

  String getMoodEmoji() {
    switch (mood) {
      case 1:
        return '😢';
      case 2:
        return '😟';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }

  String getMoodLabel() {
    switch (mood) {
      case 1:
        return 'Sad';
      case 2:
        return 'Low';
      case 3:
        return 'Neutral';
      case 4:
        return 'Happy';
      case 5:
        return 'Excited';
      default:
        return 'Neutral';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'mood': mood,
        'note': note,
        'recordedAt': recordedAt.toIso8601String(),
      };

  factory AuraMood.fromJson(Map<String, dynamic> json) => AuraMood(
        id: json['id'],
        mood: json['mood'],
        note: json['note'],
        recordedAt: DateTime.parse(json['recordedAt']),
      );
}
