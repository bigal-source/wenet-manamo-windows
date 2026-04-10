
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:go_router/go_router.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:manamo/data/models/bookModel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/services/authen_service.dart';
import '../../../app/services/book_provider.dart';
import '../../../app/services/local_storage.dart';
import '../../../app/services/search_service.dart';
import '../../../app/utils/constants/strings.dart';
import '../../../app/utils/server.dart';
import '../../../data/datasources/local/db_help.dart';
import '../../../data/models/search_view_model.dart';
import '../../pages/reading/reading_view.dart';
import 'package:window_size/window_size.dart' as winSize;
import 'package:window_manager/window_manager.dart';

class SearchBookController extends GetxController with GetSingleTickerProviderStateMixin{
  //TODO: Implement HomeController
  final auth               = Get.find<AuthenService>();
  final store              = Get.find<LocalStorageService>();
  dynamic argumentData     = Get.arguments;
  final  _isLoading        = false.obs;
  final  _hasKeyWord       = false.obs;
  final  _type             = ''.obs;
  final  _process          = 0.0.obs;
  final box                = GetStorage('info',dir);
  final  _bookSearch       = BookSearchModel().obs;
  var    bookShelf         = Bshelf().obs;
  var    urlBook           = '';
  var    pageSearch        = 0;

  final  listNotice        = [].obs;
  final TextEditingController searchText = TextEditingController();

  static SearchBookController get to => Get.find();
  bool            get isLoading        => _isLoading.value;
  bool            get hasKeyWork       => _hasKeyWord.value;
  BookSearchModel get bookSearch       => _bookSearch.value;
  double          get process          => _process.value;
  String          get type             => _type.value;


  set isLoading(value)           => _isLoading.value = value;
  set process(value)             => _process.value   = value;
  set type(value)                => _type.value      = value;
  set hasKeyWork(value)          => _hasKeyWord.value= value;
  set bookSearch(value)          => _bookSearch.value= value;

