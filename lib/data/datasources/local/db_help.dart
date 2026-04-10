import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../app/utils/constants/strings.dart';
import '../../../app/utils/server.dart';
import '../../../domain/entities/user.dart';
import '../../models/bookModel.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SQLHelper {

  static Future<sql.Database> db() async {

    String dbPath = p.join("$dir\\web", dbname);
    if (kDebugMode) {
      print("dbPath = $dbPath");
    }
    if(io.Platform.isWindows){
      var databaseFactory = databaseFactoryFfi;

      var db = await databaseFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
            version: 4,
            onCreate: (sql.Database database, int version) async {
              await createTables(database);
            },
          onUpgrade: (sql.Database database, int oldVersion, int newVersion) async {
            if (oldVersion < newVersion) {
              await database.execute("drop table if exists last_synchronization");
              await createWBookSynchroTimeTable(database);
            }
          },
        ),
      );
      return db;
    }else{
      var db = sql.openDatabase(dbPath,version: 1,
        onCreate: (sql.Database database, int version) async {
          await createTables(database);
        },
      );
      return db;
    }
  }

  Future close() async {
    final db = await SQLHelper.db();
    return db.close();
  }

  static Future<void> createTables(sql.Database db) async {

    // bookshelf
    await db.execute('CREATE TABLE '
        'bshelf('
        '          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
        '          app_book_id TEXT, '
        '          book_path TEXT,'
        '          title TEXT, '
        '          thumb_path TEXT,'
        '          thumb_h INTEGER,'
        '          thumb_w INTEGER,'
        '          pages TEXT,'
        '          size TEXT, '
        '          selected TEXT, '
        '          status TEXT, '
        '          download TEXT,'
        '          book_info TEXT, '
        '          even_type TEXT, '
        '          cate_seq TEXT, '
        '          procqueu_status TEXT, '
        '          procwait_busy TEXT, '
        '          plan_type TEXT, '
        '          sort_no INTEGER, '
        '          last_page  int,'
        '          is_download INTEGER,'
        '          cate_id INTEGER,'
        '          pdf_id  INTEGER,'
        '          device_id TEXT)'
    );
    // member
    await db.execute('CREATE TABLE '
        'memberinfo('
        '          author TEXT, '
        '          info TEXT, '
        '          login_auto_info TEXT)');
    //option
    await db.execute('CREATE TABLE '
        'option('
        '          app_book_id TEXT,'
        '          setting TEXT,'
        '          last_page TEXT)');

    // viewer
    await db.execute('CREATE TABLE '
        'viewer('
        '             app_book_id TEXT, '
        '             update_date INTEGER, '
        '             module TEXT, '
        '             page INTEGER, '
        '             dataobj TEXT)');
    // category
    await db.execute('CREATE TABLE '
        'category('
        '             id INTEGER PRIMARY KEY AUTOINCREMENT, '
        '             name TEXT, '
        '             open INTEGER, '
        '             is_default INTEGER, '
        '             sort INTEGER)');
    // category book
    await db.execute('CREATE TABLE '
        'category_book('
        '             id INTEGER PRIMARY KEY AUTOINCREMENT, '
        '             category_id INTEGER, '
        '             shelf_id INTEGER, '
        '             sort INTEGER)');
    // category book
    await db.execute('CREATE TABLE '
        'user('
        '             id INTEGER PRIMARY KEY AUTOINCREMENT, '
        '             idx TEXT, '
        '             email TEXT, '
        '             session TEXT, '
        '             lastLogin TEXT, '
        '             isLogin INTEGER, '
        '             data TEXT)');

    //CRUD
    // Create new item (journal)
    await db.execute('CREATE TABLE '
        'wbook_synchro_time('
        '             id INTEGER PRIMARY KEY AUTOINCREMENT, '
        '             mem_id TEXT, '
        '             user_idx TEXT, '
        '             book_seq TEXT, '
        '             synchro_offline_at TEXT, '
        '             synchro_online_at TEXT)');
  }

  static Future<void> createWBookSynchroTimeTable(sql.Database db) async {
    await db.execute('CREATE TABLE '
        'wbook_synchro_time('
        '             id INTEGER PRIMARY KEY AUTOINCREMENT, '
        '             mem_id TEXT, '
        '             user_idx TEXT, '
        '             book_seq TEXT, '
        '             synchro_offline_at TEXT, '
        '             synchro_online_at TEXT)');
  }
  static Future<int> createItem(String title, String? descrption) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'description': descrption};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //todo: Category shelf
  static Future<CategoryShelf>  saveCategory(CategoryShelf cate) async {
    final db = await SQLHelper.db();
    final id = await db.insert('category', cate.toMap(), conflictAlgorithm: sql.ConflictAlgorithm.replace);
    var data = await db.query('category', where: "id = ?", whereArgs: [id], limit: 1);
    var resp =  List<CategoryShelf>.from(data.map((x) => CategoryShelf.fromMap(x)));
    if(resp.isNotEmpty){
      return resp[0] ;
    }else{
      return CategoryShelf();
    }
  }
  static Future<CategoryShelf> getCategory(int cateId) async {
    final db = await SQLHelper.db();
    var data = await db.query('category', where: "id = ?", whereArgs: [cateId], limit: 1);
    var resp =  List<CategoryShelf>.from(data.map((x) => CategoryShelf.fromMap(x)));
    if(resp.isNotEmpty){
      return resp[0] ;
    }else{
      return CategoryShelf();
    }
  }
  static Future<int> updateCategory(CategoryShelf cate) async {
    final db = await SQLHelper.db();
    var data = await db.update('category', cate.toMap(), where: "id = ?", whereArgs: [cate.id]);
    return data;

  }
  static Future<int> deleteCategory(CategoryDownLoad cate) async {
    final db = await SQLHelper.db();
    var data = await db.delete('category', where: "id = ?", whereArgs: [cate.id]);
    return data;

  }
  static Future<List<CategoryShelf>> getAllCategorys() async {
    final db   = await SQLHelper.db();
    final data = await db.query('category', orderBy: 'sort');
    var resp   =  List<CategoryShelf>.from(data.map((x) => CategoryShelf.fromMap(x)));
    return resp;
  }
  static Future<List<String>> getAllBookAppId() async {
    final db   = await SQLHelper.db();
    final data = await db.query('bshelf', where: "is_download = ?", whereArgs: [1] ,orderBy: 'id');
    var resp   =  List<String>.from(data.map((x) => Bshelf.fromJson(x).bookAppId));
    return resp;
  }
  static Future<List<CategoryDownLoad>> getAllCategorys2() async {
    String deviceId = '';
    if (Platform.isWindows) {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.windowsInfo;
      deviceId = deviceInfo.deviceId;
    }

    final db        = await SQLHelper.db();
    final data      = await db.query('category', orderBy: 'sort');
    var listCate    =  List<CategoryDownLoad>.from(data.map((x) => CategoryDownLoad.fromJson(x)));
    if(listCate.isNotEmpty){
      for (var element in listCate) {
        final List<Map<String, Object?>> books;
        if (Platform.isWindows) {
          books = await db.rawQuery('SELECT * FROM bshelf WHERE cate_id == ${element.id} AND is_download == 1 and device_id = "$deviceId" order by sort_no ASC ');
        }
        else {
          books = await db.rawQuery('SELECT * FROM bshelf WHERE cate_id == ${element.id} AND is_download == 1 order by sort_no ASC ');
        }
        if(books.isNotEmpty){
          element.books = List<Bshelf>.from(books.map((x) => Bshelf.fromJson(x)));
        }
      }
    }else{
      return List.empty();
    }
    return listCate;
  }

  //todo: Category book
  static Future<CategoryBook>  saveCategoryBook(CategoryBook cate) async {
    final db = await SQLHelper.db();
    final id = await db.insert('category_book', cate.toMap(), conflictAlgorithm: sql.ConflictAlgorithm.replace);
    var data = await db.query('category_book', where: "id = ?", whereArgs: [id], limit: 1);
    var resp =  List<CategoryBook>.from(data.map((x) => CategoryBook.fromMap(x)));
    if(resp.isNotEmpty){
      return resp[0] ;
    }else{
      return CategoryBook();
    }
  }
  static Future<int> updateCategoryBook(CategoryBook cate) async {
    final db = await SQLHelper.db();
    var data = await db.update('category', cate.toMap(), where: "id = ?", whereArgs: [cate.id]);
    return data;

  }
  static Future<int> deleteBookInCate(int shelfId) async {
    final db = await SQLHelper.db();
    var data = await db.delete('category_book', where: "shelf_id = ?", whereArgs: [shelfId]);
    return data;

  }
  static Future<List<CategoryBook>> getAllCategoryBooks() async {
    final db   = await SQLHelper.db();
    final data = await db.query('category_book', orderBy: 'sort');
    var resp   =  List<CategoryBook>.from(data.map((x) => CategoryBook.fromMap(x)));
    return resp;
  }
  static Future<List<Bshelf>> getBooksInCaterory(int cateId) async {
    final db   = await SQLHelper.db();
    var data           = await db.query('category_book', where: "category_id = ?", whereArgs: [cateId]);
    var listBookCate   =  List<CategoryBook>.from(data.map((x) => CategoryBook.fromMap(x)));
    List<int> listId   = [];
    if(listBookCate.isNotEmpty){
      for (var element in listBookCate) {
        listId.add(element.shelfId!);
      }
    }
    var ids     = listId.toString().replaceAll('[', '').replaceAll(']', '');
    final books = await db.rawQuery('SELECT * FROM bshelf WHERE id in ($ids)');
    var resp    =  List<Bshelf>.from(books.map((x) => Bshelf.fromJson(x)));
    return resp;
  }
  static Future<Bshelf> saveBookShelf(Bshelf shelf) async {
    final db = await SQLHelper.db();
    final id = await db.insert('bshelf', shelf.toJson(), conflictAlgorithm: sql.ConflictAlgorithm.replace);
    var data = await db.query('bshelf', where: "id = ?", whereArgs: [id], limit: 1);
    var resp =  List<Bshelf>.from(data.map((x) => Bshelf.fromJson(x)));
    if(resp.isNotEmpty){
      return resp[0] ;
    }else{
      return Bshelf();
    }
  }
  static Future<Bshelf> getBookInfo(String appBookId) async {
    final db = await SQLHelper.db();
    var data = await db.query('bshelf', where: "app_book_id = ?", whereArgs: [appBookId], limit: 1);
    var resp =  List<Bshelf>.from(data.map((x) => Bshelf.fromJson(x)));
    if(resp.isNotEmpty){
      return resp[0] ;
    }else{
      return Bshelf();
    }
  }
  static Future<bool> checkBookExit(String appBookId) async {
    final db = await SQLHelper.db();
    var data = await db.query('bshelf', where: "app_book_id = ?", whereArgs: [appBookId], limit: 1);
    var resp =  List<Bshelf>.from(data.map((x) => Bshelf.fromJson(x)));
    if(resp.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }
  static Future<int> updateBookShelf(Bshelf note) async {
    final db = await SQLHelper.db();
    var data = await db.update('bshelf', note.toJson(), where: "id = ?", whereArgs: [note.id]);
    return data;

  }
  static Future<int> updateLastPage(String appBookId, int page) async {
    Bshelf note;
    final db = await SQLHelper.db();
    var data = await db.query('bshelf', where: "app_book_id = ?", whereArgs: [appBookId], limit: 1);
    var book =  List<Bshelf>.from(data.map((x) => Bshelf.fromJson(x)))[0];
    book.lastPage   = page;
    var resp = await db.update('bshelf', book.toJson(), where: "id = ?", whereArgs: [book.id]);
    return resp;

  }
  static Future<int> deleteBook(Bshelf book) async {
    final db = await SQLHelper.db();
    var data = await db.delete('bshelf', where: "id = ?", whereArgs: [book.id]);
    return data;

  }
  static Future<List<Bshelf>> getAllBookShelf(int download) async {
    final db   = await SQLHelper.db();
    final data = await db.query('bshelf', where: "is_download = ?", whereArgs: [download] ,orderBy: 'id');
    var resp   =  List<Bshelf>.from(data.map((x) => Bshelf.fromJson(x)));
    return resp;
  }
  static Future<List<Bshelf>> getAllBookInCate(String cateId) async {
    final db   = await SQLHelper.db();
    final data = await db.query('bshelf', where: "cate_seq = ?", whereArgs: [cateId] ,orderBy: 'id');
    var resp   =  List<Bshelf>.from(data.map((x) => Bshelf.fromJson(x)));
    return resp;
  }
  static Future<List<Bshelf>> getAllBooks() async {
    final db   = await SQLHelper.db();
    final data = await db.query('bshelf', columns: ['id', 'app_book_id','title', 'thumb_path','thumb_w', 'thumb_h'],orderBy: 'id');
    var resp   =  List<Bshelf>.from(data.map((x) => Bshelf.fromJson(x)));
    return resp;
  }
  Future getAllBookInfo() async {
    final db = await SQLHelper.db();
    final result = await db.query('bshelf', columns: ['id', 'app_book_id', 'title', 'thumb_path', 'thumb_w', 'thumb_h', 'page', 'size', 'status'],orderBy: 'id DESC');
    return result.toList();
  }
  Future getAllBookCate(String cateId) async {
    final db = await SQLHelper.db();
    final result = await db.query('bshelf', columns: ['id', 'app_book_id', 'title', 'thumb_path', 'thumb_w', 'thumb_h', 'page', 'size', 'status'],
        where: 'cate_seq = ?',
        whereArgs: [cateId]
        ,orderBy: 'id DESC');
    return result.toList();
  }
  Future getBook(int id) async {
    final db = await SQLHelper.db();
    List result = await db.query('bshelf',where: 'id = ?',whereArgs: [id], limit: 1);
    if (result.isNotEmpty) {
      return Bshelf.fromJson(result.first);
    }
    return null;
  }
  Future getBookAppId(String bookAppId) async {
    final db = await SQLHelper.db();
    List result = await db.query('bshelf', where: 'app_boo_id = ?',whereArgs: [bookAppId]);
    if (result.isNotEmpty) {
      return Bshelf.fromJson(result.first);
    }
    return null;
  }
  static Future<int> updateBook(Bshelf book) async {
    final db = await SQLHelper.db();
    var data = await db.update('bshelf', book.toJson(), where: "id = ?", whereArgs: [book.id]);
    return data;

  }
  Future updateBookCate(Bshelf book) async {
    final db = await SQLHelper.db();
    return await db.update('bshelf', book.toJson(), where: "id = ?", whereArgs: [book.id]);

  }

  //TODO: Viewer
  static Future<Bviewer> saveViewer(Bviewer viewer) async {
    final db = await SQLHelper.db();
    final id = await db.insert('viewer', viewer.toMap(), conflictAlgorithm: sql.ConflictAlgorithm.replace);
    var data = await db.query('viewer', where: "app_book_id = ?", whereArgs: [viewer.bookAppId], limit: 1);
    var resp =  List<Bviewer>.from(data.map((x) => Bviewer.fromMap(x)));
    if(resp.isNotEmpty){
      return resp.first;
    }else{
      return Bviewer(bookAppId: '0');
    }
  }
  static Future<Bviewer> getSingleViewer(String appBookId, int page, String module) async {
    print("appBookId = $appBookId, page = $page, module = $module");
    final db = await SQLHelper.db();
    List result = await db.query('viewer', where: "app_book_id =? and module =? and page =?", whereArgs: [appBookId, module, page], limit: 1);
    print(result);
    if (result.isNotEmpty) {
      return Bviewer.fromMap(result.first);
    }else{
      return Bviewer(bookAppId: '0');
    }
  }
  static Future<List<Bviewer>> getMetaDataUpdate() async {
    final db   = await SQLHelper.db();
    final data = await db.query('viewer', columns: ['app_book_id','page','dataobj'], where: "update_date=?",whereArgs: [1],orderBy: 'app_book_id');
    var resp   =  List<Bviewer>.from(data.map((x) => Bviewer.fromMap(x)));
    return resp;
  }
  static Future<void> drawData(Bviewer data) async {

    if (kDebugMode) {
      print("appBookId = ${data.bookAppId}, page = ${data.page}, module = ${data.module}");
    }
    final db = await SQLHelper.db();
    /// Transaction
    await db.transaction((txn) async {
      await txn.delete('viewer', where: "app_book_id =? and module =? and page =?", whereArgs: [data.bookAppId, data.module, data.page]);
      await txn.insert('viewer', data.toMap(), conflictAlgorithm: sql.ConflictAlgorithm.replace);
    });

  }
  static Future<void> drawSioriData(Bviewer data) async {

    final db = await SQLHelper.db();
    /// Transaction
    await db.transaction((txn) async {
      await txn.delete('viewer', where: "app_book_id =? and module =?", whereArgs: [data.bookAppId, 'siori']);
      await txn.insert('viewer', data.toMap(), conflictAlgorithm: sql.ConflictAlgorithm.replace);
    });

  }
  static Future<bool> updateMetaDataFromServer(Map pages,List<dynamic> bookmark, String bookAppId) async {
    var result = false;
    var rows = <Map<String, String>>[];
    pages.forEach((key, value) {
      if (key != null) {
        if (kDebugMode) {
        }
        rows.add({"app_book_id": bookAppId,"update_date":'0',"module": 'listdata',"page": key,"dataobj": jsonEncode(value) });
      }
    });
    if(bookmark.isNotEmpty){
      rows.add({"app_book_id": bookAppId,"update_date":'0',"module": 'siori',"page": '',"dataobj": bookmark.join(',') });
    }

    final db = await SQLHelper.db();
    var batch = db.batch();
    batch.delete('viewer',where: "app_book_id =?", whereArgs: [bookAppId]);
    for (var e in rows) {
      batch.insert('viewer', e);
    }
    await batch.commit(noResult: true);
    result   = true;
    return result;


  }
  static Future<int> updateMetaDataLocal(Map book) async {
    var count = 0;
    if (kDebugMode) {
      print(book['bookId']);
    }
    var bookAppId = book['bookId'];
    final db = await SQLHelper.db();
    await db.transaction((txn) async {
      count  = await txn.rawUpdate('UPDATE viewer SET update_date = ? WHERE app_book_id = ?',[0,bookAppId]);
    });
    return count;


  }
  static Future<void> saveOrUpdateViewer(Bviewer data) async {

    final db  = await SQLHelper.db();
    /// Initialize batch
    final batch = db.batch();

    /// Batch insert
    var mapResp = await getSingleViewer(data.bookAppId,data.page!,data.module!);
    if (kDebugMode) {
      print(mapResp.bookAppId);
    }
    if(mapResp.bookAppId == "0"){
      if (kDebugMode) {
        print("new");
      }
      await saveViewer(data);

    }else{
      if (kDebugMode) {
        print("update");
      }
      await updateViewer(data);
    }

    /// Commit
    await batch.commit(noResult: true);
    if (kDebugMode) {
      print("--------------- success-----------------");
    }
    // // var db = await SQLHelper.db();
    // // db.transaction((txn) async {
    //   var mapResp = await getSingleViewer(data.bookAppId,data.page!,data.module!);
    //   if (kDebugMode) {
    //     print(mapResp.bookAppId);
    //   }
    //   if(mapResp.bookAppId == "0"){
    //     if (kDebugMode) {
    //       print("new");
    //     }
    //     await saveViewer(data);
    //
    //   }else{
    //     if (kDebugMode) {
    //       print("update");
    //     }
    //     await updateViewer(data);
    //   }

    // });
  }
  static Future<int> updateViewer(Bviewer data) async {
    final db = await SQLHelper.db();
    return await db.update('viewer', data.toMap(), where: "app_book_id = ?", whereArgs: [data.bookAppId]);
  }
  static Future<void> deleteViewer() async {
    final db = await SQLHelper.db();
    await db.transaction((txn) async {
      await txn.rawDelete('DELETE FROM viewer WHERE update_date = ?', [1]);
    });
  }
  //todo: check transaction
  static Future<int> updateViewer2(List<Bviewer> list) async {
    final dbClient = await SQLHelper.db();

    /// Batch insert
    final batch    = dbClient.batch();
    for (var i = 0; i < list.length; i++) {
      batch.insert("viewer", list[i].toMap());
    }
    await batch.commit(noResult: true);

    /// Transaction
    await dbClient.transaction((txn) async {
      await txn.update('viewer', {}, where: "app_book_id = ?", whereArgs: ['1']);
      await txn.execute("DELETE FROM Posts");
    });
    return 1;
  }
  //todo: User
  static Future<UserEntity>  saveUser(UserEntity u) async {
    final db = await SQLHelper.db();
    final id = await db.insert('user', u.toMap(), conflictAlgorithm: sql.ConflictAlgorithm.replace);
    var data = await db.query('user', where: "id = ?", whereArgs: [id], limit: 1);
    var resp =  List<UserEntity>.from(data.map((x) => UserEntity.fromMap(x)));
    if(resp.isNotEmpty){
      return resp[0] ;
    }else{
      return UserEntity();
    }
  }
  static Future<UserEntity> getUser(String idx) async {
    final db = await SQLHelper.db();
    var data = await db.query('user', where: "idx = ?", whereArgs: [idx], limit: 1);
    var resp =  List<UserEntity>.from(data.map((x) => UserEntity.fromMap(x)));
    if(resp.isNotEmpty){
      return resp[0] ;
    }else{
      return UserEntity();
    }
  }
  static Future<int> updateUser(UserEntity u) async {
    final db = await SQLHelper.db();
    var data = await db.update('user', u.toMap(), where: "id = ?", whereArgs: [u.id]);
    return data;

  }
  static Future<int> deleteUser(UserEntity u) async {
    final db = await SQLHelper.db();
    var data = await db.delete('user', where: "id = ?", whereArgs: [u.id]);
    return data;

  }

  //TODO: wbook_synchro_time
  // wbook_synchro_time
  static Future<List<WBookSynchroTime>> getALlWBookSynchroTime() async {
    final db   = await SQLHelper.db();
    final data = await db.query('wbook_synchro_time', orderBy: 'id');
    var resp   =  List<WBookSynchroTime>.from(data.map((x) => WBookSynchroTime.fromJson(x)));
    return resp;
  }
  static Future<WBookSynchroTime> getOnceWBookSynchroTime(String bookID, String idx, String mem_id) async {
    final db    = await SQLHelper.db();
    List result = await db.query('wbook_synchro_time', where: 'book_seq = ? AND user_idx = ? AND mem_id = ?', whereArgs: [bookID, idx, mem_id]);
    if (result.isNotEmpty) {
      return WBookSynchroTime.fromJson(result.first);
    } else {
      return WBookSynchroTime();
    }
  }
  static Future<void> saveWBookSynchroTimeByState(String book_seq, String mem_id, String user_idx, String time, bool isOnline) async {
    final checkDB = await getALlWBookSynchroTime();
    bool check = false;
    for (var element in checkDB) {
      if (element.user_idx == user_idx && element.book_seq == book_seq && element.mem_id == mem_id) {
        check = true;
      }
    }

    if (isOnline) {
      if (check) {
        updateWBookSynchroTimeOnline(book_seq, mem_id, user_idx, time);
      } else {
        createWBookSynchroTimeOnline(book_seq, mem_id, user_idx, time);
      }
    } else {
      if (check) {
        updateWBookSynchroTimeOffline(book_seq, mem_id, user_idx, time);
      } else {
        createWBookSynchroTimeOffline(book_seq, mem_id, user_idx, time);
      }
    }
  }
  static Future<void> saveWBookSynchroTime(String book_seq, String mem_id, String user_idx, String time) async {
    final checkDB = await getALlWBookSynchroTime();
    bool check = false;
    for (var element in checkDB) {
      if (element.user_idx == user_idx && element.book_seq == book_seq && element.mem_id == mem_id) {
        check = true;
      }
    }

    if (check) {
      updateWBookSynchroTime(book_seq, mem_id, user_idx, time);
    } else {
      createWBookSynchroTime(book_seq, mem_id, user_idx, time);
    }
  }
  static Future<int> createWBookSynchroTime(String book_seq, String mem_id, String user_idx, String time) async {
    final db = await SQLHelper.db();
    return await db.rawInsert('INSERT INTO wbook_synchro_time(book_seq, mem_id, user_idx, synchro_online_at, synchro_offline_at) VALUES(?, ?, ?, ?, ?)', [book_seq, mem_id, user_idx, time, time]);
  }
  static Future<int> createWBookSynchroTimeOnline(String book_seq, String mem_id, String user_idx, String time) async {
    final db = await SQLHelper.db();
    return await db.rawInsert('INSERT INTO wbook_synchro_time(book_seq, mem_id, user_idx, synchro_online_at) VALUES(?, ?, ?, ?)', [book_seq, mem_id, user_idx, time]);
  }
  static Future<int> createWBookSynchroTimeOffline(String book_seq, String mem_id, String user_idx, String time) async {
    final db = await SQLHelper.db();
    return await db.rawInsert('INSERT INTO wbook_synchro_time(book_seq, mem_id, user_idx, synchro_offline_at) VALUES(?, ?, ?, ?)', [book_seq, mem_id, user_idx, time]);
  }

  static Future<int> updateWBookSynchroTime(String book_seq, String mem_id, String user_idx, String time) async {
    final db = await SQLHelper.db();
    return await db.rawUpdate('UPDATE wbook_synchro_time SET synchro_online_at = ?, synchro_offline_at = ? WHERE book_seq = ? AND user_idx = ? AND mem_id = ?',
        [time, time, book_seq, user_idx, mem_id]);
  }
  static Future<int> updateWBookSynchroTimeOnline(String book_seq, String mem_id, String user_idx, String time) async {
    final db = await SQLHelper.db();
    return await db.rawUpdate('UPDATE wbook_synchro_time SET synchro_online_at = ? WHERE book_seq = ? AND user_idx = ? AND mem_id = ?',
        [time, book_seq, user_idx, mem_id]);
  }
  static Future<int> updateWBookSynchroTimeOffline(String book_seq, String mem_id, String user_idx, String time) async {
    final db = await SQLHelper.db();
    return await db.rawUpdate('UPDATE wbook_synchro_time SET synchro_offline_at = ? WHERE book_seq = ? AND user_idx = ? AND mem_id = ?',
        [time, book_seq, user_idx, mem_id]);
  }

  static Future<int> deleteWBookSynchroTime(String book_seq, String mem_id, String user_idx) async {
    final db = await SQLHelper.db();
    return await db.delete('wbook_synchro_time', where: 'book_seq = ? AND mem_id = ? AND user_idx = ?', whereArgs: [book_seq, mem_id, user_idx]);
  }

  static Future<String> getLatestWBookSynchroTimeOffLine(String mem_id, String user_idx) async {
    String result = '';
    final db = await SQLHelper.db();
    var data = await db.rawQuery("SELECT max(synchro_offline_at) FROM wbook_synchro_time WHERE mem_id = ? AND user_idx = ? ORDER BY synchro_offline_at DESC LIMIT 1", [mem_id, user_idx]);
    if (data.isNotEmpty) {
      data.first.forEach((key, value) {
        result = value.toString();
      });
    }
    return result;
  }

  static Future<String> getLatestWBookSynchroTimeOnline(String mem_id, String user_idx) async {
    String result = '';
    final db = await SQLHelper.db();
    var data = await db.rawQuery("SELECT synchro_online_at FROM wbook_synchro_time WHERE mem_id = ? AND user_idx = ? ORDER BY synchro_online_at DESC LIMIT 1", [mem_id, user_idx]);
    if (data.isNotEmpty) {
      data.first.forEach((key, value) {
        result = value.toString();
      });
    }
    return result;
  }

}

