import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:manamo/presentation/controllers/change_pass/change_pass_controller.dart';
class ChangePassView extends GetView<ChangePassController> {
  const ChangePassView({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('メールアドレス'),
          TextBox(
            controller: controller.txtEmail,
            enabled: controller.enableTextField(),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('新しいパスワード（半角英数字)'),
          TextBox(
            controller: controller.txtNewPass,
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(() => controller.auth.isLogin.value ? keyNumber() : const SizedBox()),
          const SizedBox(
            height: 20,
          ),
          FilledButton(
            onPressed: () {
              if (controller.auth.isLogin.value) {
                controller.onChangePass().then((value) => controller.onShowDialog(context, value));
              } else {
                controller.onChangePassLoggedIn().then((value) => controller.onShowDialog(context, value));
              }
            },
            child: const Text('パスワード再発行'),
          ),
        ],
      ),
    );
  }
  Widget keyNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('変更キーワード'),
        TextBox(
          controller: controller.txtKeyword,
        ),
      ],
    );
  }
}