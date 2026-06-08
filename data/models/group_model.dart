import 'piece_model.dart';
import 'sub_group_model.dart';

class GroupModel {
  final String id;

  final String name;

  final List<PieceModel> pieces;

  final List<SubGroupModel> subGroups;

  GroupModel({
    required this.id,
    required this.name,
    required this.pieces,
    required this.subGroups,
  });
}
