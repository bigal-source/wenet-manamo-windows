import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:manamo/data/models/bookModel.dart';
import 'package:substring_highlight/substring_highlight.dart';
import '../../../app/config/wise_book_icon_icons.dart';
import '../../../app/extensions/components/color.dart';
import '../../../app/extensions/components/spacing.dart';
import '../../../app/services/authen_service.dart';
import '../../../app/utils/server.dart';
import '../../../data/models/search_view_model.dart';
import '../../controllers/search/search_controller.dart';
import '../../views/bodyTexView.dart';

class SearchView extends GetView<SearchBookController>  {
  SearchView({Key? key}) : super(key: key);
  final auth                 = Get.find<AuthenService>();
  double bookHeight = 0;
  double scale      = 1.0;
  @override
  Widget build(BuildContext context) {
    bookHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: fluent.Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() =>SizedBox(
                width: 130,
                child: fluent.ComboBox<String>(
                  value: controller.type,
                  items: controller.searchTypes.entries.map((e) {
                    return fluent.ComboBoxItem(
                      value: e.value,
                      child: Text(e.key),
                    );
                  }).toList(),
                  isExpanded: true,
                  onChanged: (v) => controller.type = v!,
                ),
              )),
              const SizedBox(width: 8),
              Obx(() => SizedBox(
                width: 130,
                child: fluent.ComboBox<String>(
                  value: controller.searchOption,
                  items: controller.searchOptions.entries.map((e) {
                    return fluent.ComboBoxItem(
                      value: e.value,
                      child: Text(e.key),
                    );
                  }).toList(),
                  isExpanded: true,
                  // disable search option when search type is normal (タイトル検索)
                  onChanged: controller.type == 'normal'
                      ? null
                      : (v) => controller.searchOption = v!,
                ),
              )),
              const SizedBox(width: 8),
              Expanded(
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width/2,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 8),
                            decoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(35.0),
                              border: Border.all(color: Colors.grey.shade300, width: 1),
                              boxShadow: const [
                                // BoxShadow(
                                //     offset: Offset(0, 0.2),
                                //     blurRadius: 2,
                                //     color: Colors.grey
                                // )
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    textInputAction: TextInputAction.go,
                                    controller: controller.searchText,
                                    decoration: InputDecoration(
                                        // hintText: "電子テキストを横断的に検索",
                                        hintText: "キーワードで検索",
                                        hintStyle: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black45),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.only(bottom: 16),
                                    ),
                                    onChanged: (value){
                                     controller.hasKeyWork = value.isNotEmpty ? true : false;
                                     controller.keyword    = value;
                                                                        },
                                    onSubmitted: (value){
                                      //todo: enter search
                                      controller.searchBooks(
                                        value,
                                        controller.type,
                                        controller.searchOption,
                                      );
                                    },
                                  ),
                                ),
                               clear(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: const BoxDecoration(
                              color: Colors.blueAccent, shape: BoxShape.circle),
                          child: InkWell(
                            onTap: () => {
                               //todo: button search
                               controller.searchBooks(
                                 controller.keyword,
                                 controller.type,
                                 controller.searchOption,
                               ),
                            },
                            onLongPress: () => {},
                            hoverColor: Colors.lightBlue,
                            child: search(),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Obx(() => controller.isLoading == false ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => controller.resultType == 'solr' ? list(): wrap(context)),
      ):const Center( child: Image( image: AssetImage('assets/images/loading.gif'),),)),
    );
  }
  Widget clear() {
    return Obx(() => controller.hasKeyWork == true? Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide( //                   
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        )
      ),
      child: IconButton(
        icon: const Icon(fluent.FluentIcons.clear, color: Colors.blue, size: 12,),
        onPressed: () => {
          controller.searchText.text = '',
        },
      ),
    ) : const Text(''));
  }
  Widget search() {
    return const Icon(
      fluent.FluentIcons.search,
      color: Colors.white,
      size: 12,
    );
  }
  Widget list(){
    return fluent.SingleChildScrollView(
      child: Column(
        children: [
          controller.bookSearch.total != null ? Container(
            height: 150,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16.0, top: 16.0, left: 4, right: 4),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xffDDDDDD),
                  blurRadius: 6.0,
                  spreadRadius: 2.0,
                  offset: Offset(0.0, 0.0),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                fluent.Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const BodyTextView(txtText: '次の検索結果を表示しています :', type: TextAlign.justify, scale: 1.0,),
                    BodyTextColorView(txtText: controller.resultKeyword, type: TextAlign.justify, scale: 1.0, color: Colors.red,),
                  ],
                ),
                fluent.Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BodyTextColorView(txtText: '全${controller.bookSearch.total}件', type: TextAlign.justify, scale: 1.0, color: Colors.grey,),
                  ],
                ),
              ],
            ),
          ) : const Text(''),
          controller.bookSearch.books != null ?  ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(0),
            itemCount: controller.bookSearch.books!.length,
            itemBuilder: (BuildContext context, int index) {
              return contentSolr(context, controller.bookSearch.books![index]);
            },
          ) : const Text(''),
        ],
      ),
    );
  }
  Widget wrap(BuildContext context){
    return fluent.SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          controller.bookSearch.total != null ? Container(
            height: 150,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16.0, top: 16.0, left: 4, right: 4),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xffDDDDDD),
                  blurRadius: 6.0,
                  spreadRadius: 2.0,
                  offset: Offset(0.0, 0.0),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                fluent.Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const BodyTextView(txtText: '次の検索結果を表示しています :', type: TextAlign.justify, scale: 1.0,),
                    BodyTextColorView(txtText: controller.resultKeyword, type: TextAlign.justify, scale: 1.0, color: Colors.red,),
                  ],
                ),
                fluent.Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BodyTextColorView(txtText: '全${controller.bookSearch.total}件', type: TextAlign.justify, scale: 1.0, color: Colors.grey,),
                  ],
                ),
              ],
            ),
          ) : const Text(''),
          controller.bookSearch.books != null ? Wrap(
            alignment: WrapAlignment.start,
            children: [
              for(int x = 0; x< controller.bookSearch.books!.length;x++)...[
                normalItem(context,controller.bookSearch.books![x]),
                // you can add widget here as well
              ],
            ],
          ) : const Text('')
        ],
      ),
    );
  }
  Row contentSolr(BuildContext context, BookSearchViewModel book){
    fluent.Typography typography = fluent.FluentTheme.of(context).typography;
    double ch = MediaQuery.of(context).size.height/3;
    double cw = ch*0.7;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        //todo: book cover
        Container(
          width: cw,
          height:ch,
          padding: const EdgeInsets.all(10),
          margin : const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.3 ),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(book.imageL.toString()),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
        ),
        //todo: space
        const SizedBox(width: 20,),
        //todo: info book + button
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5,),
              Text(book.title.toString(), style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
              Divider(
                color: backGroundPrimary, height: 16, thickness: 2,),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 6,
                    child: SubstringHighlight(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      textAlign: fluent.TextAlign.justify,
                      text: book.highlight.toString().replaceAll('<em>' , '').replaceAll('</em>', ''),
                      textStyle: typography.body!.apply(fontSizeFactor: 1.0),
                      term: controller.resultKeyword,
                      textStyleHighlight: typography.body!.apply(fontSizeFactor: 1.0, color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Container(
                      padding: padding4,
                      width: MediaQuery.of(context).size.width / 2,
                      child: BodyStrongTextView(txtText: "発行日: ${(book.date)}", type: TextAlign.justify, scale: 1.0,),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                        padding: padding4,
                        width: MediaQuery.of(context).size.width,
                        child: const BodyStrongTextView(txtText: "サイズ :", type: TextAlign.justify, scale: 1.0,)
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Container(
                      padding: padding4,
                      width: MediaQuery.of(context).size.width / 2,
                      child: BodyStrongTextView(txtText: "ページ数 : ${book.page}/${book.pages}", type: TextAlign.justify, scale: 1.0,),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                        padding: padding4,
                        width: MediaQuery.of(context).size.width,
                        child: const BodyStrongTextView(txtText: "配信方法 : ハイブリッド", type: TextAlign.justify, scale: 1.0,)
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width/8,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ) ,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    side: BorderSide(color: Get.isDarkMode? const Color.fromARGB(255, 75, 121, 229): Colors.green, width: 2),
                  ),
                  onPressed: () async {
                    String url = "$api/html/$corpname/${book.bookId!}/?htp=${controller.resultKeyword}#${book.searchpage!}";
                    controller.pageSearch  = book.searchpage!;
                    controller.openBook(context, book.bookId!, book.searchpage!,url, book.title!);},
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
                      const Flexible(
                          flex: 1,
                          child: Text('読', style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w500))
                      ),
                      const Flexible(
                          flex: 1,
                          child: Text('む',style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w500))
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
  fluent.GestureDetector normalItem(BuildContext context, BookSearchViewModel book){
    double ch = MediaQuery.of(context).size.height/3;
    double cw = ch*0.5;
    return fluent.GestureDetector(
        onTap: () {
          String url = "$api/html/$corpname/${book.bookId!}/#1";
          // controller.openBook(book.bookId!,url);
          controller.openBook(context, book.bookId!, 1, url, book.title!);
        },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
        width: cw,
        // same visible height as home item (home ListView: h/3 - padding 20 - margin 20)
        height: ch - 40,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: fluent.Colors.grey[20], width: 0.3 ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            // image keeps its own height (title right below like home), shrinks only when needed to avoid overflow
            Flexible(
              child: Image.network(
                book.imageL.toString(),
                width: cw,
                alignment: Alignment.topCenter,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(fluent.FluentIcons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 8),
              child: Text(book.title ?? '',overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 12.0, color: fluent.Colors.grey[160])),
            ),
          ],
        ),
      ),
    );
  }
}
