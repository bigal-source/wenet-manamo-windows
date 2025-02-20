import '../../domain/entities/category_book.dart';

abstract class CategoryBookRepository {

  Future<List<CategoryBook>> getAllCategoryBooks();

  Future<void> saveCategoryBook(CategoryBook item);

  Future<void> removeCategoryBook(CategoryBook item);
}
