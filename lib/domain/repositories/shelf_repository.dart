import '../entities/shelf.dart';

abstract class ShelfRepository {

  Future<List<Shelf>> getAllShelfs();

  Future<void> saveShelf(Shelf item);

  Future<void> removeShelf(Shelf item);
}
