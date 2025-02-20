
import 'dart:convert';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../app/utils/constants/strings.dart';
import '/app/utils/server.dart';
import '../../../app/services/authen_service.dart';
import '../../../app/services/book_provider.dart';
import '../../../data/datasources/local/db_help.dart';
import '../../../data/models/bookModel.dart';
import '../../pages/reading/reading_view.dart';

class BookDetailController extends GetxController{
  //TODO: Implement HomeController
  final auth               = Get.find<AuthenService>();
  static BookDetailController get to => Get.find();
  late   String description       = '';
  var    bookShelf                = Bshelf().obs;
  var    processing               = 0.0.obs;
  final  _isDisable                = true.obs;
  var box                         = GetStorage('info',dir);
  bool            get isOpenBook  => _isDisable.value;
  set isOpenBook(value)           => _isDisable.value = value;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> getBookDetail(String bookSeq) async{
    getInfo(bookSeq);
    setBookInfo(bookSeq);
  }
  Future<void> getInfo(String bookSeq) async   {
    if (kDebugMode) {
    }
    try{
      var data = await BookProvider().getBookDetail(bookSeq);
      description   = data.script!;
      update();
    }catch(ex){
      if (kDebugMode) {
        print(ex);
      }
    }
  }
  Future<bool> setBookInfo(String bookSeq) async   {
    bool result = true;
    bookShelf.value = await SQLHelper.getBookInfo(bookSeq);
    if(bookShelf.value.id == null){
      result = false;
      _isDisable.value   = true;
      _getBookInfo(bookSeq);
    }else{
      _isDisable.value   = false;
    }
    update();
    return result;
  }
  Future<void> _getBookInfo(String bookSeq) async {
    var bookInfo     =  await BookProvider().bookInfo(corpname,bookSeq);
    Bshelf bookSave  = Bshelf(
      bookAppId   : bookInfo.bookAppId,
      bookPath    : "${bookInfo.author!}/${bookInfo.bookAppId!}",
      title       : bookInfo.title,
      thumbPath   : bookInfo.image,
      thumbH      : bookInfo.imageH,
      thumbW      : bookInfo.imageW,
      size        : bookInfo.filesize,
      pages       : bookInfo.pages,
      download    : bookInfo.download,
      cateSeq       : "0",
      evenType      : "",
      bookInfo      : jsonEncode(bookInfo.bookInfo),
      planType      : "",
      procQueuStatus: "",
      procWaitBusy  : "0",
      selected      : "",
      status        : "0",
      sortNo        : 0,
      isDownload    : 0,
      pdfId         : 0,
      cateId        : 1,
      lastPage      : 1,
    );
    bookShelf.value  = await SQLHelper.saveBookShelf(bookSave);
    if(bookShelf.value.id! > 0){
      _downloadFile(bookInfo.bookAppId);
    }
    if (kDebugMode) {
      print("Saved");
      print(bookShelf.value.id);
      print(bookInfo.bookAppId);
    }
  }
  Future<void> _downloadFile(id) async {
    if (kDebugMode) {
      print("download book $id");
    }
    try {
      String savePath = "$dir/$id.zip";
      String url      = '${host}bookstorexp/json_dn_book/$corpname/$id';
      if (kDebugMode) {
        printInfo(info: url);
        print(savePath);
      }
      Dio dio = Dio();
      if (kDebugMode) {
        print('PHPSESSID');
        print(auth.session.value);
      }
      dio.options.headers["Cookie"] = "PHPSESSID=${auth.session.value}";
      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (rcv, total){
          if (rcv < total) {
            processing.value = (((rcv / total) * 100)/100).toPrecision(2);
            if (kDebugMode) {
              print("processing $rcv");
            }
          }else{
            processing.value = 0;
            if (kDebugMode) {
              print("download success");
            }
          }
      },
        deleteOnError: true,

      ).then((value) async {
          /// --- unzip
          final zip            = File(savePath);
          var directoryPath    = '$dir/web/$id';
          try {
            final bytes   = zip.readAsBytesSync();
            final archive = ZipDecoder().decodeBytes(bytes);

            for (final file in archive) {
              final filename = file.name;
              if (file.isFile) {
                final data = file.content as List<int>;
                File('$directoryPath/$filename')..createSync(recursive: true)..writeAsBytesSync(data);
              } else {
                Directory('$directoryPath/$filename').create(recursive: true);
              }
            }
            if (zip.existsSync()) {
              zip.delete();
            }
            _upBookShelfPath(directoryPath);
          } catch (e) {
            if (kDebugMode) {
            }
          }
      }).onError((error, stackTrace){
        // alertDialog("download error",error.toString());
      });
    } catch (e) {
      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }
  Future<void> _upBookShelfPath(directoryPath) async {
    bookShelf.value.thumbPath  = "$directoryPath/thumb.jpg";
    bookShelf.value.isDownload = 1; // 1 yes, 0 no
    bookShelf.value.status     = '100'; // done
    if (kDebugMode) {
      print("directoryPath $directoryPath");
    }
    await SQLHelper.updateBookShelf(bookShelf.value).then((value){
      _isDisable.value = false;
      if (kDebugMode) {
      }
    });
  }
  Future<int>  updateLastPage(stringUrl) async {
    final page = stringUrl.split('#');
    bookShelf.value.lastPage     = page.length > 1 ? int.tryParse(page[1]) : 1; // done
    final result =  await SQLHelper.updateBookShelf(bookShelf.value);
    if (kDebugMode) {
      print("Book ${bookShelf.value.bookAppId}");
      print("lastPage ${bookShelf.value.lastPage}");
    }
    return result > 0 ? 1 : 0;
  }
  Future<void> saveLocalStorage(wController) async {
    var store = await wController?.evaluateJavascript(source:"window.localStorage.getItem('jStorage')");
    box.write('jStorage',store);
    if (kDebugMode) {
      printInfo(info: 'saveLocalStorage');
    }
  }
  Future<void> syncLocalStorage(wController) async {
    var storeData = box.read('jStorage');
    if(storeData.toString() != 'null'){
      await wController?.evaluateJavascript(source:"window.localStorage.setItem('jStorage','$storeData')");
    }
    if (kDebugMode) {
      printInfo(info: 'syncLocalStorage');
    }
  }
  void openBook(BuildContext context, String bookId, int page) async{
     var info = await setBookInfo(bookId);
     if(info){
       printInfo(info: "Open book");
       String stringUrl = "${host}html/$corpname/$bookId/#${bookShelf.value.lastPage}";
       printInfo(info: "Book Id ${bookShelf.value.id}");
       if(bookShelf.value.id! > 0){
         if(Platform.isMacOS){
           final ReadingPage browser = ReadingPage();
           await browser.openUrlRequest(
             urlRequest:URLRequest(url: WebUri(stringUrl)),
             settings: InAppBrowserClassSettings(
               browserSettings: InAppBrowserSettings(
                 hideToolbarTop: true,
                 toolbarTopBackgroundColor: Colors.transparent,
                 presentationStyle: ModalPresentationStyle.FULL_SCREEN,
                 allowGoBackWithBackButton: false,

               ),
               webViewSettings: InAppWebViewSettings(
                 isInspectable: kDebugMode,
                 javaScriptEnabled: true,
                 useShouldOverrideUrlLoading: true,
                 useOnLoadResource: true,
               ),
             ),
           );
         }else{
           String urlWin =  "${host}html/$corpname/$bookId/#${bookShelf.value.lastPage}";
           printInfo(info: "windows");
           printInfo(info: "Book Id ${bookShelf.value.id}");
           printInfo(info: "urlWin = $urlWin");
           //todo: online
           context.push('/windows', extra: {'url': urlWin, 'session' : auth.session.value, 'book' : bookShelf.value});

           //todo: offline
           // String urlWin = 'http://127.0.0.1:8088/?bookId=${bookShelf.value.bookAppId}&id=${auth.idx}#${bookShelf.value.lastPage}';
           //context.push('/windows-off', extra: {'url': urlWin, 'session' : auth.session.value, 'book' : bookShelf.value});
         }
       }
     }
  }
}