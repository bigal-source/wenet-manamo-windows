
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/book_info.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CatalogDetailView extends StatelessWidget {
  CatalogDetailView({Key? key, required this.cateBook}) : super(key: key);
  final BookCate cateBook;
  double wt         = 0;
  double bookHeight = 0;
  double scale      = 1.0;
  @override
  Widget build(BuildContext context) {
    wt       = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: SystemUiOverlay.values);
    return ScaffoldPage.withPadding(
      header:  PageHeader(
        title: Text("カテゴリ > ${cateBook.categoryName}"),
      ),
      content:  bookData(context),
    );
  }
  Widget bookData (BuildContext context){
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    double bookHeight = h/3;
    return SingleChildScrollView(
      child:  Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        children: [
          for(var book in cateBook.listBook! )  Container(
            width: (bookHeight*0.5),
            height: (bookHeight - 40),
            margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
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
          ),
        ],),
    );
  }
  //todo: book item in phone
  Widget bookItemPhone(BuildContext context, Book book){
    return  SizedBox(
      width: MediaQuery.of(context).size.width/5,
      height: MediaQuery.of(context).size.height/4,
      // margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
      // decoration: BoxDecoration(
      //   color: Colors.blue,
      //   border: Border.all(color: Colors.grey[20], width: 0.3 ),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.3),
      //       spreadRadius: 5,
      //       blurRadius: 7,
      //       offset: const Offset(0, 3), // changes position of shadow
      //     ),
      //   ],
      // ),
      child: GestureDetector(
        onTap: (){
          context.push('/book-detail',extra: book,);
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