  late String  actionType    = '';
  late String  annotationId  = '';
  late int     currPage      = 0;
  late String  keyword       = '';
  Map<String, String> searchTypes = {
    '全文検索': 'solr',
    'タイトル検索': 'normal',
  };
  bool isFull = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    searchText.text  = '';
    _type.value      = 'solr';
    if (kDebugMode) {
    }
  }
  Future<void> searchBooks(String keyWord, String searchType) async {
    if (await auth.checkAllowThisDeviceLogin()) {
      keyword = keyWord;
      _isLoading.value = true;
      try{
        _bookSearch.value  = await SearchService().searchBook(auth.userId.value,keyWord,searchType);
        update();
        if (kDebugMode) {
        }
      }catch(ex){
        if (kDebugMode) {
        }
      }
      _isLoading.value = false;
    } else {
      return;
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
  void openBook(BuildContext context, String bookId, int page, String url, String title) async {
    if(Platform.isMacOS){
      final ReadingPage browser = ReadingPage();
      await browser.openUrlRequest(urlRequest:URLRequest(url: WebUri(url)),
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
            useShouldOverrideUrlLoading: true,
            useOnLoadResource: true,
          ),
        ),
      );

    } else{
      // Windows
      // https://manamo.bigal.work/html/m101507/1151/?htp=1#9
      // https://manamo.bigal.work/html/m101507/1151/
      urlBook         = type != 'solr'
                  ? '${host}html/$corpname/$bookId/#1'
                  : '${host}html/$corpname/$bookId/?htp=$keyword#$page';
      printInfo(info: "windows");
      final webview = await WebviewWindow.create(
        configuration: CreateConfiguration(
          title: title,
          userDataFolderWindows: await _getWebViewPath(),
          titleBarHeight:20,
          titleBarTopPadding: Platform.isMacOS ? 20 : 0,
        ),
      );
      Future<void> injectCookies(Webview webview) async {
        final session = box.read('session');
        final token   = box.read('token');
        webview.addScriptToExecuteOnDocumentCreated('document.cookie = "_cookie_appuser_info_=; expires=Thu, 01 Jan 1970 00:00:00 UTC;"');
        webview.addScriptToExecuteOnDocumentCreated('document.cookie = "PHPSESSID=; expires=Thu, 01 Jan 1970 00:00:00 UTC;"');
        webview.addScriptToExecuteOnDocumentCreated('document.cookie = "_cookie_appuser_info_=$token; path=/;"');
        webview.addScriptToExecuteOnDocumentCreated('document.cookie = "PHPSESSID=$session; path=/;"');
        webview.addScriptToExecuteOnDocumentCreated('document.cookie = "fltostp=W; path=/;"');
      }
      await WebviewWindow.isWebviewAvailable().then((value) async {
        printInfo(info: value.toString());
        webview.addScriptToExecuteOnDocumentCreated("""
          document.cookie = 'PHPSESSID=${box.read('session')}'
        """);
      });
      injectCookies(webview);
      webview
        // ..addScriptToExecuteOnDocumentCreated("""
        //
        //  function createCookie(name,value,days) {
        //         if (days) {
        //             var date = new Date();
        //             date.setTime(date.getTime() + (days * 24 * 60 * 60 *1000));
        //             var expires = "; expires=" + date.toGMTString();
        //         } else {
        //             var expires = "";
        //         }
        //         document.cookie = name + "=" + value + expires + "; path=/";
        //     }
        //
        //     function readCookie(name) {
        //         var nameEQ = name + "=";
        //         var ca = document.cookie.split(';');
        //         for(var i=0;i < ca.length;i++) {
        //             var c = ca[i];
        //             while (c.charAt(0)==' ') {
        //                 c = c.substring(1,c.length);
        //             }
        //             if (c.indexOf(nameEQ) == 0) {
        //                 return c.substring(nameEQ.length,c.length);
        //             }
        //         }
        //         return null;
        //     }
        //
        //     function eraseCookie(name) {
        //         createCookie(name,"${box.read('session')}",1);
        //     }
        //   eraseCookie('PHPSESSID');
        //   document.cookie = 'PHPSESSID=${box.read('session')}'
        //   const mixinContext = {
        //     platform: 'Desktop',
        //     conversation_id: 'conversationId',
        //     immersive: false,
        //     app_version: '1.0.0',
        //     appearance: 'dark',
        //   }
        //   window.MixinContext = {
        //     getContext: function() {
        //       return JSON.stringify(mixinContext)
        //     }
        //   }
        // """)
        ..setBrightness(Brightness.dark)
        ..setApplicationNameForUserAgent("flt WinAPP")
        ..launch(urlBook)
        ..setOnUrlRequestCallback((url) {
        //   debugPrint('url: $url');
        //   webview.addScriptToExecuteOnDocumentCreated("""
        //       document.cookie = 'PHPSESSID=${box.read('session')}'
        // """);
        //   final uri = Uri.parse(url);
        //   if (uri.path == '/login_success') {
        //     debugPrint('login success. token: ${uri.queryParameters['token']}');
        //     webview.close();
        //   }
          return true;
        })
        // ..evaluateJavaScript("""  document.cookie = 'PHPSESSID=${box.read('session')}'  """)
        ..setOnHistoryChangedCallback((canGoBack, canGoForward) async {
          if (canGoBack) {
            var currentURL = await webview.evaluateJavaScript('window.location.href');
            if (currentURL != null) {
              currentURL = currentURL.replaceAll('"', '');
              if (currentURL.toString().contains('${host}apps/appuser_login/${auth.corpId.value}')) {
                webview.close();
                await auth.checkAllowThisDeviceLogin();
                return;
              }
              if (! currentURL.contains(host)) {
                await webview.evaluateJavaScript('history.back();');
                launchUrl(Uri.parse(currentURL), mode: LaunchMode.inAppWebView);
              }
            }
          }
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
        ..onClose.whenComplete(() {
          debugPrint("on close");
        });
      await Future.delayed(const Duration(milliseconds: 50));
      await webview.evaluateJavaScript("location.reload(true);");
      await Future.delayed(const Duration(milliseconds: 50));
      await webview.evaluateJavaScript("location.reload();");
      // await Future.delayed(const Duration(seconds: 2));
      // for (final javaScript in _javaScriptToEval) {
      //   try {
      //     final ret = await webview.evaluateJavaScript(javaScript);
      //     debugPrint('evaluateJavaScript: $ret');
      //   } catch (e) {
      //     debugPrint('evaluateJavaScript error: $e \n $javaScript');
      //   }
      // }
      // SQLHelper.getBookInfo(bookId).then((value) => {
      //   if(value.id != null){
      //     printInfo(info:" www 2 $type" ),
      //     bookShelf.value = value,
      //     urlBook         = type != 'solr'
      //         ? 'http://127.0.0.1:8088/?bookId=${bookShelf.value.bookAppId}&id=${auth.idx}#1'
      //         : 'http://127.0.0.1:8088/?bookId=${bookShelf.value.bookAppId}&id=${auth.idx}&htp=$keyword#$page',
      //     printInfo(info: urlBook),
      //     openWindows(context, bookShelf.value,urlBook),
      //   }else{
      //     downloadFile(context, bookId),
      //   }
      // });
    }
  }
  // void openBook(BuildContext context, String bookId, int page, String url) async {
  //   if(Platform.isMacOS){
  //     final ReadingPage browser = ReadingPage();
  //     await browser.openUrlRequest(urlRequest:URLRequest(url: WebUri(url)),
  //       settings: InAppBrowserClassSettings(
  //         browserSettings: InAppBrowserSettings(
  //           // hideUrlBar: true,
  //           // hideTitleBar: true,
  //           // hideProgressBar: true,
  //           // hideToolbarBottom: true,
  //           // hideDefaultMenuItems: true,
  //           hideToolbarTop: true,
  //           toolbarTopBackgroundColor: Colors.transparent,
  //           presentationStyle: ModalPresentationStyle.FULL_SCREEN,
  //           allowGoBackWithBackButton: false,
  //
  //         ),
  //         webViewSettings: InAppWebViewSettings(
  //           isInspectable: kDebugMode,
  //           useShouldOverrideUrlLoading: true,
  //           useOnLoadResource: true,
  //         ),
  //       ),
  //     );
  //
  //   } else{
  //     // Windows
  //     SQLHelper.getBookInfo(bookId).then((value) => {
  //       if(value.id != null){
  //         printInfo(info:" www 2 $type" ),
  //         bookShelf.value = value,
  //         urlBook         = type != 'solr'
  //             ? 'http://127.0.0.1:8088/?bookId=${bookShelf.value.bookAppId}&id=${auth.idx}#1'
  //             : 'http://127.0.0.1:8088/?bookId=${bookShelf.value.bookAppId}&id=${auth.idx}&htp=$keyword#$page',
  //         printInfo(info: urlBook),
  //         openWindows(context, bookShelf.value,urlBook),
  //       }else{
  //         downloadFile(context, bookId),
  //       }
  //     });
  //   }
  // }
  void openWindows(BuildContext context, Bshelf book, String url ){
    context.push('/windows-off', extra: {'url': url, 'session' : auth.session.value, 'book' : book});
  }
  Future<bool> downloadFile(BuildContext context, id) async {
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
            printInfo(info :"Unzip done");
            saveBookShelfPath(context, directoryPath, id);
            return true;
          }

        } catch (e) {
          if (kDebugMode) {
          }
          return false;
        }
      }).onError((error, stackTrace){
        return null;
      });
    } catch (e) {
      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
    return false;
  }
  Future<bool> saveBookShelfPath(BuildContext context, directoryPath, String bookId) async {
      var bookInfo         =  await BookProvider().bookInfo(corpname,bookId);
      var directoryPath    = '$dir/web/$bookId';
      Bshelf bookSave      = Bshelf(
        bookAppId   : bookInfo.bookAppId,
        bookPath    : "${bookInfo.author!}/${bookInfo.bookAppId!}",
        title       : bookInfo.title,
        thumbPath   : "$directoryPath/thumb.jpg",
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
        status        : "1000",
        sortNo        : 0,
        isDownload    : 1,
        pdfId         : 0,
        cateId        : 1,
        lastPage      : 1,
      );
      await SQLHelper.saveBookShelf(bookSave).then((value) => {
            printInfo(info:" 1 $type" ),
            bookShelf.value = value,
            urlBook         = type != 'solr'
            ? 'http://127.0.0.1:8088/?bookId=${bookShelf.value.bookAppId}&id=${auth.idx}#1'
            : 'http://127.0.0.1:8088/?bookId=${bookShelf.value.bookAppId}&id=${auth.idx}&htp=$keyword#$pageSearch',
            openWindows(context, bookShelf.value,urlBook ),
      });
      return true;
  }
  @override
  Future<void> onReady() async {
    super.onReady();
  }
}