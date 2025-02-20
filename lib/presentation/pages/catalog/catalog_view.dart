
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../app/services/authen_service.dart';
import '../../../data/models/book_info.dart';
import '../../controllers/catalog/catalog_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
class CatalogView extends GetView<CatalogController>  {
  CatalogView({Key? key}) : super(key: key);
  final auth                 = Get.find<AuthenService>();
  double wt         = 0;
  double bookHeight = 0;
  double scale      = 1.0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    wt       = MediaQuery.of(context).size.width;
    final typography = FluentTheme.of(context).typography;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: SystemUiOverlay.values);
    return ScaffoldPage.withPadding(
      header:  PageHeader(
        title: Obx(() => controller.listCate.isNotEmpty ? SingleChildScrollView(
          child:  Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: [
              for(var item in controller.listCate ) FilledButton(
                style: ButtonStyle(
                  textStyle: ButtonState.all(TextStyle(color: Colors.green)),
                  shape: ButtonState.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)
                      )
                  ),
                ),
                onPressed: () {
                  if (kDebugMode) {
                    print("cateId ${item.categoryId}");
                  }
                  context.push('/category-detail',extra: item,);
                },
                child:  Text('${item.categoryName}　${item.count! > 0 ? '(${item.count}冊)' :''}'),
              ),
            ],),
        ) : const Text("")),
      ),
      content:  Obx((() => controller.listCate.isNotEmpty
          ? categories(context)
          : const Center(child:  Image( image: AssetImage('assets/images/loading.gif')),
      ))),
    );
  }
  Widget categoryTitle(BuildContext context) {
    return Wrap(
      spacing: 8.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: [
        ListView.builder(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(0),
          itemCount: controller.listCate.length,
          itemBuilder: (BuildContext context, int index) {
            // return  ItemHover(txtTitle: controller.listCate[index].categoryName!);
            return FilledButton(
              style: ButtonStyle(
                textStyle: ButtonState.all(TextStyle(color: Colors.green)),
                shape: ButtonState.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)
                    )
                ),
              ),
              onPressed: () {
                print("123");
                context.push('/category-detail');
              },
              child: Text('${controller.listCate[index].categoryName!}　(2冊)'),
            );
          },
        )
      ],);
  }
  Widget categories(BuildContext context) {
    return Column(children: [Expanded(
      flex: 5,
      child:ListView.builder(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0),
        itemCount: controller.listCate.length,
        itemBuilder: (BuildContext context, int index) {
          // return  ItemHover(txtTitle: controller.listCate[index].categoryName!);
          return categoryItem(context, controller.listCate[index], index );
        },
      ),
    )],);
  }
  //todo: one categories
  Widget categoryItem(BuildContext context, BookCate cate, int index) {
    double w = MediaQuery.of(context).size.width;
    final typography = FluentTheme.of(context).typography;
    return Column(
      children: [
        Container(
          width: w,
          height: 80,
          padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(cate.categoryName.toString(), style: typography.title?.apply(fontSizeFactor: scale),),
        ),
        //SizedBox(height: 8),
        bookList(context,cate,index,cate.listBook!),
      ],
    );
  }
  //todo: list book in categories
  Widget bookList(BuildContext context, BookCate cate, int cateIndex, List<Book> bookList, ) {
    double h = MediaQuery.of(context).size.height;
    bookHeight   = h/3;
    return Container(
      height: bookHeight,
      padding: const EdgeInsets.only(left: 8,right: 8),
      child: ListView.builder(
          padding: const EdgeInsets.all(10),
          scrollDirection: Axis.horizontal,
          itemCount: bookList.length,
          itemBuilder: (BuildContext context, int index) {
            return bookItemPhone(context, bookList[index], index, cate, cateIndex );
          }
      ),
    );
  }
  //todo: book item in phone
  Widget bookItemPhone(BuildContext context, Book book, int bookIndex, BookCate cate, int cateIndex,){
    double cw = bookHeight*0.5;
    double ch = bookHeight;
    return  Container(
      margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
      width: cw,
      height: ch,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[20], width: 0.3 ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: GestureDetector(
        onTap: (){
          context.push('/book-detail',extra: book,);
          // Get.toNamed('/home/book', arguments: [{"book": book}]);
        },
        child: Column(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  alignment: Alignment.center,
                  imageUrl: book.image!,
                  progressIndicatorBuilder: (context, url, progress) => const Center(
                    child: null,
                  ),
                  errorWidget: (context, url, error) => const Icon(FluentIcons.error),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 8),
              child: Text(book.title!,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0, color: Colors.grey[160])),
            ),
          ],
        ),
      ),
    );
  }
}
