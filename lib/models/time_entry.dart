class TimeEntry {
  final String id;
  final String projectId;
  final String taskId;
  final double totalTime;
  final DateTime date;
  final String notes;

  TimeEntry({
    required this.id,
    required this.projectId,
    required this.taskId,
    required this.totalTime,
    required this.date,
    required this.notes,
  });
  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      taskId: json['task_id'] as String,
      totalTime: (json['total_time'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'task_id': taskId,
      'total_time': totalTime,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

}

