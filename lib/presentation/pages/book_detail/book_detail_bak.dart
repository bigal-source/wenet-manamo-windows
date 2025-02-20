// import 'dart:io';
// import 'package:path/path.dart' as p;
// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import '../../../app/utils/constants/strings.dart';
// import '../../controllers/book_detail/book_detail_controller.dart';
// import '../../../app/config/wise_book_icon_icons.dart';
// import '../../../app/utils/date_utils.dart';
// import '../../../data/models/book_info.dart';
//
// class BookDetailPage extends StatelessWidget{
//
//   BookDetailPage({Key? key, required this.bookItem, required this.script,}) : super(key: key);
//   var controller = Get.put(BookDetailController());
//   final Book bookItem;
//   final String script;
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldPage.scrollable(
//       header:  PageHeader( title: FittedBox( fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(bookItem.title!),),),
//       children: [
//         SingleChildScrollView(
//           child: tablet(context),
//         )
//       ],
//     );
//   }
//   Widget tablet(BuildContext context){
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;
//     Typography typography = FluentTheme.of(context).typography;
//     var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//     return Container(
//       margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
//       padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: w,
//             height: h/2,
//             margin: const EdgeInsets.only(top: 10, bottom: 10),
//             padding: const EdgeInsets.only(top: 30, bottom: 30),
//             decoration: BoxDecoration(
//               border: Border(
//                 top: BorderSide(color: Get.isDarkMode? Colors.grey[50]: Colors.grey[80], width: 0.1),
//                 bottom: BorderSide(color: Get.isDarkMode? Colors.grey[50]: Colors.grey[80], width: 0.1),
//               ),
//             ),
//             child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.topLeft,child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 //todo: book cover
//                 Container(
//                     padding: const EdgeInsets.all(10),
//                     height: isPortrait ? w/2.2 : h/2.8,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey[40]),
//                     ),
//                     child: Stack(
//                       children: [
//                         CachedNetworkImage(
//                           imageUrl: bookItem.image!,
//                           errorWidget: (context, url, error) => const Icon(FluentIcons.error),
//                         ),
//                         Positioned(
//                           top: 0,
//                           left: 0,
//                           right: 0,
//                           bottom: 0,
//                           child: SizedBox(
//                             height: w / 10,
//                             width: w / 3.3,
//                             child: Obx(() => controller.processing.value != 0 ? Padding(
//                               padding: const EdgeInsets.only(left: 0, right: 0, top: 8),
//                               child: LinearPercentIndicator(
//                                 animation: false,
//                                 lineHeight: 10.0,
//                                 animationDuration: 1500,
//                                 percent: (controller.processing.value *100)/100,
//                                 center: Text("${(controller.processing.value*100).round()}%", style: const TextStyle(color: Colors.white, fontSize: 10),),
//                                 barRadius: const Radius.circular(8),
//                                 progressColor: Colors.blue,
//                               ),
//                             ) : const Text('')),
//                           ),
//                         ),
//                       ],
//                     )
//                 ),
//                 //todo: space
//                 const SizedBox(width: 20,),
//                 //todo: info book + button
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     rowInfo(context,"カテゴリ",bookItem.categoryName!,1.0),
//                     rowInfo(context,"公開日",DateUtil.convertSqlDate(DateTime.parse(bookItem.date!)),1.0),
//                     rowInfo(context,"ページ数",bookItem.pages!,1.0),
//                     rowInfo(context,"サイズ","${bookItem.fileSize!} KB",1.0),
//                     rowInfo(context,"配信方法",bookItem.distType!,1.0),
//                     //todo: button view book
//                     Obx(() =>  controller.isOpenBook == false ? btnViewBook(context, bookItem) :  btnDisableStyle(context, bookItem)),
//                   ],
//                 ),
//               ],
//             ),),
//           ),
//           //todo: update
//           SizedBox(
//             // width: w,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('詳細',style: typography.title?.apply(fontSizeFactor: 1),
//                 ),
//                 SizedBox(
//                   height: w / 19,
//                   child: Text(controller.description),
//                 ),
//                 SizedBox(
//                   height: w / 19,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget rowInfo(BuildContext context, String label, String txtValue, double scale){
//     Typography typography = FluentTheme.of(context).typography;
//     double scale          = 1.0;
//     return  Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children:  [
//         Container(
//           width: 80,
//           padding: const EdgeInsets.all(4.0),
//           child: Text(label, style: typography.bodyLarge?.apply(fontSizeFactor: scale)),
//         ),
//         const SizedBox(width: 30,),
//         Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: Text(txtValue, overflow: TextOverflow.ellipsis, style: typography.bodyLarge?.apply(fontSizeFactor: scale)),
//         ),
//       ],
//     );
//   }
//   Widget btnViewBook(BuildContext context, Book book){
//     return Container(
//       width: 220,
//       height: 40,
//       margin: const EdgeInsets.only(top: 20),
//       child:  OutlinedButton(
//         style: ButtonStyle(
//           textStyle: ButtonState.all(TextStyle(color: Colors.green)),
//           shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
//           border: ButtonState.all(BorderSide(color: Get.isDarkMode? const Color.fromARGB(255, 75, 121, 229): Colors.green, width: 2)),
//         ),
//         onPressed: () async {
//           controller.openBook(context, bookItem.bookId!, 1);
//         } ,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Flexible(
//                 flex: 1,
//                 child: Icon(
//                   WiseBookIcon.uniF119,
//                   color: Get.isDarkMode? Colors.white: Colors.green,
//                   size: 20.0,
//                 )
//             ),
//             Flexible(
//                 flex: 1,
//                 child: Text('読', style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w500))
//             ),
//             Flexible(
//                 flex: 1,
//                 child: Text('む',style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w500))
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget btnDisableStyle(BuildContext context, Book book){
//     return Container(
//       width: 220,
//       height: 40,
//       margin: const EdgeInsets.only(top: 20),
//       child: OutlinedButton(
//         style: ButtonStyle(
//           textStyle: ButtonState.all(const TextStyle(color: Colors.black)),
//           shape: ButtonState.all(RoundedRectangleBorder( borderRadius: BorderRadius.circular(20))),
//         ),
//         onPressed: null,
//         child: const Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Flexible(
//                 flex: 1,
//                 child: Icon(
//                   WiseBookIcon.uniF119,
//                   color: Colors.grey,
//                   size: 20.0,
//                 )
//             ),
//             Flexible(
//                 flex: 1,
//                 child: Text('読', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500))
//             ),
//             Flexible(
//                 flex: 1,
//                 child: Text('む',style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500))
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
