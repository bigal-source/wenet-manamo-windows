import 'package:get/get.dart';
import 'change_mail_controller.dart';
class ChangeMailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangeMailController());
  }
}