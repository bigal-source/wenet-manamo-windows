
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:archive/archive.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../app/utils/constants/strings.dart';
import '/app/utils/server.dart';
import 'package:path_provider/path_provider.dart';
import '../../../app/services/authen_service.dart';
import '../../../app/services/book_provider.dart';
import '../../../data/datasources/local/db_help.dart';
import '../../../data/models/bookModel.dart';
import '../../../data/models/book_info.dart';
import '../../pages/reading/reading_view.dart';

class BookDetailController extends GetxController{
  //TODO: Implement HomeController
  static BookDetailController get to => Get.find();
  late   String description       = '';
  var    bookShelf                = Bshelf().obs;
  var    processing               = 0.0.obs;
  var box           = GetStorage();

  @override
  Future<void> onInit() async {
    super.onInit();
    printInfo(info: "Book detail");
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
      _getBookInfo(bookSeq);
    }
    if (kDebugMode) {
      printInfo(info: "SaveInfo $bookSeq");
      printInfo(info: "exited $result");
      printInfo(info: "lastPage ${bookShelf.value.lastPage}");
    }
    update();
    return result;
  }
  Future<void> _getBookInfo(String bookSeq) async {
    var infoBook =  await BookProvider().bookInfo(corpname,bookSeq);
    _addBookShelf(infoBook);
    if (kDebugMode) {
    }
  }
  Future<void> _addBookShelf(BookInfoModel bookInfo) async {

    Bshelf bookSave    = Bshelf(
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
      var path = (await getApplicationDocumentsDirectory()).absolute.path;
      String savePath = "$path/$id.zip";
      String url      = '${host}bookstorexp/json_dn_book/$corpname/$id';
      if (kDebugMode) {
        printInfo(info: url);
        print(savePath);
      }
      final auth               = Get.find<AuthenService>();
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
          var root             = await getApplicationDocumentsDirectory();
          var directoryPath    = '${root.path}/web/$id';
          final destinationDir = Directory(directoryPath);
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
      })
          .onError((error, stackTrace){
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
      if (kDebugMode) {
      }
    });
  }
  void openBook(String bookId, int page) async{
    var box           = GetStorage();
    setBookInfo(bookId);
    printInfo(info: "Open book");
    String stringUrl = "${host}html/$corpname/$bookId/#${bookShelf.value.lastPage}";
    if(Platform.isMacOS){

      final ReadingPage browser = ReadingPage();
      await browser.openUrlRequest(
        urlRequest:URLRequest(url: WebUri(stringUrl)),
        settings: InAppBrowserClassSettings(
          browserSettings: InAppBrowserSettings(
            // hideUrlBar: true,
            // hideTitleBar: true,
            // hideProgressBar: true,
            // hideToolbarBottom: true,
            // hideDefaultMenuItems: true,
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

      printInfo(info: "windows");
      final webview = await WebviewWindow.create(
        configuration: CreateConfiguration(
          title: bookShelf.value.title!,
          userDataFolderWindows: await _getWebViewPath(),
          titleBarHeight:20,
          titleBarTopPadding: Platform.isMacOS ? 20 : 0,
          openMaximized: true,
        ),
      );
      WebviewWindow.isWebviewAvailable().then((value) async {
        printInfo(info: value.toString());
        webview.addScriptToExecuteOnDocumentCreated("""
          document.cookie = 'PHPSESSID=${box.read('PHPSESSID')}'
        """);
      });
      webview
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
                createCookie(name,"${box.read('PHPSESSID')}",1);
            }
          eraseCookie('PHPSESSID');
          document.cookie = 'PHPSESSID=${box.read('PHPSESSID')}'
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
        ..setApplicationNameForUserAgent("flt")
        ..launch('${host}html/$corpname/$bookId/#$page')
        ..setOnUrlRequestCallback((url) {
          debugPrint('url: $url');
          webview.addScriptToExecuteOnDocumentCreated("""
              document.cookie = 'PHPSESSID=${box.read('PHPSESSID')}'
        """);
          final uri = Uri.parse(url);
          if (uri.path == '/login_success') {
            debugPrint('login success. token: ${uri.queryParameters['token']}');
            webview.close();
          }
          return true;
        })
        ..evaluateJavaScript("""  document.cookie = 'PHPSESSID=${box.read('PHPSESSID')}'  """)
        ..onClose.whenComplete(() {
          debugPrint("on close");
        });
      await Future.delayed(const Duration(seconds: 2));
      for (final javaScript in _javaScriptToEval) {
        try {
          final ret = await webview.evaluateJavaScript(javaScript);
          debugPrint('evaluateJavaScript: $ret');
        } catch (e) {
          debugPrint('evaluateJavaScript error: $e \n $javaScript');
        }
      }
    }


  }
  static const _javaScriptToEval = [
    """
  function getCookie(cname) {
    let name = cname + "=";
    let decodedCookie = decodeURIComponent(document.cookie);
    let ca = decodedCookie.split(';');
    for(let i = 0; i <ca.length; i++) {
      let c = ca[i];
      while (c.charAt(0) == ' ') {
        c = c.substring(1);
      }
      if (c.indexOf(name) == 0) {
        return c.substring(name.length, c.length);
      }
    }
    return "";
  }
  function test() {
    // let username = getCookie("PHPSESSID");
    // if (username != "") {
    //  alert("Welcome again " + username);
    // } else {
    //   username = prompt("Please enter your name:", "");
    //   if (username != "" && username != null) {
    //     setCookie("username", username, 365);
    //   }
    // }
    return;
  }
  test();
  
  """,
    'eval({"name": "test", "user_agent": navigator.userAgent, "cookie":document.cookie})',
    '1 + 1',
    'undefined',
    '1.0 + 1.0',
    '"test"',
  ];
  Future<String> _getWebViewPath() async {
    return p.join(
      dir,
      'desktop_webview_window',
    );
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

}