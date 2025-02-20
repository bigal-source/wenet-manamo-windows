import 'package:get/get.dart';
import 'static_controller.dart';

class StaticBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StaticController>(()             => StaticController(),);
  }
}
