import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/task.dart';
import '../widgets/task_dialog.dart';
import '../widgets/task_item.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _dbHelper.getTasks();
    setState(() => _tasks = tasks);
  }

  Future<void> _handleTaskSubmission(Task task) async {
    if (task.id == null) {
      await _dbHelper.insertTask(task);
    } else {
      await _dbHelper.updateTask(task);
    }
    await _loadTasks();
  }

  Future<void> _deleteAllTasks() async {
    await _dbHelper.deleteAllTasks();
    await _loadTasks();
  }

  void _showTaskDialog([Task? task]) {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(
        task: task,
        onSubmit: _handleTaskSubmission,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text(
          'My ToDo-LIST',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep,color:Colors.red),
            onPressed: _deleteAllTasks,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/CHILLSUNSET.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: _tasks.isEmpty
            ? const Center(
          child: Text(
            "No tasks yet!\nAdd your first task ➕",
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        )
            : ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) => TaskItem(
            task: _tasks[index],
            onDelete: () async {
              await _dbHelper.deleteTask(_tasks[index].id!);
              await _loadTasks();
            },
            onToggle: (value) async {
              _tasks[index].isCompleted = value!;
              await _dbHelper.updateTask(_tasks[index]);
              await _loadTasks();
            },
            onEdit: () => _showTaskDialog(_tasks[index]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add,color:Colors.white),
        onPressed: () => _showTaskDialog(),
      ),
    );
  }
}