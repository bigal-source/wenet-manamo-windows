
import 'package:get/get.dart';

import '../home/home_controller.dart';
import '../windows/window_off_controller.dart';
import 'book_shelf_controller.dart';

class BookShelfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookShelfController>(()         => BookShelfController(),);
    Get.lazyPut<WindowOffController>(()         => WindowOffController(),);
    Get.lazyPut<HomeController>(()              => HomeController(),);
  }
}
