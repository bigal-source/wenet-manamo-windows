import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:manamo/app/router/router.dart';
import 'package:manamo/presentation/controllers/windows/window_off_controller.dart';
import '../../../app/services/authen_service.dart';
import '../../../app/services/userService.dart';
import '../../../app/utils/constants/strings.dart';
import '../../../data/datasources/local/db_help.dart';
import '../../../data/models/Employee.dart';
import '../../../data/models/bookModel.dart';
import '../../pages/reading/reading_off_view.dart';
class BookShelfController extends GetxController with GetSingleTickerProviderStateMixin {
  static BookShelfController get to => Get.find();
  var box                  = GetStorage('info',dir);
  final auth               = Get.find<AuthenService>();
  final  _pageController   =PageController(initialPage: 0).obs;
  final  _url              ="".obs;
  final  _lastEventName    ="".obs;
  final  _isCate           =false.obs;
  final  _isDetail         =false.obs;
  final  _isAdd            =false.obs;
  final  _isLongPress      =false.obs;
  final  _loading          =false.obs;
  final  _index            =0.obs;
  final  _cateSelectedIdx  =0.obs;
  final  _bookSelected     =Bshelf().obs;
  final  _cateSelected     =CategoryShelf().obs;
  final  _bshelfs          =List<Bshelf>.empty(growable : true).obs;
  final  _categorys        =<CategoryShelf>[].obs;
  final  _cateDownloads    =List<CategoryDownLoad>.empty(growable : true).obs;
  var    booksChecked      =<Bshelf>[].obs;
  final  _cateName         ='すべて'.obs;
  final  hasChecked        = false.obs;
  var    isEdit            = false.obs;
  var    isEditCate        = false.obs;
  var    isExPlain         = false.obs;
  var    isSaveCate        = false.obs;
  var    isDelete          = false.obs;
  var    bookOpen          =Bshelf().obs;


  GlobalKey bottomNavigationKey = GlobalKey();


  String       get url             => _url.value;
  String       get lastEventName   => _lastEventName.value;
  bool         get isDetail        => _isDetail.value;
  bool         get isAdd           => _isAdd.value;
  bool         get isCate          => _isCate.value;
  bool         get loading         => _loading.value;
  bool         get isLongPress     => _isLongPress.value;
  int          get index           => _index.value;
  int          get cateSelectedIdx => _cateSelectedIdx.value;
  String       get cateName        => _cateName.value;

  List<Bshelf> get bshelfs                    => _bshelfs.value;
  List<CategoryShelf>    get categorys        => _categorys.value;
  List<CategoryDownLoad> get cateDownloads    => _cateDownloads.value;
  Bshelf              get bookSelected        => _bookSelected.value;
  CategoryShelf       get cateSelected        => _cateSelected.value;
  PageController      get pageContentcontroller  => _pageController.value;

  set isDetail(value)                  => _isDetail.value = value;
  set isLongPress(value)               => _isLongPress.value = value;
  set cateSelected(value)              => _cateSelected.value = value;
  set cateName(value)                  => _cateName.value = value;
  set lastEventName(value)             => _lastEventName.value = value;
  set bookSelected(value)              => _bookSelected.value = value;
  set cateSelectedIdx(value)           => _cateSelectedIdx.value = value;

  late TextEditingController txtCategory;
  late List<Employee> employee;
  late Directory root; // this is using path_provider
  late String    directoryPath; // this is using path_provider
  var page = 0.obs;
  var appBarPageController             = PageController();
  final Duration duration              = const Duration(milliseconds: 300);

  /// WNT_20241004 (4)
  String onTapBookID = '';

