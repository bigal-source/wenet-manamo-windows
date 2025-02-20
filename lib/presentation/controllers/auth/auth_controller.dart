import 'dart:convert';
import 'dart:io';
import 'package:desktop_webview_auth/desktop_webview_auth.dart';
import 'package:desktop_webview_auth/google.dart';
import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:manamo/app/services/change_pass_service.dart';
import 'package:manamo/app/utils/constants/strings.dart';
import 'package:manamo/presentation/views/dash_board.dart';
import 'package:manamo/presentation/views/home.dart';
import 'package:manamo/app/utils/server.dart';
import 'package:manamo/app/utils/setting.dart';
import '../../../app/config/secret_key.dart';
import '../../../app/router/router.dart';
import '../../../app/services/authen_service.dart';
import '../../../app/services/userService.dart';
import '../../../data/models/user_models.dart';

typedef SignInCallback = Future<void> Function();
class AuthController extends GetxController {
  final auth  = Get.find<AuthenService>();
  var isLoggedIn = false.obs;
  final TextEditingController txtUserName = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  bool showHidePass = true;
  bool buttonEnable = false;
  var box                    = GetStorage('info',dir);
  var showError              = false.obs;
  var showLoginGoogleError   = false.obs;
  final errorTxt             = "".obs;
  String gmail               ="";

  Future<AuthResult?> signInGoogle() async {
    var ggOption = GoogleSignInArgs(
      clientId: googleClientId,
      redirectUri: redirectUrl,
      scope: 'https://www.googleapis.com/auth/userinfo.email',
    );
    final result = await DesktopWebviewAuth.signIn(ggOption);

    // if(Platform.isMacOS){
    //   final authFire      = FirebaseAuth.instance;
    //   final credential    = GoogleAuthProvider.credential(
    //     idToken: result?.idToken,
    //     accessToken: result?.accessToken,
    //   );
    //   // credential with Firebase
    //   var credentialResp  = await authFire.signInWithCredential(credential);
    //   gmail               = credentialResp.user!.email.toString();
    // }
    if(Platform.isWindows){
      var resp = await Dio().get('https://www.googleapis.com/oauth2/v3/userinfo?access_token=${result?.accessToken}');
      gmail    = resp.data['email'];
      printInfo(info:resp.data['email']);
    }



    if (result?.idToken != null && result?.accessToken != null) {


      LoginModel userInfo = await UserService().checkEmail(gmail);

      if (userInfo.result == 'true') {
        await _registerDevice(gmail);
        String credentials2 = jsonEncode(userInfo);
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        String token   = stringToBase64.encode(credentials2);

        //todo: log time
        auth.isLogin.value        = false;
        auth.title.value          = 'HOME';
        auth.session.value        = userInfo.sessionId!;
        auth.idx.value            = userInfo.idX!;
        auth.userId.value         = userInfo.userId!;
        auth.corpId.value         = userInfo.corpName!;
        auth.headerX.value        = userInfo.corpName! == 'manamo' ? manamo  : m10507;
        header                    = auth.headerX.value;
        corpname                  = auth.corpId.value;
        auth.token.value          = token;
        auth.email.value          = gmail;
        auth.pass.value           = "";

        box.write('idx'         , auth.idx.value);
        box.write('userId'      , auth.userId.value);
        box.write('session'     , auth.session.value);
        box.write('is_login'    , auth.isLogin.value);
        box.write('email'       , auth.email.value);
        box.write('corpname'    , auth.corpId.value);
        box.write('header'      , auth.headerX.value);
        box.write('token'       , auth.token.value);
        await ChangeMailServices().checkChangeEmail(auth.idx.value, auth.corpId.value).then((value) {
          auth.checkChangeMail.value = value.mailChangeFlg!;
          box.write('change_mail_flag', auth.checkChangeMail.value);
        });
        box.write('loginTime', DateTime.now().millisecondsSinceEpoch);
        router.goNamed('home');

        if (kDebugMode) {
        }


      } else {
        if (kDebugMode) {
        }
        showLoginGoogleError.value = true;
        errorTxt.value = userInfo.errorMessage!;
      }
    }
    return null;

  }
  @override
  Future<void> signInPassword() async {
    try {
      if(txtPassword.text != "" && txtUserName.text != ""){
        LoginModel userInfo = await UserService().loginDB(txtUserName.text,txtPassword.text);
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        String encoded = stringToBase64.encode(jsonEncode(userInfo.toJson()));
        if (kDebugMode) {
          print("signInPassword");
          print(userInfo.toJson());
          print(userInfo.result);
        }
        if (userInfo.result == 'true') {
          //todo: log time
          auth.isLogin.value        = false;
          auth.title.value          = "HOME";
          auth.session.value        = userInfo.sessionId!;
          auth.idx.value            = userInfo.idX!;
          auth.userId.value         = userInfo.userId!;
          auth.email.value          = txtUserName.text;
          auth.pass.value           = txtPassword.text;
          auth.corpId.value         = userInfo.corpName!;
          auth.headerX.value        = userInfo.corpName! == 'manamo' ? manamo  : m10507;
          auth.token.value          = encoded;
          header                    = auth.headerX.value;
          corpname                  = auth.corpId.value;
          box.write('idx'         , auth.idx.value);
          box.write('userId'      , auth.userId.value);
          box.write('session'     , auth.session.value);
          box.write('is_login'    , auth.isLogin.value);
          box.write('email'       , auth.email.value);
          box.write('corpname'    , auth.corpId.value);
          box.write('header'      , auth.headerX.value);
          box.write('token'       , auth.token.value);
          //todo: home user
          await ChangeMailServices().checkChangeEmail(auth.idx.value, auth.corpId.value).then((value) {
            auth.checkChangeMail.value = value.mailChangeFlg!;
            box.write('change_mail_flag', auth.checkChangeMail.value);
          });

          txtUserName.clear();
          txtPassword.clear();
          box.write('loginTime', DateTime.now().millisecondsSinceEpoch);
          router.goNamed('home');

        } else {
          errorTxt.value  = userInfo.errorMessage!;
          showError.value = true;
        }
      }

    } catch (e) {printError(info: e.toString());}
  }

  Future<void> _registerDevice(String email) async {
    try {

      int checkRegister = await UserService().registerDevice(email);
      if (kDebugMode) {
      }
    } catch (e) {printError(info: e.toString());}
  }
  Future<void> resetForm()async {
    txtPassword.text = '';
    txtUserName.text = '';
    showError.value              = false;
    showLoginGoogleError.value   = false;
  }
  Future<void> fillForm()async {
    txtPassword.text = auth.pass.value;
    txtUserName.text = auth.email.value;
    showError.value              = false;
    showLoginGoogleError.value   = false;
  }
  Future<bool> login() async {
    return true;
  }

}
