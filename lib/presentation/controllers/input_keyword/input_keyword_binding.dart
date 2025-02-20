import 'package:get/get.dart';
import 'input_keyword_controller.dart';
class InputKeyWordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InputKeyWordController());
  }
}