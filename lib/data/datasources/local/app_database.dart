import 'dart:async';

import 'package:floor/floor.dart';
import '/data/datasources/local/dao/bshelf_dao.dart';
import '/data/datasources/local/dao/category_book_dao.dart';
import '/data/datasources/local/dao/category_dao.dart';
import '/data/datasources/local/dao/mem_info_dao.dart';
import '/domain/entities/viewer.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../../domain/entities/category.dart';
import '../../../domain/entities/category_book.dart';
import '../../../domain/entities/mem_Info.dart';
import '../../../domain/entities/option.dart';
import '../../../domain/entities/shelf.dart';
import '../../../domain/models/article.dart';
import 'dao/article_dao.dart';
import 'converters/source_type_converter.dart';
part 'app_database.g.dart';

@TypeConverters([SourceTypeConverter])
@Database(version: 1, entities: [Article,Shelf,MemInfo,Option,Viewer,Category,CategoryBook])
abstract class AppDatabase extends FloorDatabase {
  ArticleDao        get articleDao;
  ShelfDao          get shelfDao;
  MemInfoDao        get memInfoDao;
  CategoryDao       get categoryDao;
  CategoryBookDao   get categoryBookDao;
}
