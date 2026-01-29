enum TaskPriority { high, medium, low, critical }

class Task {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final List<String> tags;
  final String assignee;
  final String date;
  final double? progress;
  final String? alertId;
  final String? feedbackId;
  final String status; // 'todo', 'doing', 'done'

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.tags,
    required this.assignee,
    required this.date,
    this.progress,
    this.alertId,
    this.feedbackId,
    required this.status,
  });

  Task copyWith({
    String? title,
    String? description,
    TaskPriority? priority,
    List<String>? tags,
    String? assignee,
    String? status,
    double? progress,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      assignee: assignee ?? this.assignee,
      date: date,
      progress: progress ?? this.progress,
      alertId: alertId,
      feedbackId: feedbackId,
      status: status ?? this.status,
    );
  }
}
