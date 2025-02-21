import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt ;
import 'package:go_router/go_router.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:flutter/foundation.dart';
import '../../data/datasources/local/db_help.dart';
import '../../data/models/bookModel.dart';
import '../utils/constants/strings.dart';
import '../utils/server.dart';
import '../utils/setting.dart';
class AuthenService extends GetxController {
  var wController   = WebviewController();
  var box           = GetStorage('info',dir);
  var title         = "HOME".obs; //ログイン
  var isConnected   = true.obs;
  var idx           = "".obs;
  var userId        = "".obs;
  var email         = "".obs;
  var pass          = "".obs;
  var session       = "".obs;
  var token         = "".obs;
  var corpId        = "".obs;
  var headerX       = "".obs;
  var isLogin       = true.obs;
  var timeLog       = "".obs;
  var device        = "phone".obs;
  var theme         = 'system'.obs;
  var process       = 0.0.obs;
  //todo:
  var updateCode    = 0.obs;
  var    bookOpen   = Bshelf().obs;
  var checkChangeMail = 0.obs;

  final keyHash  = encrypt.Key.fromLength(32);
  final  ivHash  = encrypt.IV.fromLength(8);
  final syncing = false.obs;



  @override
  Future<void> onInit() async {
    super.onInit();
    // var timeLogin = box.read('loginTime') ?? DateTime.now().millisecondsSinceEpoch;
    // if (DateTime.now().millisecondsSinceEpoch - timeLogin >= sessionTimes) {
    //   var idx = box.read('idx');
    //   box.erase();
    //   box.write('idx', idx);
    // }

    isLogin.value         = box.read('is_login')   ??    true; // direct login
    theme.value           = box.read('theme')      ??    'system';
    timeLog.value         = box.read('time_log')   ??  DateTime.now().toString();
    corpId.value          = box.read('corpname').toString().toLowerCase() != 'null'?  box.read('corpname'): corpname;
    idx.value             = box.read('idx')        ?? 'null';
    userId.value          = box.read('userId')     ?? 'null';
    email.value           = box.read('email')      ?? 'null';
    session.value         = box.read('session')    ?? 'null';
    updateCode.value      = box.read('updateCode') ?? 0;
    headerX.value         = box.read('header').toString() != "null" ? box.read('header') : m10507;
    checkChangeMail.value = box.read('change_mail_flag') ?? 0;
    token.value           = box.read('token') ?? 'null';
    header                = headerX.value;
    corpname              = corpId.value;
    // wController.initialize();
    var isCheck = box.read('security');
    if (kDebugMode) {
      print("AuthenService");
      print("corpId         ${corpId.value}");
      print("userId         ${userId.value}");
      print("idx            ${idx.value}");
      print("email          ${email.value}");
      print("session        ${session.value}");
      print("isLogin        ${ isLogin.value}");
      print("path           ${Directory.current.absolute.path}");
      print("path2           ${Directory.current.absolute.path.replaceAll('\\', '.').toLowerCase()}");
      print("sec = ${box.read('security')}");
    }
    String plainText = Directory.current.absolute.path.replaceAll('\\', '').toLowerCase();

    if(isCheck == null){
      // await encodePass(plainText);
      box.write('security',plainText);
    }else{
      var currPath = Directory.current.absolute.path.replaceAll('\\', '').toLowerCase();
      // decodePass(isCheck);
      if(currPath != isCheck){
        if (kDebugMode) {
          print("$currPath != $isCheck");
        }
        // exit(0);
      }else{
        if (kDebugMode) {
          print("$currPath == $isCheck");
        }

      }
    }

  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  Future<AuthenService> init() async {
    // isSignIn.value        = box.read('isSignIn')   ??    true;
    // isLogin.value         = box.read('is_login')   ??    true; // direct login
    // theme.value           = box.read('theme')      ??    'system';
    // timeLog.value         = box.read('time_log')   ??  DateTime.now().toString();
    // corpId.value          = corpname;
    // idx.value             = box.read('idx')        ?? 'null';
    // email.value           = box.read('email')      ?? 'null';
    // session.value         = box.read('PHPSESSID')  ?? 'null';
    //
    // if (kDebugMode) {
    //   print("AuthenService");
    //   print("corpId         ${corpId.value}");
    //   print("idx            ${idx.value}");
    //   print("email          ${email.value}");
    //   print("session        ${session.value}");
    //   print("isLogin        ${ isLogin.value}");
    // }
    return this;
  }
  // Future<AuthenService> logout() async {
  //   box.remove('is_login');
  //   box.remove('time_log');
  //   box.remove('user_id');
  //   box.remove('user_pass');
  //   isLogin.value = true;
  //   title.value   = 'ログイン';
  //   Get.offAndToNamed('/login');
  //   return this;
  // }
  Future<int>  updateLastPage(stringUrl) async {
    final page = stringUrl.split('#');
    bookOpen.value.lastPage     = page.length > 1 ? int.tryParse(page[1]) : 1; // done
    final result =  await SQLHelper.updateBookShelf(bookOpen.value);
    if (kDebugMode) {
      print("Book ${bookOpen.value.bookAppId}");
      print("lastPage ${bookOpen.value.lastPage}");
    }
    return result > 0 ? 1 : 0;
  }
  Future<void> saveLocalStorage(wController) async {
    var store = await wController?.evaluateJavascript(source:"window.localStorage.getItem('jStorage')");
    box.remove('jStorage').then((value) => {
      box.write('jStorage',store),
    });
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
  Future<String> encodePass(String path) async {
    final en        = encrypt.Encrypter(encrypt.Salsa20(keyHash));
    final encrypted = en.encrypt(path, iv: ivHash);
    box.write('security',encrypted.base64);
    print('encodePass = ${encrypted.base64}');
    return encrypted.base64;
  }
  String decodePass(String decode) {
    final de        = encrypt.Encrypter(encrypt.Salsa20(keyHash));
    final decrypted = de.decrypt(encrypt.Encrypted.fromBase64(decode), iv: ivHash);
    print('decode     = ${decode}');
    print('decodePass = ${decrypted}');
    return decrypted;
  }
  Map<String, dynamic> getHeader() {
    return corpId.value == "manamo" ? {'X-Wisebook-Authorization': manamoHead} : {'X-Wisebook-Authorization': headercode};
  }

}
