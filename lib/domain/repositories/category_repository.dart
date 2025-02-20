import '../../domain/entities/category.dart';

abstract class CategoryRepository {

  Future<List<Category>> getAllCategorys();

  Future<void> saveCategory(Category item);

  Future<void> removeCategory(Category item);
}
