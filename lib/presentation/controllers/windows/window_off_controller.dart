import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:window_manager/window_manager.dart';
import '../../../app/services/authen_service.dart';
import '../../../app/services/book_provider.dart';
import '../../../app/utils/constants/strings.dart';
import '../../../data/datasources/local/db_help.dart';
import '../../../data/models/bookModel.dart';
import 'dart:async';
import 'package:webview_windows/webview_windows.dart';

class WindowOffController extends GetxController {
  //TODO: Implement HomeController
  static WindowOffController get to       => Get.find();
  final box                = GetStorage('info',dir);
  var wController          = WebviewController();
  final navigatorKey       = GlobalKey<NavigatorState>();
  final auth               = Get.find<AuthenService>();
  var    bookShelf         = Bshelf().obs;
  String buttonEvent = '';
  final List<StreamSubscription> subscriptions = [];

  Future<void> initPlatformState(Map<String,dynamic> book) async {
    try {
      bookShelf.value = book['book'] ;
      await wController.initialize().then((value) async => {
        await wController.clearCache(),
        await wController.setCacheDisabled(true),
        // await wController.setUserAgent('flt'),
        await wController.loadUrl(book['url']),
        subscriptions.add(wController.url.listen((url) {
          updateLastPage(url);
        }),),
        subscriptions.add(wController.containsFullScreenElementChanged.listen((flag) {
          windowManager.setFullScreen(flag);
        }),),
        subscriptions.add(wController.webMessage.listen((event) async {
          String localServerUserAgent = '';
          if(event["key"] =="listdata"){
            saveDataInSqlite(event);
          }
          if(event.containsKey('lastPage')){
            setLastPage(event['lastPage']);
          }
          if(event["key"] == "siori"){
            saveSioriDataInSqlite(event);
          }
          if(event.toString().contains('button-event')) {
            buttonEvent = event["button-event"];
          }
          if (event["key"] == "SendAnaliticsData") {
            String url = event["value"];
            String keyWordBookID = "manamoAppFlutter";
            String keyWordUserID = 'appFlutterUserID';
            if (url.contains(keyWordBookID)) {
              url = url.replaceAll(keyWordBookID, bookShelf.value.bookAppId!);
            }
            if (url.contains(keyWordUserID)) {
              url = url.replaceAll(keyWordUserID, auth.userId.value);
            }
            saveUserSearchData(url);
          }
          if (event["key"] == 'localServerUserAgent') {
            localServerUserAgent = event["value"];
            if (!box.hasData('localServerUserAgent')) {
              box.write('localServerUserAgent', localServerUserAgent);
            }
          }
          if (event["key"] == 'flutterSyncAt') {
            saveSyncTimeToLocalDB(event['data']);
          }
          if (auth.isConnected.value) {
            if (event["key"] == 'flutterAddSyncIcon') {
              showSyncIcon();
            }
            if (event["key"] == 'flutterRemoveSyncIcon') {
              hideSyncIcon();
            }
          }
        })),
        await wController.executeScript('window.chrome.webview.postMessage({key: "localServerUserAgent", value: navigator.userAgent});'),
        ever(auth.syncing, (callback) {
          if (callback) {
            showSyncIcon();
          } else {
            hideSyncIcon();
          }
        }),
        ever(auth.isConnected, (callback) {
          if (callback) {
            showSyncButton();
          } else {
            hideSyncButton();
          }
        }),
      });

    } on PlatformException {
      rethrow;
    }
  }

  Future<void> addButtonEvent() async {
    await Future.delayed(const Duration(seconds: 3));
    if (! auth.isConnected.value) {
      hideSyncButton();
    }
    changeSyncTime();
    await wController.executeScript("document.getElementById('btn-help').onclick = function () {console.log('open-help-page'); window.chrome.webview.postMessage({'button-event': 'open-help-page'});}");
    await wController.executeScript("document.getElementsByClassName('view-popup-help')[0].getElementsByClassName('right')[0].getElementsByClassName('icon-view-view_close')[0].onclick = function () {console.log('close-help-page'); window.chrome.webview.postMessage({'button-event': 'close-help-page'})}");
  }

