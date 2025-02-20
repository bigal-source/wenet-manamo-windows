import '../../entities/user.dart';

abstract class UserRepository {

  Future<UserEntity> saveUser(UserEntity u);
  Future<UserEntity> getUser(String userId);
}
