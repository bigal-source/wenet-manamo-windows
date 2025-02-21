import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:archive/archive.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';
import '../../../app/services/download_book_service.dart';
import '../../../app/utils/constants/strings.dart';
import '/app/utils/server.dart';
import '../../../app/services/authen_service.dart';
import '../../../app/services/book_provider.dart';
import '../../../data/datasources/local/db_help.dart';
import '../../../data/models/bookModel.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:window_size/window_size.dart' as winSize;

class BookDetailController extends GetxController{
  //TODO: Implement HomeController
  final auth               = Get.find<AuthenService>();
  static BookDetailController get to => Get.find();
  late   String description       = '';
  var    bookShelf                = Bshelf().obs;
  var    processing               = 0.0.obs;
  final  _isDisable               = true.obs;
  var box                         = GetStorage('info',dir);
  bool            get isOpenBook  => _isDisable.value;
  set isOpenBook(value)           => _isDisable.value = value;
  bool isFull = false;

  @override
  Future<void> onInit() async {
    super.onInit();
  }
  Future<void> getBookDetail(String bookSeq) async{
    await getInfo(bookSeq);
    await setBookInfo(bookSeq);
  }
  Future<void> getInfo(String bookSeq) async   {
    try {
      var data = await BookProvider().getBookDetail(bookSeq);
      description   = data.script!;
      update();
    } catch(ex) {
      rethrow;
    }
  }
  Future<bool> setBookInfo(String bookSeq) async {
    bool result = true;
    bookShelf.value = await SQLHelper.getBookInfo(bookSeq);
    if (bookShelf.value.id == null) {
      result = false;
      _isDisable.value   = true;
      await _getBookInfo(bookSeq);
    } else if (bookShelf.value.status.toString() == "0") {
      // _downloadFile(bookShelf.value.bookAppId!);
      downloadBook(bookShelf.value.bookAppId!);
      _isDisable.value = true;
    } else {
      _isDisable.value = false;
    }
    update();
    return result;
  }
  Future<void> _getBookInfo(String bookSeq) async {
    var bookInfo     =  await BookProvider().bookInfo(corpname,bookSeq);
    String deviceId = '';
    if (Platform.isWindows) {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.windowsInfo;
      deviceId = deviceInfo.deviceId;
    }

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
        deviceId      : deviceId
    );
    bookShelf.value  = await SQLHelper.saveBookShelf(bookSave);
    if(bookShelf.value.id! > 0){
      _downloadFile(bookInfo.bookAppId!);
      // downloadBook(bookInfo.bookAppId!);
    }
    if (kDebugMode) {
      print("Saved");
      print(bookShelf.value.id);
      print(bookInfo.bookAppId);
    }
  }
  Future<void> _downloadFile(id) async {
    try {
      String savePath = "$dir/$id.zip";
      String url      = '${host}bookstorexp/json_dn_book/$corpname/$id';
      if (kDebugMode) {
        print(url);
        print(savePath);
      }
      Dio dio = Dio();
      if (kDebugMode) {
        print('PHPSESSID');
        print(auth.session.value);
      }
      // dio.options.headers["Cookie"] = "PHPSESSID=${auth.session.value}";
      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (rcv, total){
          if (rcv < total) {
            processing.value = (((rcv / total) * 100)/100).toPrecision(2);
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
  Future<void> downloadBook(String id) async {
    final directory = dir;
    DownloadBook downloadBook = DownloadBook(
        bShelf: bookShelf.value,
        bookID: id,
        session: auth.session.value,
        zipPath: "$directory/$id.zip",
        unZipPath: "$directory/web/$id"
    );
    downloadBook.download().then((value) {
      _isDisable.value = value;
      processing.value = 0.0;
    });
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
      // printInfo(info: "Book Id ${bookShelf.value.id}");
      if(bookShelf.value.id! > 0){
        printInfo(info: "windows");
        final webview = await WebviewWindow.create(
          configuration: CreateConfiguration(
            title: bookShelf.value.title!,
            userDataFolderWindows: await _getWebViewPath(),
            titleBarHeight:20,
            titleBarTopPadding: Platform.isMacOS ? 20 : 0,
            // openMaximized: true,
          ),
        );
        WebviewWindow.isWebviewAvailable().then((value) async {
          printInfo(info: "$value + AAA");
          webview
            ..addScriptToExecuteOnDocumentCreated("document.cookie = '_cookie_appuser_info_=${box.read('token')};  path=/'")
            ..addScriptToExecuteOnDocumentCreated("""
              document.cookie = 'PHPSESSID=${box.read('session')}'
            """)
            ..addScriptToExecuteOnDocumentCreated("""

                 function createCookie(name,value,days) {
                        if (days) {
                            var date = new Date();
                            date.setTime(date.getTime() + (days * 24 * 60 * 60 *1000));
                            var expires = "; expires=" + date.toGMTString();
                        } else {
                            var expires = "";
                        }
                        document.cookie = name + "=" + value + expires + "; path=/";
                    }
        
                    function readCookie(name) {
                        var nameEQ = name + "=";
                        var ca = document.cookie.split(';');
                        for(var i=0;i < ca.length;i++) {
                            var c = ca[i];
                            while (c.charAt(0)==' ') {
                                c = c.substring(1,c.length);
                            }
                            if (c.indexOf(nameEQ) == 0) {
                                return c.substring(nameEQ.length,c.length);
                            }
                        }
                        return null;
                    }
        
                    function eraseCookie(name) {
                        createCookie(name,"${box.read('session')}",1);
                    }
                  eraseCookie('PHPSESSID');
                  document.cookie = 'PHPSESSID=${box.read('session')}'
                  const mixinContext = {
                    platform: 'Desktop',
                    conversation_id: 'conversationId',
                    immersive: false,
                    app_version: '1.0.0',
                    appearance: 'dark',
                  }
                  window.MixinContext = {
                    getContext: function() {
                      return JSON.stringify(mixinContext)
                    }
                  }
                """)
            ..setBrightness(Brightness.dark)
            ..setApplicationNameForUserAgent("flt WinAPP")
            ..launch('${host}html/$corpname/$bookId/#$page')
            ..setOnUrlRequestCallback((url) {
              debugPrint('LOAD URL: $url');
              webview.addScriptToExecuteOnDocumentCreated("""
                    document.cookie = 'PHPSESSID=${box.read('session')}'
              """);
              final uri = Uri.parse(url);
              if (uri.path == '/login_success') {
                debugPrint('login success. token: ${uri.queryParameters['token']}');
                webview.close();
              }
              return true;
            })
            ..evaluateJavaScript("""  document.cookie = 'PHPSESSID=${box.read('session')}'  """)
            ..setOnHistoryChangedCallback((canGoBack, canGoForward) {
              print('canGoBack: $canGoBack');
              print('canGoForward: $canGoForward');
            })
            ..addOnWebMessageReceivedCallback((message) async {
              if (message.toString() == 'full') {
                Size appSize = await windowManager.getSize();
                if (isFull) {
                  var screen = await winSize.getCurrentScreen();
                  var size = screen?.visibleFrame;
                  double screenWidth = size!.width;
                  double screenHeight = size.height;
                  int centerWidth = screenWidth.round() - appSize.width.round();
                  int centerHeight = screenHeight.round() - appSize.height.round();
                  int centerX = (centerWidth / 2).round();
                  int centerY = (centerHeight / 2).round();
                  webview.moveWebviewWindow(centerX, centerY, appSize.width.round(), appSize.height.round());
                  isFull = false;
                  webview.bringToForeground();
                } else {
                  var screen = await winSize.getCurrentScreen();
                  var size = screen?.visibleFrame;
                  double width = size!.width;
                  double height = size.height;
                  webview.moveWebviewWindow(-5, 0, width.round() + 10, height.round() + 10);
                  isFull = true;
                }
              }
            })
            ..onClose.whenComplete(() { debugPrint("on close"); });
          await Future.delayed(const Duration(seconds: 1));
          webview
            ..setWebviewWindowVisibility(true)
            ..reload()
            ..setOnUrlRequestCallback((url) {
              /// WNT_20241004 (6)
              if (!url.contains(host)) {
                webview.stop();
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                return false;
              } else {
                return true;
              }
            });
        });
        await Future.delayed(const Duration(seconds: 0));
        for (final javaScript in javaScriptToEval) {
          try {
            var ret = await webview.evaluateJavaScript(javaScript);
            await webview.evaluateJavaScript("""  document.cookie = 'PHPSESSID=${box.read('session')}'  """);
            debugPrint('evaluateJavaScript: $ret');
            if(ret == null){
              webview.reload();
            }
          } catch (e) {
            // debugPrint('evaluateJavaScript error: $e \n $javaScript');
          }
        }
      }
    }
  }
  List<String> javaScriptToEval = [
    //   """
    // function getCookie(cname) {
    //   let name = cname + "=";
    //   let decodedCookie = decodeURIComponent(document.cookie);
    //   let ca = decodedCookie.split(';');
    //   for(let i = 0; i <ca.length; i++) {
    //     let c = ca[i];
    //     while (c.charAt(0) == ' ') {
    //       c = c.substring(1);
    //     }
    //     if (c.indexOf(name) == 0) {
    //       return c.substring(name.length, c.length);
    //     }
    //   }
    //   return cname;
    // }
    // """,
    'eval({"user_agent": navigator.userAgent, "cookie":document.cookie})',
  ];
  Future<String> _getWebViewPath() async {
    return p.join(
      dir,
      'viewer',
    );
  }
}