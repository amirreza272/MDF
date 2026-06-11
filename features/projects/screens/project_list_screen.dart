import 'package:flutter/material.dart';

import '../../../data/project_store.dart';
import '../../../data/models/project_model.dart';

import 'add_project_screen.dart';
import 'project_detail_screen.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {

  Future<void> _addProject() async {

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddProjectScreen(),
      ),
    );

    if (result == null || result.toString().trim().isEmpty) {
      return;
    }

    final project = ProjectModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: result,
      createdAt: DateTime.now(),
      groups: [],
    );

    ProjectStore.addProject(project);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('پروژه ها'),
      ),

      body: ListView.builder(
        itemCount: ProjectStore.projects.length,

        itemBuilder: (context, index) {

          final project = ProjectStore.projects[index];

          return Card(
            margin: const EdgeInsets.all(12),

            child: ListTile(
              title: Text(project.name),

              subtitle: Text(
                '${project.groups.length} گروه',
              ),

              trailing: const Icon(
                Icons.chevron_right,
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProjectDetailScreen(
                      project: project,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addProject,
        child: const Icon(Icons.add),
      ),
    );
  }
}
