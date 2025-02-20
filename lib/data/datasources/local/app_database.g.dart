// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ArticleDao? _articleDaoInstance;

  ShelfDao? _shelfDaoInstance;

  MemInfoDao? _memInfoDaoInstance;

  CategoryDao? _categoryDaoInstance;

  CategoryBookDao? _categoryBookDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `articles_table` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `source` TEXT, `author` TEXT, `title` TEXT, `description` TEXT, `url` TEXT, `urlToImage` TEXT, `publishedAt` TEXT, `content` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `shelf` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `appBookId` TEXT, `bookPath` TEXT, `title` TEXT, `thumbPath` TEXT, `thumbH` INTEGER, `thumbW` INTEGER, `pages` TEXT, `size` TEXT, `selected` TEXT, `status` TEXT, `download` TEXT, `bookInfo` TEXT, `evenType` TEXT, `cateSeq` TEXT, `procqueuStatus` TEXT, `procwaitBusy` TEXT, `planType` TEXT, `sortNo` INTEGER, `lastPage` INTEGER, `isDownload` INTEGER, `cateId` INTEGER, `pdfId` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `member_info` (`author` TEXT, `info` TEXT, `loginAutoInfo` TEXT, PRIMARY KEY (`author`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `option` (`appBookAppId` TEXT, `setting` TEXT, `lastPage` TEXT, PRIMARY KEY (`appBookAppId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `viewer` (`appBookId` TEXT, `module` TEXT, `page` TEXT, `dataObj` TEXT, PRIMARY KEY (`appBookId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `category` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `name` TEXT, `open` INTEGER NOT NULL, `sort` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `category_book` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `categoryId` INTEGER NOT NULL, `shelfId` INTEGER NOT NULL, `sort` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ArticleDao get articleDao {
    return _articleDaoInstance ??= _$ArticleDao(database, changeListener);
  }

  @override
  ShelfDao get shelfDao {
    return _shelfDaoInstance ??= _$ShelfDao(database, changeListener);
  }

  @override
  MemInfoDao get memInfoDao {
    return _memInfoDaoInstance ??= _$MemInfoDao(database, changeListener);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  CategoryBookDao get categoryBookDao {
    return _categoryBookDaoInstance ??=
        _$CategoryBookDao(database, changeListener);
  }
}

class _$ArticleDao extends ArticleDao {
  _$ArticleDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _articleInsertionAdapter = InsertionAdapter(
            database,
            'articles_table',
            (Article item) => <String, Object?>{
                  'id': item.id,
                  'source': _sourceTypeConverter.encode(item.source),
                  'author': item.author,
                  'title': item.title,
                  'description': item.description,
                  'url': item.url,
                  'urlToImage': item.urlToImage,
                  'publishedAt': item.publishedAt,
                  'content': item.content
                }),
        _articleDeletionAdapter = DeletionAdapter(
            database,
            'articles_table',
            ['id'],
            (Article item) => <String, Object?>{
                  'id': item.id,
                  'source': _sourceTypeConverter.encode(item.source),
                  'author': item.author,
                  'title': item.title,
                  'description': item.description,
                  'url': item.url,
                  'urlToImage': item.urlToImage,
                  'publishedAt': item.publishedAt,
                  'content': item.content
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Article> _articleInsertionAdapter;

  final DeletionAdapter<Article> _articleDeletionAdapter;

  @override
  Future<List<Article>> getAllArticles() async {
    return _queryAdapter.queryList('SELECT * FROM articles_table',
        mapper: (Map<String, Object?> row) => Article(
            id: row['id'] as int?,
            source: _sourceTypeConverter.decode(row['source'] as String),
            author: row['author'] as String?,
            title: row['title'] as String?,
            description: row['description'] as String?,
            url: row['url'] as String?,
            urlToImage: row['urlToImage'] as String?,
            publishedAt: row['publishedAt'] as String?,
            content: row['content'] as String?));
  }

  @override
  Future<void> insertArticle(Article article) async {
    await _articleInsertionAdapter.insert(article, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteArticle(Article article) async {
    await _articleDeletionAdapter.delete(article);
  }
}

class _$ShelfDao extends ShelfDao {
  _$ShelfDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _shelfInsertionAdapter = InsertionAdapter(
            database,
            'shelf',
            (Shelf item) => <String, Object?>{
                  'id': item.id,
                  'appBookId': item.appBookId,
                  'bookPath': item.bookPath,
                  'title': item.title,
                  'thumbPath': item.thumbPath,
                  'thumbH': item.thumbH,
                  'thumbW': item.thumbW,
                  'pages': item.pages,
                  'size': item.size,
                  'selected': item.selected,
                  'status': item.status,
                  'download': item.download,
                  'bookInfo': item.bookInfo,
                  'evenType': item.evenType,
                  'cateSeq': item.cateSeq,
                  'procqueuStatus': item.procqueuStatus,
                  'procwaitBusy': item.procwaitBusy,
                  'planType': item.planType,
                  'sortNo': item.sortNo,
                  'lastPage': item.lastPage,
                  'isDownload': item.isDownload,
                  'cateId': item.cateId,
                  'pdfId': item.pdfId
                }),
        _shelfDeletionAdapter = DeletionAdapter(
            database,
            'shelf',
            ['id'],
            (Shelf item) => <String, Object?>{
                  'id': item.id,
                  'appBookId': item.appBookId,
                  'bookPath': item.bookPath,
                  'title': item.title,
                  'thumbPath': item.thumbPath,
                  'thumbH': item.thumbH,
                  'thumbW': item.thumbW,
                  'pages': item.pages,
                  'size': item.size,
                  'selected': item.selected,
                  'status': item.status,
                  'download': item.download,
                  'bookInfo': item.bookInfo,
                  'evenType': item.evenType,
                  'cateSeq': item.cateSeq,
                  'procqueuStatus': item.procqueuStatus,
                  'procwaitBusy': item.procwaitBusy,
                  'planType': item.planType,
                  'sortNo': item.sortNo,
                  'lastPage': item.lastPage,
                  'isDownload': item.isDownload,
                  'cateId': item.cateId,
                  'pdfId': item.pdfId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Shelf> _shelfInsertionAdapter;

  final DeletionAdapter<Shelf> _shelfDeletionAdapter;

  @override
  Future<List<Shelf>> getShelfs() async {
    return _queryAdapter.queryList('SELECT * FROM shelf',
        mapper: (Map<String, Object?> row) => Shelf(
            id: row['id'] as int?,
            appBookId: row['appBookId'] as String?,
            bookPath: row['bookPath'] as String?,
            title: row['title'] as String?,
            thumbPath: row['thumbPath'] as String?,
            thumbH: row['thumbH'] as int?,
            thumbW: row['thumbW'] as int?,
            pages: row['pages'] as String?,
            size: row['size'] as String?,
            selected: row['selected'] as String?,
            status: row['status'] as String?,
            download: row['download'] as String?,
            bookInfo: row['bookInfo'] as String?,
            evenType: row['evenType'] as String?,
            cateSeq: row['cateSeq'] as String?,
            procqueuStatus: row['procqueuStatus'] as String?,
            procwaitBusy: row['procwaitBusy'] as String?,
            planType: row['planType'] as String?,
            sortNo: row['sortNo'] as int?,
            lastPage: row['lastPage'] as int?,
            isDownload: row['isDownload'] as int?,
            cateId: row['cateId'] as int?,
            pdfId: row['pdfId'] as int?));
  }

  @override
  Future<void> insertShelf(Shelf shelf) async {
    await _shelfInsertionAdapter.insert(shelf, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteShelf(Shelf shelf) async {
    await _shelfDeletionAdapter.delete(shelf);
  }
}

class _$MemInfoDao extends MemInfoDao {
  _$MemInfoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _memInfoInsertionAdapter = InsertionAdapter(
            database,
            'member_info',
            (MemInfo item) => <String, Object?>{
                  'author': item.author,
                  'info': item.info,
                  'loginAutoInfo': item.loginAutoInfo
                }),
        _memInfoDeletionAdapter = DeletionAdapter(
            database,
            'member_info',
            ['author'],
            (MemInfo item) => <String, Object?>{
                  'author': item.author,
                  'info': item.info,
                  'loginAutoInfo': item.loginAutoInfo
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MemInfo> _memInfoInsertionAdapter;

  final DeletionAdapter<MemInfo> _memInfoDeletionAdapter;

  @override
  Future<List<MemInfo>> getAllMemInfos() async {
    return _queryAdapter.queryList('SELECT * FROM member_info',
        mapper: (Map<String, Object?> row) => MemInfo(
            author: row['author'] as String?,
            info: row['info'] as String?,
            loginAutoInfo: row['loginAutoInfo'] as String?));
  }

  @override
  Future<void> insertMemInfo(MemInfo item) async {
    await _memInfoInsertionAdapter.insert(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteMemInfo(MemInfo item) async {
    await _memInfoDeletionAdapter.delete(item);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _categoryInsertionAdapter = InsertionAdapter(
            database,
            'category',
            (Category item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'open': item.open,
                  'sort': item.sort
                }),
        _categoryDeletionAdapter = DeletionAdapter(
            database,
            'category',
            ['id'],
            (Category item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'open': item.open,
                  'sort': item.sort
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Category> _categoryInsertionAdapter;

  final DeletionAdapter<Category> _categoryDeletionAdapter;

  @override
  Future<List<Category>> getAllArticles() async {
    return _queryAdapter.queryList('SELECT * FROM articles_table',
        mapper: (Map<String, Object?> row) => Category(
            id: row['id'] as int,
            name: row['name'] as String?,
            open: row['open'] as int,
            sort: row['sort'] as int));
  }

  @override
  Future<void> insertArticle(Category article) async {
    await _categoryInsertionAdapter.insert(article, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteArticle(Category article) async {
    await _categoryDeletionAdapter.delete(article);
  }
}

class _$CategoryBookDao extends CategoryBookDao {
  _$CategoryBookDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _categoryBookInsertionAdapter = InsertionAdapter(
            database,
            'category_book',
            (CategoryBook item) => <String, Object?>{
                  'id': item.id,
                  'categoryId': item.categoryId,
                  'shelfId': item.shelfId,
                  'sort': item.sort
                }),
        _categoryBookDeletionAdapter = DeletionAdapter(
            database,
            'category_book',
            ['id'],
            (CategoryBook item) => <String, Object?>{
                  'id': item.id,
                  'categoryId': item.categoryId,
                  'shelfId': item.shelfId,
                  'sort': item.sort
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CategoryBook> _categoryBookInsertionAdapter;

  final DeletionAdapter<CategoryBook> _categoryBookDeletionAdapter;

  @override
  Future<List<CategoryBook>> getAllCategoryBooks() async {
    return _queryAdapter.queryList('SELECT * FROM category_book',
        mapper: (Map<String, Object?> row) => CategoryBook(
            id: row['id'] as int,
            categoryId: row['categoryId'] as int,
            shelfId: row['shelfId'] as int,
            sort: row['sort'] as int));
  }

  @override
  Future<void> insertCategoryBook(CategoryBook item) async {
    await _categoryBookInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteCategoryBook(CategoryBook item) async {
    await _categoryBookDeletionAdapter.delete(item);
  }
}

// ignore_for_file: unused_element
final _sourceTypeConverter = SourceTypeConverter();
