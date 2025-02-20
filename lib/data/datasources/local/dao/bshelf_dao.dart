import 'package:floor/floor.dart';
import '/domain/entities/shelf.dart';

import '../../../../app/utils/constants/strings.dart';

@dao
abstract class ShelfDao {
  @Query('SELECT * FROM $shelfEntity')
  Future<List<Shelf>> getShelfs();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertShelf(Shelf shelf);

  @delete
  Future<void> deleteShelf(Shelf shelf);
}
