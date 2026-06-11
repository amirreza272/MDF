import 'group_model.dart';

class ProjectModel {
  final String id;
  String name;
  final DateTime createdAt;
  List<GroupModel> groups;

  ProjectModel({
    required this.id,
    required this.name,
    required this.createdAt,
    List<GroupModel>? groups,
  }) : groups = groups ?? [];
}
