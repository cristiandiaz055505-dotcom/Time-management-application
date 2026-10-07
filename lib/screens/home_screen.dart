import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:control_del_tiempo/screens/add_time_entry_screen.dart';
import 'package:control_del_tiempo/provider/time_entry_provider.dart';
import 'package:control_del_tiempo/screens/task_management_screen.dart';
import 'package:control_del_tiempo/screens/project_management_screen.dart';
import 'package:control_del_tiempo/provider/project_provider.dart';
import 'package:control_del_tiempo/provider/task_provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectProvider>().projects;
    final tasks = context.watch<TaskProvider>().tasks;
    final totalHours = context.watch<TimeEntryProvider>().totalHours;
    final totals = context.watch<TimeEntryProvider>().hoursByProject;
    debugPrint(totals.toString());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Recorded time: ${totalHours.toStringAsFixed(2)} h'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Color(0xFFFFD600),
            tabs: [
              Tab(text: 'All Entries'),
              Tab(text: 'By Project'),
            ],
          ),
        ),
        
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF00A576)),
                child: Center(
                  child: Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: const Text('Proyectos'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProjectManagementScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.checklist),
                title: const Text('Tasks'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TaskManagementScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      
        body: TabBarView(
          children: [
            Consumer<TimeEntryProvider>(
              builder: (context, provider, child) {
                if (provider.entries.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          size: 72,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No time entries yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Press + to register your time'),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: provider.entries.length,
                  itemBuilder: (context, index) {
                    final entry = provider.entries[index];

                    final dateFormatter = DateFormat('dd/MM/yyyy');
                    final formattedDate = dateFormatter.format(entry.date);

                    String projectName = entry.projectId;
                    String taskName = entry.taskId;

                    for (final task in tasks) {
                      if (task.id == entry.taskId) {
                        taskName = task.name;
                        break;
                      }
                    }

                    for (final project in projects) {
                      if (project.id == entry.projectId) {
                        projectName = project.name;
                        break;
                      }
                    }
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFB9E5D5)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          '$projectName - $taskName',
                          style: const TextStyle(
                            color: Color(0xFF00A576),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Time: ${entry.totalTime.toStringAsFixed(2)} h\n'
                          'Date: $formattedDate\n'
                          'Notes: ${entry.notes}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            provider.deleteTimeEntry(entry.id);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Time entry deleted.'),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Consumer<TimeEntryProvider>(
              builder: (context, provider, child) {
                final totals = provider.hoursByProject;
                final projectIds = totals.keys.toList();

                if (projectIds.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          size: 72,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No time entries yet!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Tap the + button to add your first entry.'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: projectIds.length,
                  itemBuilder: (context, index) {
                    final projectId = projectIds[index];
                    final hours = totals[projectId] ?? 0.0;

                    String projectName = projectId;

                    for (final project in projects) {
                      if (project.id == projectId) {
                        projectName = project.name;
                        break;
                      }
                    }

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFB9E5D5)),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.folder_outlined,
                          color: Color(0xFF00A576),
                        ),
                        title: Text(projectName),
                        subtitle: Text('Total: ${hours.toStringAsFixed(2)} h'),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the screen to add a new time entry
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
            );
          },
          tooltip: 'Add Time Entry',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
