import 'piece_model.dart';
import 'sub_group_model.dart';

class GroupModel {
  final String id;
  String name;
  List<PieceModel> pieces;
  List<SubGroupModel> subGroups;

  GroupModel({
    required this.id,
    required this.name,
    required this.pieces,
    List<SubGroupModel>? subGroups,
  }) : subGroups = subGroups ?? [];
}
