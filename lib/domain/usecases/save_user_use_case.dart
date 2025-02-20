import '../entities/user.dart';
import '../repositories/local/user_repository.dart';

class SaveUserUseCase{
  final UserRepository _repo;
  SaveUserUseCase(this._repo);

  @override
  Future<UserEntity> execute(UserEntity u){
    return _repo.saveUser(u);
  }
}
