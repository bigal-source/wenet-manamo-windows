

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../app/services/authen_service.dart';
import '../../../app/services/book_provider.dart';
import '../../../app/utils/constants/strings.dart';
import '../../../data/models/book_info.dart';
import '../../../data/models/cate_info.dart';

class CatalogDetailController extends GetxController{
  //TODO: Implement HomeController
  final  _process          = 0.0.obs;
  final box                = GetStorage('info',dir);
  final _listBook          = <Book>[].obs;
  final _cateInfo          = CateInfo().obs;
  final  loading           = true.obs;
  CatalogDetailController();
  static CatalogDetailController get to => Get.find();
  final auth       = Get.find<AuthenService>();
  List<Book>      get listBook         => _listBook.value;
  CateInfo        get cateInfo         => _cateInfo.value;


  late String  actionType    = '';
  late String  annotationId  = '';
  late int     currPage      = 0;
  var    isHover             = false.obs;

  Future<void> getCategories(String cateSeq) async {
     if (kDebugMode) {
       print("Categories Detail $cateSeq");
     }
    try{
      var data = await BookProvider().getBookInCate(auth.idx.value.toString(),cateSeq);
      _cateInfo.value   = data[0].cate![0];
      _listBook.value   = data[0].listBook!;
      _listBook.refresh();
      loading.value = false;
      update();
      if (kDebugMode) {
        print('listBook.length');
        print(listBook.length);
      }
    }catch(ex){
      if (kDebugMode) {
        print(ex);
      }
    }
  }
}