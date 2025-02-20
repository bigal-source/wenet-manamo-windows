import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:manamo/presentation/controllers/change_mail/change_mail_controller.dart';
import 'package:manamo/presentation/controllers/change_pass/change_pass_controller.dart';
import 'package:manamo/presentation/controllers/input_keyword/input_keyword_controller.dart';
import '../../controllers/book_detail/book_detail_controller.dart';
class InputKeyword extends StatelessWidget {
  final String txtMail;
  InputKeyword({super.key, required this.txtMail});
  var controller = Get.put(InputKeyWordController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('変更キーワード'),
          TextBox(
            controller: controller.txtKeyword,
          ),
          const SizedBox(
            height: 20,
          ),
          FilledButton(
            onPressed: () {
              controller.onChangeEmail(txtMail).then((value) {
                controller.onShowDialog(context, value, txtMail);
              });
            },
            child: const Text('メールアドレス変更'),
          ),
        ],
      ),
    );
  }
}