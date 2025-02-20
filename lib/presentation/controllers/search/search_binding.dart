
import 'package:get/get.dart';
import '../book/book_controller.dart';
import '../book_shelf/book_shelf_controller.dart';
import '../home/home_controller.dart';
import 'search_controller.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchBookController());
    Get.lazyPut(() => BookShelfController());
    Get.lazyPut<BookController>(()             => BookController(),);
    Get.lazyPut<HomeController>(()              => HomeController(),);

  }
}
