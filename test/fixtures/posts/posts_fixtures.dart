import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/users_entity.dart';

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

List<Map<String, dynamic>> usersMap = [
  {
    'fullname': 'hello',
    'id': '1',
  },
];

List<InterestsTagsEntity> interestingTagsFixture = [
  InterestsTagsEntity(
    name: 'hello',
    id: '1',
    numberOfPosts: 150,
  ),
  InterestsTagsEntity(
    name: 'hello 2',
    id: '2',
    numberOfPosts: 150,
  ),
];
List<UsersEntity> usersFixture = [
  UsersEntity(
      fullname: 'hello', id: '1', email: 'anderson.barros@devmagic.com.br'),
  UsersEntity(
      fullname: 'hello 2', id: '2', email: 'anderson.barros@devmagic.com.br'),
];
