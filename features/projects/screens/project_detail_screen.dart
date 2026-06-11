import 'package:flutter/material.dart';

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
  State<ProjectDetailScreen> createState() =>
      _ProjectDetailScreenState();
}

class _ProjectDetailScreenState
    extends State<ProjectDetailScreen> {

  Future<void> _addGroup() async {

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddGroupScreen(),
      ),
    );

    if (result == null ||
        result.toString().trim().isEmpty) {
      return;
    }

    widget.project.groups.add(
      GroupModel(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
        name: result,
        pieces: [],
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
      ),

      body: ListView.builder(
        itemCount: widget.project.groups.length,

        itemBuilder: (context, index) {

          final group =
              widget.project.groups[index];
              
          final totalPieces = group.pieces.length;

          final completedPieces = group.pieces
              .where((piece) => piece.completed)
              .length;

          final progress = totalPieces == 0
              ? 0.0
              : completedPieces / totalPieces;

          return Card(
            margin: const EdgeInsets.all(12),

            child: ListTile(
              title: Text(group.name),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    '$completedPieces / $totalPieces قطعه انجام شده',
                  ),

                  const SizedBox(height: 6),

                  LinearProgressIndicator(
                    value: progress,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                  ),
                ],
              ),

              trailing:
                  const Icon(Icons.chevron_right),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        GroupDetailScreen(
                      group: group,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: _addGroup,
        child: const Icon(Icons.add),
      ),
    );
  }
}
