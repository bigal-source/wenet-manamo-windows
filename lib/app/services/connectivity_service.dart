import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manamo/presentation/controllers/home/home_controller.dart';
import '../router/router.dart';
import 'authen_service.dart';
import 'meta_data_service.dart';
import 'package:manamo/app/services/book_provider.dart';

class ConnectivityService extends GetxService {
  bool isShowingDialog      = false;
  final auth                = Get.find<AuthenService>();

  @override
  void onInit() async {
    super.onInit();
    // listen connect
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) { // disconnect
        auth.isConnected.value     = false;
        if (kDebugMode) {
          print("isConnected false");
        }
        router.goNamed('bookshelf');
      } else { //connecting
        auth.isConnected.value     = true;
        checkSyncMetaData();
        checkSyncSearchResult();
        if (kDebugMode) {
          print("isConnected true");
        }
        if(auth.isLogin.value == false){
          Get.put(HomeController());
          router.goNamed('home');
        }else{
         router.goNamed('bookshelf');
        }
      }
    });
  }
  void showDialogCorp() {
    Get.dialog(
      AlertDialog(
        title: const Text("接続エラー"),
        content: const Text("接続エラー　ネットワーク接続をご確認ください。\nダウンロード書籍のみご利用いただけます。"),
        actions: [
          TextButton(
            onPressed: ()  {
              isShowingDialog   = false;
              var currentRoute  =  Get.currentRoute ;
              if(currentRoute != '/book-view-off' && currentRoute != '/book-shelf' ){


              }
              Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
  Future<void> checkSyncMetaData() async {
    var resp = await MetaDataService().checkMetaData();
    if (kDebugMode) {
      print("check sync data = $resp");
    }
  }

  Future<void> checkSyncSearchResult() async {
    if (auth.box.hasData('listSearchResult')) {
      for (var data in auth.box.read('listSearchResult')) {
        await BookProvider().saveUserSearchResult(data);
        if (kDebugMode) {
          print('sync user search data: $data');
        }
      }
      auth.box.remove('listSearchResult');
    }
  }
}
