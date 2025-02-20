
import 'package:get/get.dart';
import 'window_controller.dart';


class WindowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WindowController());
  }
}
