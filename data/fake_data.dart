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
          PieceModel(
            id: '2',
            materialType: 'Fibr',
            length: 68,
            width: 38,
            quantity: 2,
            completed: false,
            note: '',
          ),
        ],
        subGroups: [
          SubGroupModel(
            id: 'sg1',
            name: 'کشو 1',
            pieces: [
              PieceModel(
                id: '3',
                materialType: 'MDF',
                length: 90,
                width: 50,
                quantity: 4,
                completed: true,
                note: '',
              ),
              PieceModel(
                id: '4',
                materialType: 'Fibr',
                length: 65,
                width: 53,
                quantity: 2,
                completed: false,
                note: '',
              ),
            ],
          ),
          SubGroupModel(
            id: 'sg2',
            name: 'کشو 2',
            pieces: [
              PieceModel(
                id: '5',
                materialType: 'MDF',
                length: 56,
                width: 56,
                quantity: 2,
                completed: false,
                note: '',
              ),
              PieceModel(
                id: '6',
                materialType: 'Fibr',
                length: 68,
                width: 68,
                quantity: 1,
                completed: false,
                note: '',
              ),
            ],
          ),
          SubGroupModel(
            id: 'sg3',
            name: 'درب ها',
            pieces: [
              PieceModel(
                id: '7',
                materialType: 'MDF',
                length: 68,
                width: 68,
                quantity: 2,
                completed: false,
                note: '',
              ),
              PieceModel(
                id: '8',
                materialType: 'MDF',
                length: 68,
                width: 68,
                quantity: 2,
                completed: false,
                note: '',
              ),
              PieceModel(
                id: '9',
                materialType: 'Fibr',
                length: 68,
                width: 35,
                quantity: 38,
                completed: false,
                note: '',
              ),
            ],
          ),
        ],
      ),
      GroupModel(
        id: '2',
        name: 'اتاق خواب',
        pieces: [],
        subGroups: [
          SubGroupModel(
            id: 'sg4',
            name: 'کمد',
            pieces: [
              PieceModel(
                id: '10',
                materialType: 'MDF',
                length: 200,
                width: 60,
                quantity: 2,
                completed: false,
                note: '',
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  ProjectModel(
    id: '2',
    name: 'پروژه رضایی',
    createdAt: DateTime.now(),
    groups: [
      GroupModel(
        id: '3',
        name: 'پذیرایی',
        pieces: [
          PieceModel(
            id: '11',
            materialType: 'MDF',
            length: 120,
            width: 40,
            quantity: 4,
            completed: true,
            note: '',
          ),
        ],
        subGroups: [],
      ),
    ],
  ),
];
