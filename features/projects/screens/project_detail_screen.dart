import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/group_model.dart';
import '../../../data/models/project_model.dart';

import 'add_group_screen.dart';
import 'group_detail_screen.dart';

class ProjectDetailScreen extends StatefulWidget {
  final ProjectModel project;

  const ProjectDetailScreen({
    super.key,
    required this.project,
  });

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {

  Future<void> _addGroup() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddGroupScreen()),
    );

    if (result == null || result.toString().trim().isEmpty) return;

    setState(() {
      widget.project.groups.add(
        GroupModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: result,
          pieces: [],
          subGroups: [],
        ),
      );
    });
  }

  // محاسبه پیشرفت یک گروه (شامل زیرگروه‌ها)
  (int completed, int total) _groupProgress(GroupModel group) {
    final allPieces = [
      ...group.pieces,
      ...group.subGroups.expand((s) => s.pieces),
    ];
    if (allPieces.isEmpty) return (0, 0);
    final completed = allPieces.where((p) => p.completed).length;
    return (completed, allPieces.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
      ),
      body: widget.project.groups.isEmpty
          ? _buildEmpty()
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: widget.project.groups.length,
              itemBuilder: (context, index) {
                final group = widget.project.groups[index];
                final (completed, total) = _groupProgress(group);
                final progress = total == 0 ? 0.0 : completed / total;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GroupDetailScreen(group: group),
                        ),
                      );
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.category, color: AppColors.primary, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      group.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '$completed از $total قطعه انجام شده'
                                      '${group.subGroups.isNotEmpty ? ' · ${group.subGroups.length} زیرگروه' : ''}',
                                      style: const TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${(progress * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: progress == 1.0 ? AppColors.success : AppColors.primary,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right, color: AppColors.textGrey),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              backgroundColor: AppColors.divider,
                              color: progress == 1.0 ? AppColors.success : AppColors.primary,
                            ),
                          ),
                          // نمایش زیرگروه‌ها
                          if (group.subGroups.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: group.subGroups.map((sg) {
                                final sgCompleted = sg.pieces.where((p) => p.completed).length;
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppColors.divider),
                                  ),
                                  child: Text(
                                    '${sg.name} ($sgCompleted/${sg.pieces.length})',
                                    style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addGroup,
        icon: const Icon(Icons.add),
        label: const Text('گروه جدید'),
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
          const Text('هنوز گروهی اضافه نشده',
              style: TextStyle(color: AppColors.textGrey, fontSize: 16)),
          const SizedBox(height: 8),
          const Text('با دکمه + گروه جدید اضافه کنید',
              style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
        ],
      ),
    );
  }
}
