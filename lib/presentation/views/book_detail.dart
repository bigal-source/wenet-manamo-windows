import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_storage/get_storage.dart';
import '../../app/config/wise_book_icon_icons.dart';
import '../../app/utils/constants/strings.dart';
import '../../app/utils/date_utils.dart';
import '../../app/utils/server.dart';
import '../../data/models/book_info.dart';
import '../pages/reading/reading_view.dart';
import 'package:path/path.dart' as p;

class BookDetailView extends StatelessWidget {
  Book bookItem;
  BookDetailView({Key? key, required this.bookItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    double scale          = 1.0;
    return ScaffoldPage.scrollable(
      header:  PageHeader( title: FittedBox( fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(bookItem.title!),),),
      children: [
        SingleChildScrollView(
          child: tablet(context),
        )
      ],
    );
  }
  Widget tablet(BuildContext context){
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    Typography typography = FluentTheme.of(context).typography;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: w,
            height: h/2,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            padding: const EdgeInsets.only(top: 30, bottom: 30),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Get.isDarkMode? Colors.grey[50]: Colors.grey[80], width: 0.1),
                bottom: BorderSide(color: Get.isDarkMode? Colors.grey[50]: Colors.grey[80], width: 0.1),
              ),
            ),
            child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.topLeft,child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //todo: book cover
                Container(
                    padding: const EdgeInsets.all(10),
                    height: isPortrait ? w/2.2 : h/2.8,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[40]),
                    ),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: bookItem.image!,
                          errorWidget: (context, url, error) => const Icon(FluentIcons.error),
                        ),
                      ],
                    )
                ),
                //todo: space
                const SizedBox(width: 20,),
                //todo: info book + button
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    rowInfo(context,"カテゴリ",bookItem.categoryName!,1.0),
                    rowInfo(context,"公開日",DateUtil.convertSqlDate(DateTime.parse(bookItem.date!)),1.0),
                    rowInfo(context,"ページ数",bookItem.pages!,1.0),
                    rowInfo(context,"サイズ","${bookItem.fileSize!} KB",1.0),
                    rowInfo(context,"配信方法",bookItem.distType!,1.0),
                    //todo: button view book

                    btnViewBook(context, bookItem),
                  ],
                ),
              ],
            ),),
          ),
          //todo: update
          SizedBox(
            // width: w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('詳細',style: typography.title?.apply(fontSizeFactor: 1),
                ),
                SizedBox(
                  height: w / 19,
                ),
                SizedBox(
                  height: w / 19,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget rowInfo(BuildContext context, String label, String txtValue, double scale){
    Typography typography = FluentTheme.of(context).typography;
    double scale          = 1.0;
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:  [
        Container(
          width: 80,
          padding: const EdgeInsets.all(4.0),
          child: Text(label, style: typography.bodyLarge?.apply(fontSizeFactor: scale)),
        ),
        const SizedBox(width: 30,),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(txtValue, overflow: TextOverflow.ellipsis, style: typography.bodyLarge?.apply(fontSizeFactor: scale)),
        ),
      ],
    );
  }
  Widget btnViewBook(BuildContext context, Book book){
    Typography typography = FluentTheme.of(context).typography;
    double scale          = 1.0;
    return Container(
      width: 220,
      height: 40,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ) ,
      child: OutlinedButton(
        style: ButtonStyle(
          textStyle: ButtonState.all(TextStyle(color: Colors.green)),
          shape: ButtonState.all(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              )
          ),
        ),
        onPressed: () async {
          // controller.gotoBookView(controller.book.bookId!);
          openBook(bookItem.bookId!, 1);

        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
                flex: 1,
                child: Icon(
                  WiseBookIcon.uniF119,
                  color: Get.isDarkMode? Colors.white: Colors.green,
                  size: 20.0,
                )
            ),
            Flexible(
                flex: 1,
                child: Text('読', style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w500))
            ),
            Flexible(
                flex: 1,
                child: Text('む',style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w500))
            ),
          ],
        ),
      ),
    );
  }
  void openBook(String bookId, int page) async{
    final CookieManager cookieManager = CookieManager.instance();
    var box           = GetStorage('info',dir);
    if(Platform.isMacOS){

      final ReadingPage browser = ReadingPage();
      await browser.openUrlRequest(
        // urlRequest:URLRequest(url: WebUri("https://catalogpod.wisebook.jp/html/denkawebbook/50761/#2")),
        urlRequest:URLRequest(url: WebUri("${host}html/$corpname/$bookId/#$page")),
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

    }else{
      printInfo(info: "windows");
      final webview = await WebviewWindow.create(
        configuration: CreateConfiguration(
          userDataFolderWindows: await _getWebViewPath(),
          titleBarTopPadding: Platform.isMacOS ? 20 : 0,
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
        ..setApplicationNameForUserAgent(" WebviewExample/1.0.0")
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
}
const _javaScriptToEval = [
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
  return p.join(dir,'desktop_webview_window',);
}
