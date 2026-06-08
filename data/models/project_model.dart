import 'group_model.dart';

class ProjectModel {
  final String id;

  final String name;

  final DateTime createdAt;

  final List<GroupModel> groups;

  ProjectModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.groups,
  });
}