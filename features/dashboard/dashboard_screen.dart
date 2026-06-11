import 'package:flutter/material.dart';

import '../../../data/project_store.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final projects =
        ProjectStore.projects.length;

    int groups = 0;
    int pieces = 0;
    int completed = 0;

    for (final project in ProjectStore.projects) {

      groups += project.groups.length;

      for (final group in project.groups) {

        pieces += group.pieces.length;

        completed += group.pieces
            .where((e) => e.completed)
            .length;
      }
    }

    final progress = pieces == 0
        ? 0.0
        : completed / pieces;

    return Scaffold(
      appBar: AppBar(
        title: const Text('داشبورد'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.folder,
                ),
                title: const Text(
                  'پروژه ها',
                ),
                trailing: Text(
                  '$projects',
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.category,
                ),
                title: const Text(
                  'گروه ها',
                ),
                trailing: Text(
                  '$groups',
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.view_module,
                ),
                title: const Text(
                  'قطعات',
                ),
                trailing: Text(
                  '$pieces',
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.check_circle,
                ),
                title: const Text(
                  'انجام شده',
                ),
                trailing: Text(
                  '$completed',
                ),
              ),
            ),

            const SizedBox(height: 24),

            LinearProgressIndicator(
              value: progress,
            ),

            const SizedBox(height: 12),

            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
