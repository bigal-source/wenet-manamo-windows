import 'package:manamo/domain/entities/user.dart';

import '../../../domain/repositories/local/user_repository.dart';
import '../../datasources/local/db_help.dart';

class UserRepositoryIml extends UserRepository {

  @override
  Future<UserEntity> saveUser(UserEntity u) async {
    final response = await SQLHelper.saveUser(u);
    return response;
  }

  @override
  Future<UserEntity> getUser(String userId) async {
    final response = await SQLHelper.getUser(userId);
    return response;
  }

}
