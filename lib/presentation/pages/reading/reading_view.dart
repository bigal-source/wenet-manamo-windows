import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../app/services/authen_service.dart';
import '../../../app/utils/constants/strings.dart';
import '/presentation/controllers/book_detail/book_detail_controller.dart';
import '../../../app/utils/server.dart';


class ReadingPage extends InAppBrowser {

  ReadingPage({int? windowId, UnmodifiableListView<UserScript>? initialUserScripts}) : super(windowId: windowId, initialUserScripts: initialUserScripts);
  final CookieManager cookieManager = CookieManager.instance();
  var controller    = Get.find<BookDetailController>();
  final auth        = Get.find<AuthenService>();
  var box           = GetStorage('info',dir);
  @override
  Future onBrowserCreated() async {
    controller.syncLocalStorage(webViewController);
    if (kDebugMode) {
      print("\n\nBrowser Created!\n\n");
    }
    await cookieManager.setCookie(
      url: WebUri(host),
      name: "PHPSESSID",
      value: auth.session.value,
      isSecure: true,
    );

  }

  @override
  Future onLoadStart(url) async {
    controller.syncLocalStorage(webViewController);
    await webViewController?.evaluateJavascript(source: """
             window.addEventListener("message", (event) => {
                console.log(event.data);
              }, false);
    """);
    if (kDebugMode) {
      print("\n\nBrowser Start!\n\n");
      print(url.toString());
    }

  }

  @override
  Future onLoadStop(url) async {
    controller.syncLocalStorage(webViewController);
    await webViewController?.evaluateJavascript(source: """
             window.addEventListener("message", (event) => {
                console.log(event.data);
              }, false);
    """);
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("\n\nBrowser Stop!\n\n");
      print(url.toString());
    }
  }

  @override
  Future<PermissionResponse> onPermissionRequest(permissionRequest) async {
    return PermissionResponse(resources: permissionRequest.resources, action: PermissionResponseAction.GRANT);
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
  }

  @override
  void onConsoleMessage(consoleMessage) {

    if(consoleMessage.message =='storage'){
      printInfo(info: "save data");
      controller.saveLocalStorage(webViewController);
    }
    if (kDebugMode) {
      print(consoleMessage.message);
    }
  }

  @override
  void onWindowBlur() {
    controller.saveLocalStorage(webViewController);
    if (kDebugMode) {
    }
  }

  @override
  void onProgressChanged(progress) async{
    controller.syncLocalStorage(webViewController);
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
  }

  @override
  Future<bool> onExit() async {
    if (kDebugMode) {
      print("\n\nBrowser closed!\n\n");
    }
    return true;
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
    controller.updateLastPage('${navigationAction.request.url}');
    if (kDebugMode) {
      print("\n\n Override ${navigationAction.request.url} \n\n");
    }
    return NavigationActionPolicy.ALLOW;
  }
}
