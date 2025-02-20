
import 'package:get/get.dart';
import '../../../app/services/authen_service.dart';
import '../../../app/services/local_storage.dart';
import '../book/book_controller.dart';
import '../book_detail/book_detail_controller.dart';
import '../book_shelf/book_shelf_controller.dart';
import '../search/search_controller.dart';
import '../static/static_controller.dart';
import '../windows/window_controller.dart';
import 'home_controller.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocalStorageService());
    Get.lazyPut(() => AuthenService());
    Get.put(StaticController());
    Get.put(BookShelfController());
    Get.lazyPut(() => BookDetailController());
    Get.lazyPut(() => SearchBookController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => BookShelfController());
    Get.lazyPut(() => BookController(),);
    Get.lazyPut(() => WindowController(),);

  }
}
