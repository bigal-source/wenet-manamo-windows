
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../app/services/authen_service.dart';
import '../../../app/services/book_provider.dart';
import '../../../app/utils/constants/strings.dart';
import '../../../data/models/book_info.dart';

class HomeController extends GetxController{
  //TODO: Implement HomeController
  static HomeController get to => Get.find();
  final auth               = Get.find<AuthenService>();
  dynamic argumentData     = Get.arguments;
  final  _isLoading        = true.obs;
  final  _isImportXfdf     = true.obs;
  final  _permissionReady  = false.obs;
  final  _process          = 0.0.obs;
  final box                = GetStorage('info',dir);
  final _listCate          = <BookCate>[].obs;
  final  _bookInfo         = BookInfoModel().obs;
  final  listNotice        = [].obs;


  bool            get isLoading        => _isLoading.value;
  bool            get isImportXfdf     => _isImportXfdf.value;
  List<BookCate>  get listCate         => _listCate.value;
  BookInfoModel   get bookInfo         => _bookInfo.value;
  bool            get permissionReady  => _permissionReady.value;
  double          get process          => _process.value;

  set isLoading(value)           => _isLoading.value = value;
  set process(value)             => _process.value = value;

  late String  actionType    = '';
  late String  annotationId  = '';
  late int     currPage      = 0;

  @override
  Future<void> onInit() async {
    super.onInit();
    if (await auth.checkAllowThisDeviceLogin()) {
      getBooks();
    } else {
      return;
    }
  }
  Future<void> getBooks() async {
    _isLoading.value = true;
    try{
      _listCate.value  = await BookProvider().getBookCategories(auth.idx.value);
      update();

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
  }
}