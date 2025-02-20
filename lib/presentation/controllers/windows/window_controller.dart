

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../app/services/authen_service.dart';
import '../../../app/utils/constants/strings.dart';
import '../../../data/models/bookModel.dart';
import 'package:webview_windows/webview_windows.dart';

class WindowController extends GetxController{
  //TODO: Implement HomeController
  static WindowController get to       => Get.find();
  dynamic argumentData     = Get.arguments;
  final  _isLoading        = true.obs;
  final box                = GetStorage('info',dir);
  // var wController          = WebviewController();
  var wController          = Get.find<AuthenService>().wController;
  final textController     = TextEditingController();
  final navigatorKey       = GlobalKey<NavigatorState>();
  final auth               = Get.find<AuthenService>();
  var    bookShelf         = Bshelf().obs;
  bool     get isLoading        => _isLoading.value;
  set isLoading(value)          => _isLoading.value = value;
  late String  actionType    = '';
  late String  annotationId  = '';
  late int     currPage      = 0;
  Map<String,dynamic> book   ={};

  @override
  Future<void> onInit() async {
    super.onInit();
    wController.initialize();
  }
  Future<void> initPlatformState(Map<String,dynamic> book) async {
    book = book;
    try {
      if (kDebugMode) {
        print(book['url']);
        print(book['session']);
      }
      Future.delayed(const Duration(seconds: 1), () {
        wController.clearCookies();
        // wController.clearCache();
        wController.setUserAgent("flt");
        wController.executeScript('document.cookie = "PHPSESSID=${auth.session.value}"');
        wController.setBackgroundColor(Colors.transparent);
        wController.setPopupWindowPolicy(WebviewPopupWindowPolicy.allow);
        wController.addScriptToExecuteOnDocumentCreated('document.cookie = "PHPSESSID=${auth.session.value}"');
        wController.loadUrl(book['url']);
        // wController.executeScript('window.alert("document.cookie")');
        print(11111);

      });
      Future.delayed(const Duration(seconds: 1), () {
        wController.clearCookies();
        // wController.clearCache();
        wController.setUserAgent("flt");
        wController.executeScript('document.cookie = "PHPSESSID=${auth.session.value}"');
        wController.setBackgroundColor(Colors.transparent);
        wController.setPopupWindowPolicy(WebviewPopupWindowPolicy.allow);
        wController.addScriptToExecuteOnDocumentCreated('document.cookie = "PHPSESSID=${auth.session.value}"');
        wController.loadUrl(book['url']);
        // wController.executeScript('window.alert("document.cookie")');
        print(11111);

      });
    } on PlatformException {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initPlatformState(book);
      });
    }
  }
  @override
  Future<void> onReady() async {
    super.onReady();
  }

}