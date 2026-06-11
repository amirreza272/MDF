import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/group_model.dart';
import '../../../data/models/piece_model.dart';
import '../../../data/models/sub_group_model.dart';

import 'add_piece_screen.dart';

class GroupDetailScreen extends StatefulWidget {
  final GroupModel group;

  const GroupDetailScreen({
    super.key,
    required this.group,
  });

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {

  // وقتی قطعه برگشت - اگه note داشت زیرگروه جدید/موجود ایجاد/پیدا کن
  Future<void> _addPiece({SubGroupModel? targetSubGroup}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddPieceScreen(
          existingSubGroupNames: widget.group.subGroups.map((s) => s.name).toList(),
        ),
      ),
    );

    if (result == null) return;

    final piece = result as PieceModel;

    setState(() {
      if (targetSubGroup != null) {
        // اضافه کردن به زیرگروه مشخص
        targetSubGroup.pieces.add(piece);
      } else if (piece.note.trim().isNotEmpty) {
        // note داره - بررسی کن زیرگروه با این نام وجود داره یا نه
        final existingSubGroup = widget.group.subGroups
            .where((s) => s.name.trim().toLowerCase() == piece.note.trim().toLowerCase())
            .firstOrNull;

        if (existingSubGroup != null) {
          existingSubGroup.pieces.add(piece);
        } else {
          // زیرگروه جدید بساز
          widget.group.subGroups.add(
            SubGroupModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: piece.note.trim(),
              pieces: [piece],
            ),
          );
        }
        // note رو پاک کن چون به عنوان نام زیرگروه استفاده شد
        piece.note = '';
      } else {
        // بدون note - مستقیم به گروه اصلی
        widget.group.pieces.add(piece);
      }
    });
  }

  void _togglePiece(PieceModel piece) {
    setState(() {
      piece.completed = !piece.completed;
    });
  }

  // محاسبه پیشرفت یک لیست قطعات
  _Progress _calcProgress(List<PieceModel> pieces) {
    if (pieces.isEmpty) return _Progress(0, 0, 0.0);
    final completed = pieces.where((p) => p.completed).length;
    return _Progress(completed, pieces.length, completed / pieces.length);
  }

  // dialog برای اضافه کردن قطعه به زیرگروه خاص
  void _showAddToSubGroupDialog(SubGroupModel subGroup) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'اضافه کردن به "${subGroup.name}"',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _addPiece(targetSubGroup: subGroup);
                },
                icon: const Icon(Icons.add),
                label: const Text('قطعه جدید'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupProgress = _calcProgress([
      ...widget.group.pieces,
      ...widget.group.subGroups.expand((s) => s.pieces),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Center(
              child: Text(
                '${(groupProgress.ratio * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: widget.group.pieces.isEmpty && widget.group.subGroups.isEmpty
          ? _buildEmpty()
          : ListView(
              padding: const EdgeInsets.only(bottom: 80),
              children: [
                // نوار پیشرفت کلی
                _buildGroupProgressBar(groupProgress),

                // قطعات مستقیم گروه (بدون زیرگروه)
                if (widget.group.pieces.isNotEmpty) ...[
                  _buildSectionHeader(
                    title: 'قطعات عمومی',
                    pieces: widget.group.pieces,
                    color: AppColors.primary,
                    onAddTap: null,
                  ),
                  ...widget.group.pieces.map((piece) => _buildPieceTile(piece)),
                ],

                // زیرگروه‌ها
                ...widget.group.subGroups.map((subGroup) {
                  final progress = _calcProgress(subGroup.pieces);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        title: subGroup.name,
                        pieces: subGroup.pieces,
                        color: _subGroupColor(widget.group.subGroups.indexOf(subGroup)),
                        onAddTap: () => _showAddToSubGroupDialog(subGroup),
                      ),
                      if (subGroup.pieces.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text('هنوز قطعه‌ای اضافه نشده',
                              style: TextStyle(color: AppColors.textGrey)),
                        )
                      else
                        ...subGroup.pieces.map((piece) => _buildPieceTile(piece)),
                      // نوار پیشرفت زیرگروه
                      if (subGroup.pieces.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: LinearProgressIndicator(
                            value: progress.ratio,
                            backgroundColor: AppColors.divider,
                            color: _subGroupColor(widget.group.subGroups.indexOf(subGroup)),
                            minHeight: 4,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                  );
                }),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addPiece(),
        icon: const Icon(Icons.add),
        label: const Text('قطعه جدید'),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 64, color: AppColors.primary.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text(
            'هنوز قطعه‌ای ثبت نشده',
            style: TextStyle(color: AppColors.textGrey, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'با دکمه + قطعه اضافه کنید',
            style: TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupProgressBar(_Progress p) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'پیشرفت کلی گروه',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
              Text(
                '${p.completed} از ${p.total} قطعه',
                style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: p.ratio,
              minHeight: 8,
              backgroundColor: AppColors.divider,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required List<PieceModel> pieces,
    required Color color,
    VoidCallback? onAddTap,
  }) {
    final p = _calcProgress(pieces);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Container(width: 4, height: 24, decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          )),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: color,
              ),
            ),
          ),
          Text(
            '${p.completed}/${p.total}',
            style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
          ),
          if (onAddTap != null) ...[
            const SizedBox(width: 8),
            InkWell(
              onTap: onAddTap,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(Icons.add_circle_outline, color: color, size: 22),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPieceTile(PieceModel piece) {
    return CheckboxListTile(
      value: piece.completed,
      onChanged: (_) => _togglePiece(piece),
      title: Text(
        '${piece.length} × ${piece.width} سانتی‌متر',
        style: TextStyle(
          decoration: piece.completed ? TextDecoration.lineThrough : null,
          color: piece.completed ? AppColors.textGrey : AppColors.textDark,
        ),
      ),
      subtitle: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: piece.materialType == 'MDF'
                  ? AppColors.primary.withOpacity(0.12)
                  : AppColors.secondary.withOpacity(0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              piece.materialType,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: piece.materialType == 'MDF' ? AppColors.primary : AppColors.secondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('تعداد: ${piece.quantity}',
              style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
          if (piece.note.isNotEmpty) ...[
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                piece.note,
                style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }

  Color _subGroupColor(int index) {
    final colors = [
      const Color(0xFFE63946), // قرمز
      const Color(0xFF2563EB), // آبی
      const Color(0xFF7C3AED), // بنفش
      const Color(0xFF059669), // سبز
      const Color(0xFFD97706), // نارنجی
      const Color(0xFFDB2777), // صورتی
    ];
    return colors[index % colors.length];
  }
}

class _Progress {
  final int completed;
  final int total;
  final double ratio;
  _Progress(this.completed, this.total, this.ratio);
}