  @override
  Future<void> onInit() async {
    super.onInit();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (kDebugMode) {
    }
    _cateName.value         ='すべて';
    _isCate.value           =false;
    _isDetail.value         =false;
    _index.value            =0;
    directoryPath           = dir;
    txtCategory           = TextEditingController();
    // getListCategory();
    createDefaultCategory("すべて");
    if (kDebugMode) {
      print("book shelf");
      print(router.location);
    }
  }
  Future<void> cleanChecked()async {
    isEdit.value       = true;
    isDelete.value     = false;
    hasChecked.value   = false;
    booksChecked.value = [];
    printInfo(info: "clean");
    for(int i = 0; i < cateDownloads.length; i++){
      cateDownloads[i].books?.forEach((element) => element.selected = '0');
    }
    update();
  }
  bool actionBook(int cateIndex,int listIndex,Bshelf book){
    if(isEdit.value){
      checkedBookCate(cateIndex,listIndex,book);
      if (kDebugMode) {
        print("bookThumbPhone");
        print("book.selected ${book.selected}");
      }
    }else{
      booksChecked.value     = [];
      hasChecked.value       = false;
      // controller.gotoBookView(book);
    }
    update();
    return true;
  }
  Future<bool> editBook() async {
    if(hasChecked.value == false){
      isDelete.value     = false;
      isEdit.value       = !isEdit.value;
      booksChecked.value = []; // reset list checked
    }else{
      isEdit.value   = true;
      isDelete.value = true;
    }
    //todo: delete books
    if(isEdit.value == true && hasChecked.value == true){
       bool result = await deleteBooks();
       if(result){

       }
    }
    update();
    return true;
  }
  Future<bool> onOffDeleteCategory() async {
    bool result = false;
    isDelete.value = !isDelete.value;
    result         = isDelete.value;
    return result;
  }
  Future<int> checkedBookCate(int cateIndex,int listIndex, Bshelf book) async {
    //1. update list category vs item list
    book.selected = book.selected.toString() == "1" ? "0": "1";
    _cateDownloads.value[cateIndex].books![listIndex].selected  = book.selected;
    _index.value        = index;
    //2. add list checked
    final idx  = booksChecked.indexWhere((element) => element.bookAppId == book.bookAppId);
    if(idx >= 0){
      booksChecked.removeAt(idx);
    }else{
      booksChecked.add(book);
    }
    hasChecked.value = booksChecked.isNotEmpty ? true : false;
    isDelete.value   = booksChecked.isNotEmpty ? true : false;
    update();
    return index;
  }
  Future<int> getBookShelf() async {
    final List<Bshelf> data =  await SQLHelper.getAllBookShelf(1);
    _bshelfs.value = [];
    if(data.isNotEmpty){
      _bshelfs.value = data;
      for(var i = 0; i < _bshelfs.value.length; i++){
      }
      _bshelfs.refresh();
    }
    update();
    if (kDebugMode) {
    }
    return _bshelfs.value.length;
  }
  Future<int> getBooksInCategory(int cateId) async {
    final List<Bshelf> data =  await SQLHelper.getBooksInCaterory(cateId);
    _bshelfs.value   = [];
    if(data.isNotEmpty){
      _bshelfs.value = data;
      _bshelfs.refresh();
    }
    update();
    if (kDebugMode) {
    }
    return _bshelfs.value.length;
  }
  Future<int> getBooksInSeq(String cateId) async {
    final List<Bshelf> data =  await SQLHelper.getAllBookInCate(cateId);
    _bshelfs.value   = [];
    if(data.isNotEmpty){
      _bshelfs.value = data;
      _bshelfs.refresh();
    }
    update();
    if (kDebugMode) {
    }
    return _bshelfs.value.length;
  }
  Future getListCategory() async {
    if (kDebugMode) {
      print("getListCategory");

    }
    _loading.value    = true;
    final List<CategoryDownLoad> data =  await SQLHelper.getAllCategorys2();
    _cateDownloads.value = [];
    if(data.isNotEmpty){
      _cateDownloads.value = data;
      _cateDownloads.refresh();
    }
    update();
    _loading.value  = false;
  }
  Future<void> gotoBookView(Bshelf book) async {
    UserService().getMetaDataFromServer(auth.idx.value, book.bookAppId!).then((value) => {
      printInfo(info: "123"),
      printInfo(info: value.toString()),
    });
    Get.toNamed('/book-view-off', arguments: [{"book": book,'shelf': 1},{"pages": book.pages,"lastPage":book.lastPage}])?.then((value) => {});
  }
  Future resizeImg(urlImage) async {
    //Image image = decodeImage(new Io.File('test.jpg').readAsBytesSync());
    _bshelfs.value =  await SQLHelper.getAllBookShelf(1);
    if (kDebugMode) {
    }
  }
  changeViewBookSheft(){
    _isDetail.value = !_isDetail.value;
  }
  changeBooksEdit(){
    if(!isEdit.value){
      booksChecked.value = [];
      if(cateSelected.id == null){
        getBookShelf();
      }else{
        getBooksInSeq(cateSelected.id!.toString());
      }
    }
  }
  backBookShelf(value){
    _isCate.value = value;
    if(value){
      pageContentcontroller.nextPage(duration: duration, curve: const Cubic(0.35, 0.91, 0.33, 0.97));
    }else{
      pageContentcontroller.previousPage(duration: duration, curve:const Cubic(0.35, 0.91, 0.33, 0.97));
      resetBshelfPage();
    }
  }
  resetBshelfPage(){
    booksChecked.value = [];
    isDelete.value  = false;
    isEdit.value    = false;
    _isCate.value   = false;
    _bshelfs.refresh();
    update();
  }
  resetBookPage(){
    isEdit.value = false;
    booksChecked.value = [];
    isDelete.value     = false;
    _isCate.value      = false;
    _bshelfs.refresh();
    update();
  }
  resetEditBook(){
    booksChecked.value  = [];
    isDelete.value      = false;
    isEdit.value        = false;
    hasChecked.value    = false;
    getListCategory();
    update();
  }

