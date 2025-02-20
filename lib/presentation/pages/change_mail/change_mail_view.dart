import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:manamo/presentation/controllers/change_mail/change_mail_controller.dart';
class ChangeMailView extends GetView<ChangeMailController> {
  const ChangeMailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('現在のメールアドレス'),
          TextBox(
            controller: controller.txtEmail,
            enabled: false,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('新メールアドレス'),
          TextBox(
            controller: controller.txtNewMail,
          ),
          const SizedBox(
            height: 20,
          ),
          FilledButton(
            onPressed: () {
              controller.onChangeEmail().then((value) {
                controller.handleCheckEmail(context, value);
              });
            },
            child: const Text('確認'),
          ),
        ],
      ),
    );
  }
}