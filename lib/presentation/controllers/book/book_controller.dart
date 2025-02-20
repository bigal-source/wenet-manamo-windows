
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../app/utils/constants/strings.dart';
import '../../../data/models/book_info.dart';

class BookController extends GetxController{
  //TODO: Implement HomeController
  dynamic argumentData     = Get.arguments;
  final  _isLoading        = 0.0.obs;
  final box                = GetStorage('info',dir);

  static BookController get to => Get.find();
  set isLoading(value)           => _isLoading.value = value;
  late Book  bookItem;


  @override
  Future<void> onInit() async {
    super.onInit();
    bookItem          = argumentData[0]['book'];
    printInfo(info: bookItem.toJson().toString());
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), (){
      SystemChrome.setPreferredOrientations([]);
    });
    ///--- force logout
  }

  @override
  void onClose() {
  }
}