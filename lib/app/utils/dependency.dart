
import 'package:get/get.dart';
import 'package:manamo/presentation/controllers/book_shelf/book_shelf_controller.dart';
import '../../presentation/controllers/auth/auth_controller.dart';
import '../../presentation/controllers/book_detail/book_detail_controller.dart';
import '../../presentation/controllers/logout/logout_controller.dart';
import '../../presentation/controllers/notice/notice_controller.dart';
import '../../presentation/controllers/windows/window_controller.dart';
import '../../presentation/controllers/windows/window_off_controller.dart';
import '../services/connectivity_service.dart';
import '../services/local_storage.dart';
import '../services/authen_service.dart';

class DependencyCreator {

  static init() async {

    Get.put(AuthenService());
    Get.put(AuthController());
    Get.put(NoticeController());
    Get.put(LocalStorageService());
    Get.put(LogoutController());
    Get.lazyPut(() => BookDetailController());
    Get.lazyPut(() => BookShelfController());
    Get.lazyPut(() => WindowController());
    Get.lazyPut(() => WindowOffController());
    Get.put(ConnectivityService());

  }
}
