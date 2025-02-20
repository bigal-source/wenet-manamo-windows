import '../../domain/models/responses/home_view_model.dart';
import '../repositories/remote/category_remote_repository.dart';

class HomeUseCase{
  final CategoryRemoteRepository _repo;
  HomeUseCase(this._repo);

  @override
  Future<HomeViewModel> execute(String userId){
    return _repo.getAllCategoryUser(userId);
  }
}
