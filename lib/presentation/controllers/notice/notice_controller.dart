import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../app/services/book_provider.dart';
import '../../../data/models/noticeModel.dart';

class NoticeController extends GetxController{
  //TODO: Implement HomeController
  static NoticeController get to => Get.find();
  late   String description       = '';
  var     info                    = NoticeView().obs;
  var     loading                 = true.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    loading.value = true;
    printInfo(info: "Notice");
  }
  Future<void> getNotice() async   {
    if (kDebugMode) {
    }
    try{
      info.value = await BookProvider().getNotices();
      printInfo(info: info.value.result.toString());
      loading.value = false;
      update();
    }catch(ex){
      if (kDebugMode) {
        print(ex);
      }
    }
  }
}