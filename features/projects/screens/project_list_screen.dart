import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
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
      MaterialPageRoute(builder: (_) => const AddProjectScreen()),
    );

    if (result == null || result.toString().trim().isEmpty) return;

    ProjectStore.addProject(ProjectModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: result,
      createdAt: DateTime.now(),
      groups: [],
    ));

    setState(() {});
  }

  // محاسبه پیشرفت کلی پروژه
  (int completed, int total) _projectProgress(ProjectModel project) {
    int total = 0, completed = 0;
    for (final group in project.groups) {
      for (final piece in group.pieces) {
        total++;
        if (piece.completed) completed++;
      }
      for (final sub in group.subGroups) {
        for (final piece in sub.pieces) {
          total++;
          if (piece.completed) completed++;
        }
      }
    }
    return (completed, total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('پروژه‌ها'),
        centerTitle: true,
      ),
      body: ProjectStore.projects.isEmpty
          ? _buildEmpty()
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: ProjectStore.projects.length,
              itemBuilder: (context, index) {
                final project = ProjectStore.projects[index];
                final (completed, total) = _projectProgress(project);
                final progress = total == 0 ? 0.0 : completed / total;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProjectDetailScreen(project: project),
                        ),
                      );
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.folder, color: AppColors.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  project.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${project.groups.length} گروه · $completed از $total قطعه',
                                  style: const TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 5,
                                    backgroundColor: AppColors.divider,
                                    color: progress == 1.0 ? AppColors.success : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            children: [
                              Text(
                                '${(progress * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: progress == 1.0 ? AppColors.success : AppColors.primary,
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: AppColors.textGrey),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addProject,
        icon: const Icon(Icons.add),
        label: const Text('پروژه جدید'),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 72, color: AppColors.primary.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text('هنوز پروژه‌ای ثبت نشده',
              style: TextStyle(color: AppColors.textGrey, fontSize: 16)),
          const SizedBox(height: 8),
          const Text('با دکمه + پروژه جدید بسازید',
              style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
        ],
      ),
    );
  }
}
