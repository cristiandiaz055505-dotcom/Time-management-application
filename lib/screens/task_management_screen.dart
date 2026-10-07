import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:control_del_tiempo/provider/task_provider.dart';
import 'package:control_del_tiempo/widgets/add_task_dialog.dart';
import 'package:control_del_tiempo/models/task.dart';
import 'package:control_del_tiempo/provider/time_entry_provider.dart';

class TaskManagementScreen extends StatelessWidget {
  const TaskManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasks;
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Tasks'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.name),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete Task',
              onPressed: () {
                final entries = context.read<TimeEntryProvider>().entries;

                final isUsed = entries.any((entry) => entry.taskId == task.id);

                if (isUsed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Not you can delete a task with time entries.',
                      ),
                    ),
                  );
                  return;
                }

                context.read<TaskProvider>().deleteTask(task.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        final nombre = await showDialog<String>(
        context: context,
        builder: (context) => const AddTaskDialog(),
        );

        if (nombre == null) return;

        if (!context.mounted) return;

        context.read<TaskProvider>().addTask(
          Task(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            name: nombre,
          ),
        );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
