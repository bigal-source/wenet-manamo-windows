import '../../../domain/models/responses/home_view_model.dart';
import '../../../domain/repositories/remote/category_remote_repository.dart';
import '../../providers/network/apis/category_remote_api.dart';

class CategoryRemoteRepositoryIml extends CategoryRemoteRepository {

  @override
  Future<HomeViewModel> getCategoryInHomeUser(String userId) async {
    final response = await CategoryRemoteAPI.fetchBookInHome(userId).request();
    return HomeViewModel.fromJson(response);
    // TODO: implement getCategoryInHomeUser
    throw UnimplementedError();
  }

  @override
  Future<HomeViewModel> getAllCategoryUser(String userId) async {
    final response = await CategoryRemoteAPI.fetchBookInCate(userId).request();
    return HomeViewModel.fromJson(response);
    // TODO: implement getAllCategoryUser
    throw UnimplementedError();
  }

}
