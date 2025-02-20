import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../app/utils/constants/strings.dart';
import '../../../app/utils/server.dart';
import '../../models/bookModel.dart';

class SQLMetaData {

  static Future<sql.Database> db() async {

    if(io.Platform.isWindows){
      var databaseFactory = databaseFactoryFfi;
      String dbPath = p.join("$dir/web", dbname);
      var db = await databaseFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
            version: 1,
            onCreate: (sql.Database database, int version) async {
              await createTables(database);
            }
        ),
      );
      return db;
    }else{
      String dbPath = p.join("$dir/web", dbname);
      var db = sql.openDatabase(dbPath,version: 1,
        onCreate: (sql.Database database, int version) async {
          await createTables(database);
        },
      );
      return db;
    }

  }

  Future close() async {
    final db = await SQLMetaData.db();
    return db.close();
  }

  static Future<void> createTables(sql.Database db) async {


    // viewer
    await db.execute('CREATE TABLE '
        'viewer('
        '             app_book_id TEXT, '
        '             module TEXT, '
        '             page INTEGER, '
        '             dataobj TEXT)');
  }

  //TODO: Viewer
  static Future<Bviewer> saveViewer(Bviewer viewer) async {
    final db = await SQLMetaData.db();
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
    final db = await SQLMetaData.db();
    List result = await db.query('viewer', where: "app_book_id =? and module =? and page =?", whereArgs: [appBookId, module, page], limit: 1);
    print(result);
    if (result.isNotEmpty) {
      return Bviewer.fromMap(result.first);
    }else{
      return Bviewer(bookAppId: '0');
    }
  }
  static Future<void> drawData(Bviewer data) async {

    if (kDebugMode) {
      print("appBookId = ${data.bookAppId}, page = ${data.page}, module = ${data.module}");
    }
    final db = await SQLMetaData.db();
    /// Transaction
    await db.transaction((txn) async {
      await txn.delete('viewer', where: "app_book_id =? and module =? and page =?", whereArgs: [data.bookAppId, data.module, data.page]);
      await txn.insert('viewer', data.toMap(), conflictAlgorithm: sql.ConflictAlgorithm.replace);
    });

  }
  static Future<void> saveOrUpdateViewer(Bviewer data) async {

    final db  = await SQLMetaData.db();
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
    final db = await SQLMetaData.db();
    return await db.update('viewer', data.toMap(), where: "app_book_id = ?", whereArgs: [data.bookAppId]);
  }
  //todo: check transaction
  static Future<int> updateViewer2(List<Bviewer> list) async {
    final dbClient = await SQLMetaData.db();

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

}

