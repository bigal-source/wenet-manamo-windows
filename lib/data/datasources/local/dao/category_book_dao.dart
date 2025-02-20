import 'package:floor/floor.dart';
import '/domain/entities/category_book.dart';

import '../../../../app/utils/constants/strings.dart';

@dao
abstract class CategoryBookDao {
  @Query('SELECT * FROM $categoryBookEntity')
  Future<List<CategoryBook>> getAllCategoryBooks();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCategoryBook(CategoryBook item);

  @delete
  Future<void> deleteCategoryBook(CategoryBook item);
}