  Future<void> scrollWebView(double mouseX, double mouseY, double dx, double dy) async {
    if (buttonEvent.isNotEmpty && buttonEvent == 'open-help-page') {
      wController.executeScript("""
            function eleCanScroll(ele) {
              if (ele.scrollTop > 0) { return ele; }
              else {
                ele.scrollTop++;
                const top = ele.scrollTop;
                top && (ele.scrollTop = 0);
                if(top > 0){
                  return ele;
                } else {
                  return eleCanScroll( ele.parentElement);
                }
              }
            }
            var el = document.elementFromPoint($mouseX,$mouseY);
            var el2 = eleCanScroll(el);
            el2.scrollBy($dx, $dy);
            """);
    }
  }

  Future<void> saveDataInSqlite(data) async {
    if (kDebugMode) {
      printInfo(info: 'page = ${data['page']}');
    }
    var row = Bviewer(bookAppId:  bookShelf.value.bookAppId!,updateDate: auth.isConnected.isTrue ? 0: 1,page: int.tryParse(data["page"].toString()),module: "listdata",dataObj: jsonEncode(data["data"]));
    SQLHelper.drawData(row);

  }
  Future<void> saveSioriDataInSqlite(data) async {
    var row = Bviewer(bookAppId: bookShelf.value.bookAppId!,updateDate: auth.isConnected.isTrue ? 0: 1,page: 0,module: "siori",dataObj: data['data']);
    SQLHelper.drawSioriData(row);

  }
  Future<int>  updateLastPage(stringUrl) async {
    final page = stringUrl.split('#');
    bookShelf.value.lastPage     = page.length > 1 ? int.tryParse(page[1]) : 1; // done
    final result =  await SQLHelper.updateBookShelf(bookShelf.value);
    return result > 0 ? 1 : 0;
  }
  Future<int>  setLastPage(page) async {
    bookShelf.value.lastPage     = page; // done
    final result =  await SQLHelper.updateBookShelf(bookShelf.value);
    if (kDebugMode) {
      print("setLastPage ${bookShelf.value.lastPage}");
    }
    return result > 0 ? 1 : 0;
  }
  Future<void> saveUserSearchData(String value) async {
    if (auth.isConnected.value) {
      BookProvider bookProvider = BookProvider();
      await bookProvider.saveUserSearchResult(value);
    } else {
      List<String> listSearchResult = [];
      if (box.hasData('listSearchResult')) {
        listSearchResult = box.read('listSearchResult');
        listSearchResult.add(value);
        box.write('listSearchResult', listSearchResult);
      } else {
        listSearchResult.add(value);
        box.write('listSearchResult', listSearchResult);
      }
    }
  }

  void showSyncIcon() {
    wController.executeScript('h5appview.showBtnSyncing();');
  }
  void hideSyncIcon() {
    wController.executeScript('h5appview.hideBtnSyncing();');
  }
  void showSyncButton() {
    wController.executeScript('\$("#btn-sync-page").fadeIn("slow");');
  }
  void hideSyncButton() {
    wController.executeScript('\$("#btn-sync-page").fadeOut("slow");');
  }
  Future<void> saveSyncTimeToLocalDB(String data) async {
    await SQLHelper.saveLastSyncTime(bookShelf.value.bookAppId!, auth.userId.value, auth.idx.value, data);
    changeSyncTime();
  }
  void changeSyncTime() async {
    var time = await SQLHelper.getLastSyncTime(bookShelf.value.bookAppId!, auth.idx.value);
    String text = '';
    if (time.synchro_at != null) {
      text = time.synchro_at!;
    }
    wController.executeScript("document.getElementsByClassName('syncro_at')[0].innerHTML = '$text';");
  }

}