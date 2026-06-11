import 'package:flutter/material.dart';

import '../../../data/models/group_model.dart';
import '../../../data/models/piece_model.dart';

import 'add_piece_screen.dart';

class GroupDetailScreen extends StatefulWidget {
  final GroupModel group;

  const GroupDetailScreen({
    super.key,
    required this.group,
  });

  @override
  State<GroupDetailScreen> createState() =>
      _GroupDetailScreenState();
}

class _GroupDetailScreenState
    extends State<GroupDetailScreen> {

  Future<void> _addPiece() async {

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddPieceScreen(),
      ),
    );

    if (result == null) return;

    final piece = result as PieceModel;

    setState(() {

      widget.group.pieces.add(piece);

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
      ),

      body: ListView.builder(
        itemCount: widget.group.pieces.length,

        itemBuilder: (context, index) {

          final piece =
              widget.group.pieces[index];

          return CheckboxListTile(
            value: piece.completed,

            onChanged: (value) {

              setState(() {

                piece.completed =
                    value ?? false;

              });

            },

            title: Text(
              '${piece.length} × ${piece.width}',
            ),

            subtitle: Text(
              '${piece.materialType} | تعداد ${piece.quantity}',
            ),
          );
        },
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: _addPiece,
        child: const Icon(Icons.add),
      ),
    );
  }
}
