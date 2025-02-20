
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../app/services/authen_service.dart';
import '../../../app/services/book_provider.dart';
import '../../../app/utils/constants/strings.dart';
import '../../../data/models/book_info.dart';

class CatalogController extends GetxController{
  //TODO: Implement HomeController
  dynamic argumentData     = Get.arguments;
  final  _isLoading        = true.obs;
  final  _process          = 0.0.obs;
  final box                = GetStorage('info',dir);
  final _listCate          = <BookCate>[].obs;
  final  _bookInfo         = BookInfoModel().obs;
  final  listNotice        = [].obs;

  static CatalogController get to => Get.find();
  final auth       = Get.find<AuthenService>();
  bool            get isLoading        => _isLoading.value;
  List<BookCate>  get listCate         => _listCate.value;
  BookInfoModel   get bookInfo         => _bookInfo.value;
  double          get process          => _process.value;

  set isLoading(value)           => _isLoading.value = value;
  set process(value)             => _process.value = value;

  late String  actionType    = '';
  late String  annotationId  = '';
  late int     currPage      = 0;
  var    isHover             = false.obs;


  @override
  Future<void> onInit() async {
    super.onInit();
    getCategories();
  }
  Future<void> getCategories() async {
    _isLoading.value = true;
    try{
      _listCate.value  = await BookProvider().getCategories(auth.idx.value.toString());

      update();
      if (kDebugMode) {
        print(listCate.length);
      }
    }catch(ex){
      if (kDebugMode) {
        print(ex);
      }
    }
    _isLoading.value = false;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    if (auth.device.value == 'phone') {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }
}