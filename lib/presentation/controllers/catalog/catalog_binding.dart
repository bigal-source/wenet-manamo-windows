
import 'package:get/get.dart';
import '../book/book_controller.dart';
import 'catalog_controller.dart';


class CatalogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CatalogController());
    Get.lazyPut<BookController>(()             => BookController(),);
  }
}
