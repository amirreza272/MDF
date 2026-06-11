import 'piece_model.dart';

class SubGroupModel {
  final String id;
  String name;
  List<PieceModel> pieces;

  SubGroupModel({
    required this.id,
    required this.name,
    required this.pieces,
  });
}
