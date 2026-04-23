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

  Future<AuthResult?> signInGoogle({String logout_seq = "", String logout_device_id = ""}) async {
    showLoginGoogleError.value = false;
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
      if (result?.idToken != null && result?.accessToken != null) {
        await getUserInfo(gmail, logout_seq: logout_seq, logout_device_id: logout_device_id);
      }
    }




    return null;

  }
  Future<void> signInPassword({String logout_seq = "", String logout_device_id = ""}) async {
    showError.value = false;
    try {
      if(txtPassword.text != "" && txtUserName.text != ""){
        LoginModel userInfo = await UserService().loginDB(txtUserName.text, txtPassword.text, logout_seq: logout_seq, logout_device_id: logout_device_id);
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        String encoded = stringToBase64.encode(jsonEncode(userInfo.toJson()));
        if (kDebugMode) {
          print("signInPassword");
          print(userInfo.toJson());
          print(userInfo.result);
        }
        if (userInfo.result == 'true') {
          //todo: log time
          auth.title.value          = "HOME";
          auth.session.value        = userInfo.sessionId!;
          auth.idx.value            = userInfo.idX!;
          auth.userId.value         = userInfo.userId!;
          auth.email.value          = txtUserName.text;
          auth.pass.value           = txtPassword.text;
          auth.corpId.value         = userInfo.corpName!;
          auth.headerX.value        = userInfo.corpName! == 'manamo' ? manamo  : m10507;
          auth.token.value          = encoded;
          auth.isLogin.value        = false;
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
            auth.checkChangeMail.value = value.mailChangeFlg ?? 0;
            box.write('change_mail_flag', auth.checkChangeMail.value);
          });

          box.write('loginTime', DateTime.now().millisecondsSinceEpoch);
          await _registerDevice(txtUserName.text);
          txtUserName.clear();
          txtPassword.clear();
          errorTxt.value = "";
          showError.value = false;
          await auth.init();
          router.goNamed('home');

        } else {
          errorTxt.value  = userInfo.errorMessage!;
          showError.value = true;
          if (userInfo.maxDeviceLogin != null && userInfo.deviceInfo != null) {
            if (userInfo.maxDeviceLogin == true) {
              var data = await showMaxDeviceLoginDialog(deviceInfo: userInfo.deviceInfo!);
              if (data != null) {
                Map<String, dynamic> deviceData = data;
                String logout_seq = deviceData['seq'] ?? "";
                String logout_device_id = deviceData['device_id'] ?? "";
                if (logout_seq != "" && logout_device_id != "") {
                  reLogin(logout_seq: logout_seq, logout_device_id: logout_device_id);
                }
              }
            }
          }
        }
      }

    } catch (e) {printError(info: e.toString());}
  }
  Future<void> getUserInfo(String email, {String logout_seq = "", String logout_device_id = ""}) async {
    showLoginGoogleError.value = false;
    LoginModel userInfo = await UserService().checkEmail(gmail, logout_seq: logout_seq, logout_device_id: logout_device_id);
    if (userInfo.result == 'true') {
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
        auth.checkChangeMail.value = value.mailChangeFlg ?? 0;
        box.write('change_mail_flag', auth.checkChangeMail.value);
      });
      box.write('loginTime', DateTime.now().millisecondsSinceEpoch);
      await _registerDevice(gmail);
      await auth.init();
      router.goNamed('home');

      if (kDebugMode) {
      }


    } else {
      if (kDebugMode) {
      }
      showLoginGoogleError.value = true;
      errorTxt.value = userInfo.errorMessage!;
      if (userInfo.maxDeviceLogin != null && userInfo.deviceInfo != null) {
        if (userInfo.maxDeviceLogin == true) {
          var data = await showMaxDeviceLoginDialog(deviceInfo: userInfo.deviceInfo!);
          if (data != null) {
            Map<String, dynamic> deviceData = data;
            String logout_seq = deviceData['seq'] ?? "";
            String logout_device_id = deviceData['device_id'] ?? "";
            if (logout_seq != "" && logout_device_id != "") {
              reLoginGoogle(logout_seq: logout_seq, logout_device_id: logout_device_id);
            }
          }
        }
      }
    }
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

  Future<dynamic> showMaxDeviceLoginDialog({required List<dynamic> deviceInfo}) {
    final selectedDevice = Rxn<dynamic>();
    return showDialog(
      barrierDismissible: true,
      context: rootNavigatorKey.currentContext!,
      builder: (BuildContext context) {
        return ContentDialog(
          title: const Text(
            "同時ログイン制限確認",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "同時ログイン数を超えているため、ログアウトする端末を選択してください。\nその際、オフライン状態での書込みを行ったデータが削除される可能性がございます。",
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 16),
              Obx(() => Column(
                children: deviceInfo.map((device) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        selectedDevice.value = device;
                      },
                      child: Row(
                        children: [
                          RadioButton(
                            checked: selectedDevice.value == device,
                            onChanged: (value) {
                              selectedDevice.value = device;
                            },
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              device['device_name']?.toString() ?? "",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              )),
              const SizedBox(height: 16),
              Obx(() {
                if (selectedDevice.value == null) {
                  return Text("ログアウトする端末を選択してください", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red), textAlign: TextAlign.center,);
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
          actions: [
            Button(
              child: const Text("キャンセル"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Obx(() => FilledButton(
              style: ButtonStyle(
                  backgroundColor: selectedDevice.value != null ? ButtonState.all(Colors.blue) : ButtonState.all(Colors.grey[100])
              ),
              child: const Text("ログアウトする"),
              onPressed: () {
                if (selectedDevice.value != null) {
                  Navigator.pop(context, selectedDevice.value);
                }
              },
            )),
          ],
        );
      },
    );
  }

  void reLogin({required String logout_seq, required String logout_device_id}) async {
    await signInPassword(logout_seq: logout_seq, logout_device_id: logout_device_id);
  }

  void reLoginGoogle({required String logout_seq, required String logout_device_id}) async {
    await getUserInfo(gmail, logout_seq: logout_seq, logout_device_id: logout_device_id);
  }

}
