import 'package:get/get.dart';
import '../../../data/repositories/local/user_repository_impl.dart';
import '../../../domain/usecases/save_user_use_case.dart';
import 'auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SaveUserUseCase(Get.find<UserRepositoryIml>()));
    Get.lazyPut(() => AuthController());
  }
}
