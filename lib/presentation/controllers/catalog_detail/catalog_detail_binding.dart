import 'package:get/get.dart';
import '../book/book_controller.dart';
import 'catalog_detail_controller.dart';

class CatalogDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CatalogDetailController());
    Get.lazyPut<BookController>(()             => BookController(),);
  }
}
