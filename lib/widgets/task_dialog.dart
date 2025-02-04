import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class TaskDialog extends StatefulWidget {
  final Task? task;
  final Function(Task) onSubmit;

  const TaskDialog({
    Key? key,
    this.task,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late TextEditingController _controller;
  DateTime? _selectedDate;
  String _selectedPriority = 'Medium';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task?.title ?? '');
    _selectedDate = widget.task?.dueDate;
    _selectedPriority = widget.task?.priority ?? 'Medium';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Add New Task' : 'Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Enter your task here",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              TextButton.icon(
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(
                  _selectedDate == null
                      ? "Set Due Date"
                      : DateFormat('MMM dd').format(_selectedDate!),
                ),
                onPressed: _selectDate,
              ),
              const Spacer(),
              DropdownButton<String>(
                value: _selectedPriority,
                items: ['High', 'Medium', 'Low']
                    .map((priority) => DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedPriority = value!),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text("Submit"),
          onPressed: _submitData,
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  void _submitData() {
    if (_controller.text.isEmpty) return;

    final task = Task(
      id: widget.task?.id,
      title: _controller.text,
      dueDate: _selectedDate,
      priority: _selectedPriority,
      isCompleted: widget.task?.isCompleted ?? false,
    );

    widget.onSubmit(task);
    Navigator.pop(context);
  }
}