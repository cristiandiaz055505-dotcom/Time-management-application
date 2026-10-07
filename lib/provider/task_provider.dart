import 'package:flutter/foundation.dart';
import 'package:control_del_tiempo/models/task.dart';
import 'dart:convert';
import 'package:localstorage/localstorage.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  static const _storageKey = 'tasks';

  TaskProvider() {
    _loadTasks();
  }

  void _saveTasks() {
    final jsonText = jsonEncode(
      _tasks.map((task) => task.toJson()).toList(),
    );

    localStorage.setItem(_storageKey, jsonText);
  }

  void _loadTasks() {
    final jsonText = localStorage.getItem(_storageKey);

    if (jsonText == null) return;

    final decoded = jsonDecode(jsonText) as List<dynamic>;

    _tasks.addAll(
      decoded.map(
        (item) => Task.fromJson(item as Map<String, dynamic>),
      ),
    );
  }
  
  void addTask(Task task) {
    _tasks.add(task);
    _saveTasks();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasks();
    notifyListeners();
  }

}


