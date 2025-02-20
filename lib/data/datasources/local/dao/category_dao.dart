import 'package:floor/floor.dart';
import '/domain/entities/category.dart';

import '../../../../app/utils/constants/strings.dart';

@dao
abstract class CategoryDao {
  @Query('SELECT * FROM $articlesTableName')
  Future<List<Category>> getAllArticles();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertArticle(Category article);

  @delete
  Future<void> deleteArticle(Category article);
}
