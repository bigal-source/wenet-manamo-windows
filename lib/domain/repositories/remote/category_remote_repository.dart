import '../../../domain/models/responses/home_view_model.dart';

abstract class CategoryRemoteRepository {

  Future<HomeViewModel> getCategoryInHomeUser(String userId);
  Future<HomeViewModel> getAllCategoryUser(String userId);
  //Future<CategoryDetailViewModel> getDetailCategoryUser(String userId, String cateId);
}
