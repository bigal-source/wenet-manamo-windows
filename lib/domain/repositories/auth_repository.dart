import '../entities/user.dart';

abstract class AuthenticationRepository {
  Future<UserEntity> signUp(String username);
}
