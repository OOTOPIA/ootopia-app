import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';

List<Map<String, dynamic>> interestingTagsMap = [
  {
    'name': 'hello',
    'id': '1',
    'active': true,
    'createdAt': '',
    'language': '',
    'tagOrder': 1,
    'type': '',
    'updatedAt': '',
  },
];

List<InterestsTagsEntity> interestingTagsFixture = [
  InterestsTagsEntity(
    name: 'hello',
    id: '1',
    active: true,
    createdAt: '',
    language: '',
    tagOrder: 1,
    type: '',
    updatedAt: '',
  ),
  InterestsTagsEntity(
    name: 'hello 2',
    id: '2',
    active: true,
    createdAt: '',
    language: '',
    tagOrder: 1,
    type: '',
    updatedAt: '',
  ),
];
