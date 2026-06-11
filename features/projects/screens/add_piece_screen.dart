import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/piece_model.dart';

class AddPieceScreen extends StatefulWidget {
  // نام زیرگروه‌های موجود برای پیشنهاد
  final List<String> existingSubGroupNames;

  const AddPieceScreen({
    super.key,
    this.existingSubGroupNames = const [],
  });

  @override
  State<AddPieceScreen> createState() => _AddPieceScreenState();
}

class _AddPieceScreenState extends State<AddPieceScreen> {
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final quantityController = TextEditingController();
  final noteController = TextEditingController();

  String materialType = 'MDF';
  String? selectedSubGroupName; // نام زیرگروه انتخاب شده

  @override
  void dispose() {
    lengthController.dispose();
    widthController.dispose();
    quantityController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final length = double.tryParse(lengthController.text) ?? 0;
    final width = double.tryParse(widthController.text) ?? 0;
    final quantity = int.tryParse(quantityController.text) ?? 1;

    if (length <= 0 || width <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً طول و عرض را وارد کنید')),
      );
      return;
    }

    // اگه زیرگروه انتخاب شده، note رو همون نام بذار
    final note = selectedSubGroupName ?? noteController.text.trim();

    final piece = PieceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      materialType: materialType,
      length: length,
      width: width,
      quantity: quantity,
      completed: false,
      note: note,
    );

    Navigator.pop(context, piece);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قطعه جدید'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // نوع متریال
            const Text('نوع متریال', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: ['MDF', 'Fibr'].map((type) {
                final selected = materialType == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => materialType = type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? AppColors.primary : AppColors.divider,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        type,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selected ? Colors.white : AppColors.textGrey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // ابعاد
            const Text('ابعاد (سانتی‌متر)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: lengthController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'طول',
                      prefixIcon: Icon(Icons.straighten),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text('×', style: TextStyle(fontSize: 24, color: AppColors.textGrey)),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: widthController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'عرض',
                      prefixIcon: Icon(Icons.straighten),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // تعداد
            const Text('تعداد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'تعداد',
                prefixIcon: Icon(Icons.numbers),
              ),
            ),

            const SizedBox(height: 20),

            // زیرگروه (note)
            Row(
              children: [
                const Text('زیرگروه', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(width: 6),
                Tooltip(
                  message: 'با وارد کردن نام، زیرگروه جدید ساخته می‌شود',
                  child: Icon(Icons.info_outline, size: 16, color: AppColors.textGrey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'اگه این قطعه به یه زیرگروه تعلق داره، نامش رو بنویس (مثلاً: کشو ۱، طبقه)',
              style: TextStyle(fontSize: 12, color: AppColors.textGrey),
            ),
            const SizedBox(height: 8),

            // پیشنهاد زیرگروه‌های موجود
            if (widget.existingSubGroupNames.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: widget.existingSubGroupNames.map((name) {
                  final isSelected = selectedSubGroupName == name;
                  return FilterChip(
                    label: Text(name),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        selectedSubGroupName = val ? name : null;
                        if (val) noteController.text = name;
                        else noteController.clear();
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.15),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textDark,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
            ],

            TextField(
              controller: noteController,
              onChanged: (val) {
                // اگه کاربر دستی تایپ کرد، chip رو deselect کن
                if (selectedSubGroupName != null && val != selectedSubGroupName) {
                  setState(() => selectedSubGroupName = null);
                }
              },
              decoration: InputDecoration(
                labelText: 'نام زیرگروه یا یادداشت',
                prefixIcon: const Icon(Icons.label_outline),
                hintText: widget.existingSubGroupNames.isEmpty
                    ? 'مثلاً: کشو ۱ یا طبقه'
                    : 'یا زیرگروه جدید',
              ),
            ),

            const SizedBox(height: 32),

            // دکمه ثبت
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text('ثبت قطعه', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
