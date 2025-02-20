import '../../domain/entities/shelf.dart';
import '../../domain/repositories/shelf_repository.dart';
import '../datasources/local/app_database.dart';

class ShelfRepositoryImpl implements ShelfRepository {
  final AppDatabase _appDatabase;

  ShelfRepositoryImpl(this._appDatabase);

  @override
  Future<List<Shelf>> getAllShelfs() async {
    return _appDatabase.shelfDao.getShelfs();
  }

  @override
  Future<void> removeShelf(Shelf item) {
    // TODO: implement removeShelf
    return _appDatabase.shelfDao.deleteShelf(item);
  }

  @override
  Future<void> saveShelf(Shelf item) {
    // TODO: implement saveShelf
    return _appDatabase.shelfDao.insertShelf(item);
  }

}
