import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:manamo/app/router/router.dart';
import 'package:manamo/app/services/change_pass_service.dart';
import '../../../app/services/authen_service.dart';
class InputKeyWordController extends GetxController {
  static InputKeyWordController get to => Get.find();
  final auth = Get.find<AuthenService>();
  late TextEditingController txtKeyword = TextEditingController();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  Future<Map> onChangeEmail(String newEmail) async {
    try {
      var resp = await ChangeMailServices().changeEmail(int.parse(auth.idx.value.toString()), newEmail, txtKeyword.text, auth.corpId.value);
      return resp;
    } catch (e) {}
    return {};
  }
  Future<void> onShowDialog(BuildContext context, Map data, String newEmail) async {
    showDialog(context: context,
      builder: (context) {
        return ContentDialog(
          title: Text(data['message'], style: const TextStyle(fontSize: 20)),
          actions: [
            FilledButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if(data['status'] == true) {
                  auth.email.value = newEmail;
                  auth.box.write('email', newEmail);
                  txtKeyword.clear();
                  router.push('/home');
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