  //todo:category shelf
  Future<bool>sortCategory() async {
    bool result = false;
     for(int i = 0; i < cateDownloads.length; i++){
       var  item          = cateDownloads[i];
       CategoryShelf cate = CategoryShelf(
        id  : item.id,
        name: item.name,
        open: item.open,
        sort: (i+1),
       );
       SQLHelper.updateCategory(cate).then((value) => {
         if(value <= 0){
           result = false,
         },
       });
     }
    getListCategory();
    return result;
  }
  Future<bool> updateCategory(CategoryDownLoad item) async {
    bool result = false;
    var cateUpdate    =  await SQLHelper.getCategory(item.id!);
    if(cateUpdate.id != null && txtCategory.text.isNotEmpty){
      result  = true;
      cateUpdate.name = txtCategory.text;
      cateUpdate.open = item.open;
      await SQLHelper.updateCategory(cateUpdate).then((value) => {
        getListCategory(),
      });
    }
    return result;
  }
  Future<bool>updateCategoryOpen(CategoryDownLoad item) async {
    bool result = false;
    var cateUpdate    =  await SQLHelper.getCategory(item.id!);
    if(cateUpdate.id != null){
      result  = true;
      cateUpdate.open = item.open;
      await SQLHelper.updateCategory(cateUpdate).then((value) => {
        getListCategory(),
      });
    }
    return result;
  }
  //todo: delete category
  Future<bool>deleteCategory(CategoryDownLoad item) async {
    bool result = false;
    final cateResp   = await SQLHelper.deleteCategory(item);
    if(cateResp > 0){
      getListCategory();
      result = true;
    }
    return result;
  }
  //todo: create category
  Future<bool>createModalCategory() async {
    bool result = false;
    if(txtCategory.text.isNotEmpty){
      CategoryShelf cateSave    = CategoryShelf(
        name        : txtCategory.text,
        open        : 0,
        sort        : 0,
      );
      final cateResp   = await SQLHelper.saveCategory(cateSave);
      if(cateResp.id != null){
        result = true;
        sortCategory();
        // getListCategory();
      }
      if (kDebugMode) {
      }
    }
    return result;
  }
  Future<bool>createDefaultCategory(String name) async {
    bool result = false;
    final List<CategoryDownLoad> data =  await SQLHelper.getAllCategorys2();
    if(data.isEmpty){
      CategoryShelf cateSave    = CategoryShelf(
        name        : name,
        open        : 0,
        sort        : 100,
      );
      await SQLHelper.saveCategory(cateSave);
      result = true;
      getListCategory();
    }
    return result;
  }
  //todo: category book
  Future<bool>changeCategoryBook(CategoryShelf cate) async {
    bool result = true;
    for( int i = 0; i < booksChecked.length ; i++){
      Bshelf  book  = booksChecked[i];
      book.selected    = '0';
      book.cateSeq     = cate.id!.toString();
      final bookResp   = await SQLHelper.updateBookShelf(book);
      if(bookResp <= 0){
        result = false;
      }
      if (kDebugMode) {
      }
    }
    // call book in category
    getBooksInSeq(cate.id!.toString()).then((value) => {
      _cateSelected.value   = cate,
      _cateName.value       = cate.name!,
    });
    return result;
  }
  //todo: Books
  Future<bool> deleteBooks() async {
    bool result     = true;
    _loading.value  = true;

     try{
       for(int i = 0; i < booksChecked.value.length; i++){ // loop book
         var bookDel       = booksChecked.value[i];
         var dirF           = Directory('$dir/web/${bookDel.bookAppId}');
         final bookDelResp = await SQLHelper.deleteBook(bookDel);
         if(bookDelResp > 0){
           await SQLHelper.deleteBookInCate(bookDel.id!).then((value) => {
             dirF.deleteSync(recursive: true),
           });
         }
       }
       resetEditBook();
       result = true;
     }catch(ex){
       result = false;
     }
    return result;
  }
  Future<bool>updateBook(Bshelf item) async {
    var result = await SQLHelper.updateBook(item);
    getListCategory();
    if (kDebugMode) {
    }
    return result == 1? true : false;
  }
  Future<bool>updateBookPosition(List<Bshelf> books, int cateId) async {
    bool result = false;
    for(int i = 0; i < books.length; i++ ){
      var item = books[i];
      item.sortNo = i;
      item.cateId = cateId;
      SQLHelper.updateBook(item).then((value) => {
        if(value == 1){
          result =  true,
        }
      });
    }
    getListCategory();
    if (kDebugMode) {
    }
    return result;
  }

