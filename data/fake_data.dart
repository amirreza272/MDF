import 'models/project_model.dart';
import 'models/group_model.dart';
import 'models/piece_model.dart';
import 'models/sub_group_model.dart';

final List<ProjectModel> fakeProjects = [
  ProjectModel(
    id: '1',
    name: 'پروژه احمدی',
    createdAt: DateTime.now(),
    groups: [
      GroupModel(
        id: '1',
        name: 'آشپزخانه',

        pieces: [
          PieceModel(
            id: '1',
            materialType: 'MDF',
            length: 70,
            width: 40,
            quantity: 2,
            completed: false,
            note: '',
          ),
        ],

        subGroups: [
          SubGroupModel(
            id: '1',
            name: 'کشو 1',

            pieces: [
              PieceModel(
                id: '2',
                materialType: 'MDF',
                length: 90,
                width: 50,
                quantity: 4,
                completed: true,
                note: '',
              ),
            ],
          ),
        ],
      )
    ],
  ),
];
