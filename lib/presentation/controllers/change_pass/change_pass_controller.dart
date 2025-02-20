import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:manamo/app/router/router.dart';
import 'package:manamo/app/services/change_pass_service.dart';
import '../../../app/services/authen_service.dart';
class ChangePassController extends GetxController {
  static ChangePassController get to => Get.find();
  final auth = Get.find<AuthenService>();
  late TextEditingController txtEmail   = TextEditingController();
  late TextEditingController txtNewPass = TextEditingController();
  late TextEditingController txtKeyword = TextEditingController();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (auth.isLogin.isFalse) {
      txtEmail.text = auth.email.value;
    }
  }

  bool enableTextField() {
    bool enable = false;
    if (auth.isLogin.isTrue) {
      txtEmail.clear();
      enable = true;
    } else {
      enable = false;
    }
    return enable;
  }
  
  Future<Map> onChangePass() async {
    try {
      var resp = await ChangePassServices().changePass(txtEmail.text, txtNewPass.text, txtKeyword.text);
      return resp;
    } catch (e) {}
    return {};
  }
  Future<Map> onChangePassLoggedIn() async {
    try {
      var resp = await ChangePassServices().changePassLoggedIn(txtEmail.text, txtNewPass.text, auth.idx.value, auth.corpId.value);
      return resp;
    } catch (e) {
    }
    return {};
  }
  Future<void> onShowDialog(BuildContext context, Map data) async {
    showDialog(context: context,
    builder: (context) {
      return ContentDialog(
        title: Text(data['message'], style: const TextStyle(fontSize: 20)),
        actions: [
          FilledButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              if(data['status'] == true && auth.isLogin.isFalse) {
                txtKeyword.clear();
                txtEmail.clear();
                txtNewPass.clear();
                router.push('/home');
              } else if(data['status'] == true && auth.isLogin.isTrue) {
                txtKeyword.clear();
                txtEmail.clear();
                txtNewPass.clear();
                router.pushReplacement('/login');
              }
            },
          ),
        ],
      );
    },
      barrierDismissible: false,
    );
  }
}