  //todo: open book
  void openBook( BuildContext context, Bshelf bookSelected, String url) async{
    bookOpen.value   = bookSelected;
    if(auth.isConnected.value == true){
      await updateMetaData(auth.idx.value, bookSelected.bookAppId!);
    }
    if(Platform.isMacOS){
      final ReadingOffPage browser = ReadingOffPage();

      await browser.openUrlRequest(
        urlRequest:URLRequest(url: WebUri(url)),
        settings: InAppBrowserClassSettings(
          browserSettings: InAppBrowserSettings(
            hideToolbarTop: true,
            toolbarTopBackgroundColor: Colors.transparent,
            presentationStyle: ModalPresentationStyle.FULL_SCREEN,
            transitionStyle: ModalTransitionStyle.FLIP_HORIZONTAL,
            allowGoBackWithBackButton: false,

          ),
          webViewSettings: InAppWebViewSettings(
            isInspectable: kDebugMode,
            useShouldOverrideUrlLoading: true,
            useOnLoadResource: true,
          ),
        ),
      );
      // created
      var created = await browser.onBrowserCreated();
      printInfo(info: "created $created");

      // closed
      var closed = await browser.onExit();
      if(closed){
        printInfo(info: "closed $closed");
      }

    }else{
      bookOpen.value.selected = '0';
      Get.lazyPut<WindowOffController>(() => WindowOffController());
      context.push('/windows-off', extra: {'url': url, 'session' : auth.session.value, 'book' : bookSelected});
    }
  }
  Future<bool> updateMetaData(idx,bookAppId) async {
    _loading.value = true;
    bool result = true;
    Map map  =  await UserService().getMetaDataFromServer(idx, bookAppId);
    if(map['status'] == true){
      result = await SQLHelper.updateMetaDataFromServer(map['obj'],map['bookmark'], bookAppId);
    }
    _loading.value = false;
    return result;
  }
  Future<int>  updateLastPage(stringUrl) async {
    final page = stringUrl.split('#');
    bookOpen.value.lastPage     = page.length > 1 ? int.tryParse(page[1]) : 1; // done
    final result =  await SQLHelper.updateBookShelf(bookOpen.value);
    if (kDebugMode) {
      print("Book ${bookOpen.value.bookAppId}");
      print("lastPage ${bookOpen.value.lastPage}");
    }
    return result > 0 ? 1 : 0;
  }
  Future<void> saveLocalStorage(wController) async {
    var store = await wController?.evaluateJavascript(source:"window.localStorage.getItem('jStorage')");
    box.write('jStorage',store);
    if (kDebugMode) {
      printInfo(info: 'saveLocalStorage');
    }
  }
  Future<void> syncLocalStorage(wController) async {
    var storeData = box.read('jStorage');
    if(storeData.toString() != 'null'){
      await wController?.evaluateJavascript(source:"window.localStorage.setItem('jStorage','$storeData')");
    }
    if (kDebugMode) {
      printInfo(info: 'syncLocalStorage');
    }
  }

  @override
  void onClose() {
   // Get.delete<BookShelfController>();
  }
}
