import '../../app/core/usecases/pram_usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase extends ParamUseCase<UserEntity, String> {
  final AuthenticationRepository _repo;
  SignUpUseCase(this._repo);

  @override
  Future<UserEntity> execute(String username) {
    return _repo.signUp(username);
  }
}
