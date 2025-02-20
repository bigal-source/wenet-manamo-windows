import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthenticationRepositoryIml extends AuthenticationRepository {
  @override
  Future<UserEntity> signUp(String username) async {
    //Fake sign up action
    await Future.delayed(const Duration(seconds: 1));
    return UserEntity();
  }
}
