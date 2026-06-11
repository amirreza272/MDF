class PieceModel {
  final String id;
  String materialType;
  double length;
  double width;
  int quantity;
  bool completed;
  String note;

  PieceModel({
    required this.id,
    required this.materialType,
    required this.length,
    required this.width,
    required this.quantity,
    required this.completed,
    required this.note,
  });
}
