
import 'package:get/get.dart';
import '../home/home_controller.dart';
import 'book_detail_controller.dart';


class BookDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookDetailController>(()             => BookDetailController(),);
    Get.lazyPut<HomeController>(()                   => HomeController(),);
  }
}
