import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:manamo/app/router/router.dart';
import 'package:manamo/app/services/authen_service.dart';
import 'package:manamo/app/services/change_pass_service.dart';
class ChangeMailController extends GetxController {
  static ChangeMailController get to => Get.find();
  final auth = Get.find<AuthenService>();
  late TextEditingController txtEmail   = TextEditingController();
  late TextEditingController txtNewMail = TextEditingController();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    txtEmail.text = auth.email.value;
  }
  Future<Map> onChangeEmail() async {
    try {
      var resp = await ChangeMailServices().checkEmailForChangeEmail(
          int.parse(auth.idx.value.toString()), txtNewMail.text, auth.corpId.value);
      return resp;
    } catch (e) {}
    return {};
  }
  Future<void> handleCheckEmail(BuildContext context, Map data) async {
    if (data['status'] == true) {
      gotoDetail();
      return;
    }
    onShowDialog(context, data);
  }
  Future<void> gotoDetail() async {
    router.push('/input-keyword', extra: txtNewMail.text);
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
            },
          ),
        ],
      );
    },
      barrierDismissible: false,
    );
  }
}