import 'package:flutter/material.dart';

import '../../../data/models/piece_model.dart';

class AddPieceScreen extends StatefulWidget {
  const AddPieceScreen({super.key});

  @override
  State<AddPieceScreen> createState() =>
      _AddPieceScreenState();
}

class _AddPieceScreenState
    extends State<AddPieceScreen> {

  final lengthController =
      TextEditingController();

  final widthController =
      TextEditingController();

  final quantityController =
      TextEditingController();

  final noteController =
      TextEditingController();

  String materialType = 'MDF';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('قطعه جدید'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: SingleChildScrollView(
          child: Column(
            children: [

              DropdownButtonFormField<String>(
                value: materialType,

                decoration:
                    const InputDecoration(
                  labelText: 'نوع متریال',
                  border: OutlineInputBorder(),
                ),

                items: const [
                  DropdownMenuItem(
                    value: 'MDF',
                    child: Text('MDF'),
                  ),
                  DropdownMenuItem(
                    value: 'Fibr',
                    child: Text('Fibr'),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    materialType = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              TextField(
                controller: lengthController,
                keyboardType:
                    TextInputType.number,

                decoration:
                    const InputDecoration(
                  labelText: 'طول',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: widthController,
                keyboardType:
                    TextInputType.number,

                decoration:
                    const InputDecoration(
                  labelText: 'عرض',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller:
                    quantityController,
                keyboardType:
                    TextInputType.number,

                decoration:
                    const InputDecoration(
                  labelText: 'تعداد',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: noteController,

                decoration:
                    const InputDecoration(
                  labelText: 'یادداشت',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () {

                    final piece =
                        PieceModel(
                      id: DateTime.now()
                          .millisecondsSinceEpoch
                          .toString(),

                      materialType:
                          materialType,

                      length: double.tryParse(
                              lengthController
                                  .text) ??
                          0,

                      width: double.tryParse(
                              widthController
                                  .text) ??
                          0,

                      quantity: int.tryParse(
                              quantityController
                                  .text) ??
                          1,

                      completed: false,

                      note:
                          noteController.text,
                    );

                    Navigator.pop(
                      context,
                      piece,
                    );
                  },

                  child: const Text(
                    'ثبت',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
