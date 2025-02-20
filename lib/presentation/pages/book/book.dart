import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/presentation/controllers/book/book_controller.dart';
import '../../../app/config/wise_book_icon_icons.dart';
import '../../../app/utils/date_utils.dart';
import '../../../data/models/book_info.dart';


class BookView extends GetView<BookController> {
  const BookView({super.key});

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    double scale          = 1.0;
    return Obx(() => ScaffoldPage.scrollable(
      header:  PageHeader( title: FittedBox( fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(controller.bookItem.title!),),),
      children: [
        SingleChildScrollView(
          child: tablet(context),
        )
      ],
    ));
  }
  Widget tablet(BuildContext context){
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    Typography typography = FluentTheme.of(context).typography;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: w,
            height: h/2,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            padding: const EdgeInsets.only(top: 30, bottom: 30),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Get.isDarkMode? Colors.grey[50]: Colors.grey[80], width: 0.1),
                bottom: BorderSide(color: Get.isDarkMode? Colors.grey[50]: Colors.grey[80], width: 0.1),
              ),
            ),
            child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.topLeft,child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //todo: book cover
                Container(
                    padding: const EdgeInsets.all(10),
                    height: isPortrait ? w/2.2 : h/2.8,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[40]),
                    ),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: controller.bookItem.image!,
                          errorWidget: (context, url, error) => const Icon(FluentIcons.error),
                        ),
                      ],
                    )
                ),
                //todo: space
                const SizedBox(width: 20,),
                //todo: info book + button
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    rowInfo(context,"カテゴリ",controller.bookItem.categoryName!,1.0),
                    rowInfo(context,"公開日",DateUtil.convertSqlDate(DateTime.parse(controller.bookItem.date!)),1.0),
                    rowInfo(context,"ページ数",controller.bookItem.pages!,1.0),
                    rowInfo(context,"サイズ","${controller.bookItem.fileSize!} KB",1.0),
                    rowInfo(context,"配信方法",controller.bookItem.distType!,1.0),
                    //todo: button view book

                    btnViewBook(context, controller.bookItem),
                  ],
                ),
              ],
            ),),
          ),
          //todo: update
          SizedBox(
            // width: w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('詳細',style: typography.title?.apply(fontSizeFactor: 1),
                ),
                SizedBox(
                  height: w / 19,
                ),
                SizedBox(
                  height: w / 19,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget rowInfo(BuildContext context, String label, String txtValue, double scale){
    Typography typography = FluentTheme.of(context).typography;
    double scale          = 1.0;
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:  [
        Container(
          width: 80,
          padding: const EdgeInsets.all(4.0),
          child: Text(label, style: typography.bodyLarge?.apply(fontSizeFactor: scale)),
        ),
        const SizedBox(width: 30,),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(txtValue, overflow: TextOverflow.ellipsis, style: typography.bodyLarge?.apply(fontSizeFactor: scale)),
        ),
      ],
    );
  }
  Widget btnViewBook(BuildContext context, Book book){
    Typography typography = FluentTheme.of(context).typography;
    double scale          = 1.0;
    return Container(
      width: 220,
      height: 40,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ) ,
      child: OutlinedButton(
        style: ButtonStyle(
          textStyle: ButtonState.all(TextStyle(color: Colors.green)),
          shape: ButtonState.all(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              )
          ),

        ),
        onPressed: () {
          // controller.gotoBookView(controller.book.bookId!);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
                flex: 1,
                child: Icon(
                  WiseBookIcon.uniF119,
                  color: Get.isDarkMode? Colors.white: Colors.green,
                  size: 20.0,
                )
            ),
            Flexible(
                flex: 1,
                child: Text('読', style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w500))
            ),
            Flexible(
                flex: 1,
                child: Text('む',style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w500))
            ),
          ],
        ),
      ),
    );
  }
}

