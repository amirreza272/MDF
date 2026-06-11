import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/project_store.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int projectCount = ProjectStore.projects.length;
    int groupCount = 0;
    int pieceCount = 0;
    int completedCount = 0;

    for (final project in ProjectStore.projects) {
      groupCount += project.groups.length;
      for (final group in project.groups) {
        pieceCount += group.pieces.length;
        completedCount += group.pieces.where((p) => p.completed).length;

        for (final sub in group.subGroups) {
          pieceCount += sub.pieces.length;
          completedCount += sub.pieces.where((p) => p.completed).length;
        }
      }
    }

    final progress = pieceCount == 0 ? 0.0 : completedCount / pieceCount;

    return Scaffold(
      appBar: AppBar(title: const Text('داشبورد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // کارت‌های آماری
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _StatCard(
                  icon: Icons.folder,
                  label: 'پروژه‌ها',
                  value: '$projectCount',
                  color: AppColors.primary,
                ),
                _StatCard(
                  icon: Icons.category,
                  label: 'گروه‌ها',
                  value: '$groupCount',
                  color: const Color(0xFF7C3AED),
                ),
                _StatCard(
                  icon: Icons.view_module,
                  label: 'قطعات',
                  value: '$pieceCount',
                  color: AppColors.secondary,
                ),
                _StatCard(
                  icon: Icons.check_circle,
                  label: 'انجام شده',
                  value: '$completedCount',
                  color: AppColors.success,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // کارت پیشرفت
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'پیشرفت کلی',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          '$completedCount / $pieceCount',
                          style: const TextStyle(color: AppColors.textGrey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        backgroundColor: AppColors.divider,
                        color: progress == 1.0 ? AppColors.success : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        '${(progress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: progress == 1.0 ? AppColors.success : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold, color: color)),
                Text(label,
                    style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
