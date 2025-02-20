import 'dart:io';
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:manamo/data/models/bookModel.dart';
import '../../data/datasources/local/db_help.dart';
import '../../presentation/controllers/book_detail/book_detail_controller.dart';
import '../utils/constants/strings.dart';
import '../utils/server.dart';
import 'package:archive/archive.dart';

class DownloadBook {
  Bshelf bShelf;
  String bookID;
  String session;
  String zipPath;
  String unZipPath;

  DownloadBook(
      {
        required this.bShelf,
        required this.bookID,
        required this.session,
        required this.zipPath,
        required this.unZipPath,
      });

  Future<bool> download() async {
    var bookDetail = Get.find<BookDetailController>();
    bool complete = false;
    if (kDebugMode) {
      await FileDownloader().configure(globalConfig: ('bypassTLSCertificateValidation', true));
    }
    final task = DownloadTask(
      taskId: bookID,
      url: '${host}bookstorexp/json_dn_book/$corpname/$bookID',
      filename: '$bookID.zip',
      headers: {'Cookie': 'PHPSESSID=$session'},
      directory: dir,
      updates: Updates.statusAndProgress,
      requiresWiFi: true,
      allowPause: false,
    );

    final result = await FileDownloader().download(
      task,
      onProgress: (progress) {
        print(progress);
        bookDetail.processing.value = progress;
      },
      onStatus: (status) {
        print(status);
      }
    );

    switch (result.status) {
      case TaskStatus.complete:
        unzipFile().then((value) {
          if (value) {
            complete = true;
          }
        });
        break;
      default:
        print(result.exception);
        complete = false;
        break;
    }
    return complete;
  }

  Future<bool> unzipFile() async {
    bool result = false;
    final zipFile = File(zipPath);
    if (zipFile.existsSync()) {
      try {
        final bytes   = zipFile.readAsBytesSync();
        final archive = ZipDecoder().decodeBytes(bytes);
        for (final file in archive) {
          final filename = file.name;
          if (file.isFile) {
            final data = file.content as List<int>;
            File('$unZipPath/$filename')..createSync(recursive: true)..writeAsBytesSync(data);
          } else {
            Directory('$unZipPath/$filename').create(recursive: true);
          }
        }
        zipFile.delete();
      } catch (e) {
        rethrow;
      } finally {
        updateDB().then((value) {
          if (value == 1) {
            result = true;
          }
        });
      }
    }
    return result;
  }

  Future<int> updateDB() async {
    bShelf.thumbPath  = "$unZipPath/thumb.jpg";
    bShelf.isDownload = 1; // 1 yes, 0 no
    bShelf.status     = '100'; // done
    return await SQLHelper.updateBookShelf(bShelf);
  }
}