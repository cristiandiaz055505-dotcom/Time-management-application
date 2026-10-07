import 'package:control_del_tiempo/models/time_entry.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:localstorage/localstorage.dart';

class TimeEntryProvider with ChangeNotifier {
  List<TimeEntry> _entries = [];

  TimeEntryProvider() {
    _loadEntries();
  }

  void _loadEntries() {
    final jsonText = localStorage.getItem(_storageKey);

    if (jsonText == null) {
      return;
    }

    final decoded = jsonDecode(jsonText) as List<dynamic>;

    _entries = decoded
        .map((item) => TimeEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  List<TimeEntry> get entries => _entries;
  
  double get totalHours {
  double total = 0;

  for (final entry in _entries) {
    total += entry.totalTime;
  }

  return total;
  }
  
  Map<String, double> get hoursByProject {
    final totals = <String, double>{};

    for (final entry in _entries) {
      final projectId = entry.projectId;
      final previousHours = totals[projectId] ?? 0.0;

      totals[projectId] = previousHours + entry.totalTime;
    }

    return totals;
  }


  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveEntries();
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveEntries();
    notifyListeners();
  }



  static const _storageKey = 'time_entries';

  void _saveEntries() {
    final jsonText = jsonEncode(
      _entries.map((entry) => entry.toJson()).toList(),
    );

    localStorage.setItem(_storageKey, jsonText);
  }

}
