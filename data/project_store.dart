import 'fake_data.dart';
import 'models/group_model.dart';
import 'models/piece_model.dart';
import 'models/project_model.dart';
import 'models/sub_group_model.dart';

class ProjectStore {
  static final List<ProjectModel> _projects = [
    ...fakeProjects,
  ];

  // getter برای دسترسی مستقیم
  static List<ProjectModel> get projects => _projects;

  static void addProject(ProjectModel project) {
    _projects.add(project);
  }

  static void addGroup({
    required String projectId,
    required GroupModel group,
  }) {
    final project = _projects.firstWhere((p) => p.id == projectId);
    project.groups.add(group);
  }

  static void addSubGroup({
    required String projectId,
    required String groupId,
    required SubGroupModel subGroup,
  }) {
    final group = _findGroup(projectId, groupId);
    group.subGroups.add(subGroup);
  }

  static void addPieceToGroup({
    required String projectId,
    required String groupId,
    required PieceModel piece,
  }) {
    final group = _findGroup(projectId, groupId);
    group.pieces.add(piece);
  }

  static void addPieceToSubGroup({
    required String projectId,
    required String groupId,
    required String subGroupId,
    required PieceModel piece,
  }) {
    final subGroup = _findSubGroup(projectId, groupId, subGroupId);
    subGroup.pieces.add(piece);
  }

  static GroupModel _findGroup(String projectId, String groupId) {
    final project = _projects.firstWhere((p) => p.id == projectId);
    return project.groups.firstWhere((g) => g.id == groupId);
  }

  static SubGroupModel _findSubGroup(
    String projectId,
    String groupId,
    String subGroupId,
  ) {
    final group = _findGroup(projectId, groupId);
    return group.subGroups.firstWhere((s) => s.id == subGroupId);
  }
}
