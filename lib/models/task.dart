import 'package:intl/intl.dart';

class Task {
  int? id;
  String title;
  DateTime? dueDate;
  String priority;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    this.dueDate,
    this.priority = 'Medium',
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      priority: map['priority'],
      isCompleted: map['isCompleted'] == 1,
    );
  }

  String get formattedDueDate {
    return dueDate != null ? DateFormat('MMM dd, yyyy').format(dueDate!) : '';
  }
}