import 'package:get/get.dart';

class StaticController extends GetxController {
  static StaticController get to => Get.find();
  var title = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    title.value = 'Test';
  }

}
