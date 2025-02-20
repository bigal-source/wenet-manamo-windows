import 'package:get/get.dart';
import 'package:manamo/presentation/controllers/change_pass/change_pass_controller.dart';
class ChangePassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangePassController());
  }
}