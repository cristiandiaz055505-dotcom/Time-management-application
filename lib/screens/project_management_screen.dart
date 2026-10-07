import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:control_del_tiempo/models/proyect.dart';
import 'package:control_del_tiempo/provider/project_provider.dart';
import 'package:control_del_tiempo/widgets/add_proyect_dialog.dart';
import 'package:control_del_tiempo/provider/time_entry_provider.dart';

class ProjectManagementScreen extends StatelessWidget {
  const ProjectManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectProvider>().projects;

    return Scaffold(
      appBar: AppBar(title: const Text('Proyects')),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return ListTile(
            title: Text(project.name),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete Project',
              onPressed: () {
                final entries = context.read<TimeEntryProvider>().entries;

                final isUsed = entries.any(
                  (entry) => entry.projectId == project.id,
                );

                if (isUsed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Not you can delete a project with time entries.',
                      ),
                    ),
                  );
                  return;
                }

                context.read<ProjectProvider>().deleteProject(project.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = await showDialog<String>(
            context: context,
            builder: (_) => const AddProjectDialog(),
          );

          if (name == null || !context.mounted) return;

          context.read<ProjectProvider>().addProject(
            Project(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              name: name,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
