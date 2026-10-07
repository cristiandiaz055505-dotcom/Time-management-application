import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:control_del_tiempo/models/time_entry.dart';
import 'package:control_del_tiempo/provider/time_entry_provider.dart';
import 'package:control_del_tiempo/provider/task_provider.dart';
import 'package:control_del_tiempo/provider/project_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key});
  @override
  State<AddTimeEntryScreen> createState() =>
    _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? projectId;
  String? taskId;
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasks;
    final projects = context.watch<ProjectProvider>().projects;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Time Entry'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == null) {
                        return 'Select a project';
                      }
                      return null;
                    },
          
                    initialValue: projectId,
                    onChanged: (newValue) {
                    setState(() {
                        projectId = newValue!;
                    });
                    },
                    decoration: InputDecoration(labelText: 'Project'),
                    items: projects.map((project) {
                      return DropdownMenuItem<String>(
                        value: project.id,
                        child: Text(project.name),
                      );
                    }).toList(),
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == null) {
                        return 'Select a task';
                      }
                      return null;
                    },
          
                    initialValue: taskId,
                    onChanged: (String? newValue) {
                    setState(() {
                        taskId = newValue!;
                    });
                    },
                    decoration: InputDecoration(labelText: 'Task'),
                    items: tasks.map((task) {
                      return DropdownMenuItem<String>(
                        value: task.id,
                        child: Text(task.name),
                      );
                    }).toList(),
                ),

                const SizedBox(height: 16),

                TextFormField(
                    decoration: InputDecoration(labelText: 'Total Time (hours)'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                        return 'Please enter total time';
                    }
                    final parsedTime = double.tryParse(value);
                    if (parsedTime == null || !parsedTime.isFinite) {
                        return 'Please enter a valid number';
                    }
                    if (parsedTime <= 0) {
                        return 'Please enter a positive number';
                    }
                    return null;
                    },
                    onSaved: (value) => totalTime = double.parse(value!),
                ),

                const SizedBox(height: 16),

                TextFormField(
                    decoration: InputDecoration(labelText: 'Notes'),
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                        return 'Please enter some notes';
                    }
                    return null;
                    },
                    onSaved: (value) => notes = value!,
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                    return;
                    }
          
                    final selectedProjectId = projectId;
                    final selectedTaskId = taskId;
          
                    if (selectedProjectId == null || selectedTaskId == null) {
                      return;
                    }
          
                    _formKey.currentState!.save();
          
                    Provider.of<TimeEntryProvider>(context, listen: false).addTimeEntry(
                    TimeEntry(
                      id: DateTime.now().toString(),
                      projectId: selectedProjectId,
                      taskId: selectedTaskId,
                      totalTime: totalTime,
                      date: date,
                      notes: notes,
                    ),
                  );
          
                  Navigator.pop(context);
                  },
                  child: Text('Save'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
