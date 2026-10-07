import 'package:flutter/foundation.dart';
import 'package:control_del_tiempo/models/proyect.dart';
import 'dart:convert';
import 'package:localstorage/localstorage.dart';

class ProjectProvider with ChangeNotifier {
  final List<Project> _projects = [];

  List<Project> get projects => _projects;

  static const _storageKey = 'projects';

  ProjectProvider() {
    _loadProjects();
  }

  void _saveProjects() {
    final jsonText = jsonEncode(
      _projects.map((project) => project.toJson()).toList(),
    );

    localStorage.setItem(_storageKey, jsonText);
  }

  void _loadProjects() {
    final jsonText = localStorage.getItem(_storageKey);

    if (jsonText == null) return;

    final decoded = jsonDecode(jsonText) as List<dynamic>;

    _projects.addAll(
      decoded.map(
        (item) => Project.fromJson(item as Map<String, dynamic>),
      ),
    );
  }
  
  void addProject(Project project) {
    _projects.add(project);
    _saveProjects();
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _saveProjects();
    notifyListeners();
  }

}