import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function() onDelete;
  final Function(bool?) onToggle;
  final Function() onEdit;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onDelete,
    required this.onToggle,
    required this.onEdit,
  }) : super(key: key);

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red[100]!;
      case 'Low':
        return Colors.green[100]!;
      default:
        return Colors.yellow[100]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id.toString()),
      background: Container(color: Colors.red),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Delete"),
            content: const Text("Delete this task permanently?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: _getPriorityColor(task.priority).withOpacity(0.9),
        child: ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: onToggle,
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 18,
              decoration: task.isCompleted
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          subtitle: task.dueDate != null
              ? Text(
            "Due: ${task.formattedDueDate}",
            style: const TextStyle(fontSize: 12),
          )
              : null,
          trailing: IconButton(
            icon: const Icon(Icons.edit,color:Colors.white),
            onPressed: onEdit,
          ),
        ),
      ),
    );
  }
}