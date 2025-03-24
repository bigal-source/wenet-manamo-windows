import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../app/config/wise_book_icon_icons.dart';
import '../../../app/extensions/components/spacing.dart';
import '../../../app/extensions/components/text.dart';
import '../../../app/extensions/components/typography.dart';
import '../../../app/extensions/drap_and_drop/color.dart';
import '../../../app/extensions/drap_and_drop/drag_and_drop_list_expansion.dart';
import '../../../app/extensions/drap_and_drop/drag_and_drop_lists.dart';
import '../../../app/services/authen_service.dart';
import '../../../data/models/bookModel.dart';
import '../../controllers/book_shelf/book_shelf_controller.dart';
import '../../views/bodyTexView.dart';
class BookShelf extends GetView<BookShelfController> {
  BookShelf({Key? key}) : super(key: key);
  final scaffoldHomeKey = GlobalKey<ScaffoldState>();
  final AuthenService auth = Get.put(AuthenService());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
      return true;
    },
        child: Scaffold(
          key: scaffoldHomeKey,
          appBar: AppBar(
            elevation: 0.2,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title:  fluent.Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed:() async {
                      controller.txtCategory.text = "カテゴリ ${controller.cateDownloads.length + 1}";
                      await controller.createModalCategory();
                      /// WNT_20241004 (7)
                      if (controller.isEditCate.value) {
                        controller.isEditCate.value = false;
                      }
                    },
                    icon: const Icon(fluent.FluentIcons.new_folder),
                    label: const Text("カテゴリ追加"),
                  ),
                ),
                fluent.Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(() => controller.hasChecked.value ? TextButton.icon(
                      onPressed:() async {
                        controller.cleanChecked();
                      },
                      icon: const Icon(fluent.FluentIcons.task_add, size: 16,),
                      label: const Text("Uncheck",style: TextStyle(fontSize: 14, fontWeight:FontWeight.w200 ),),
                    ): const SizedBox()),
                    Obx(() => TextButton.icon(
                      onPressed:() async {
                        controller.editBook();
                      },
                      //FluentIcons.task_add, FluentIcons.remove_content
                      // ,FluentIcons.page_remove,FluentIcons.multi_select, FluentIcons.delete
                      icon:  Icon(!controller.isEdit.value
                          ? fluent.FluentIcons.remove_content
                          : (controller.isDelete.value && controller.isEdit.value)
                          ? fluent.FluentIcons.delete
                          : fluent.FluentIcons.task_add, size: 16,),
                      label: Text(!controller.isEdit.value
                          ? "削除"
                          :controller.isDelete.value && controller.isEdit.value
                          ? "実行"
                          : "選択",
                        style: const TextStyle(fontSize: 14, fontWeight:FontWeight.w200 ),),
                    )),
                    IconButton(
                      onPressed: (){
                        controller.isDetail = !controller.isDetail;
                      },
                      icon: Obx(() => Icon(controller.isDetail
                          ? fluent.FluentIcons.open_with_mirrored
                          : fluent.FluentIcons.p_b_i_home_layout_default, size: 20,color: Colors.black87,)),
                      // label: const Text(""),
                    ),
                  ],
                ),
              ],
            ),// Status bar color
          ),
          body: SafeArea(
            child: fluent.Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Obx(() => DragAndDropLists(
                      children: List.generate(controller.cateDownloads.length, (index) => _buildList(context, index, controller.cateDownloads[index])),
                      onItemReorder: _onItemReorder,
                      onListReorder: _onListReorder,
                      addLastItemTargetHeightToTop: false,
                      listDragHandle: const DragHandle(
                        verticalAlignment: DragHandleVerticalAlignment.top,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20,right: 20),
                          child: Icon(
                            Icons.menu,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      constrainDraggingAxis:false,
                      // listWidth: MediaQuery.of(context).size.width,
                      listDecoration: BoxDecoration(
                        color: backGroundPrimary,
                        borderRadius: const BorderRadius.all( Radius.circular(7.0)),
                      ),
                      contentsWhenEmpty: Container(
                        height: MediaQuery.of(context).size.height/3,
                        decoration: const BoxDecoration(color: Colors.transparent) ,
                        child:  Center(child: auth.device.value == 'phone' ? const Text("No item.", style: TextStyle(fontSize: 16),) : const Text("No item.", style: TextStyle(fontSize: 25),),),
                      ),
                      listPadding: const EdgeInsets.only(top: 2, bottom: 2, right: 2, left: 2),
                      listGhost: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 50.0),
                        child: Center(
                          child: Icon(Icons.add_box, color: Colors.blue,),
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  _buildList(BuildContext context, int cateIndex, CategoryDownLoad item) {
    return DragAndDropListExpansion(
      isList: !controller.isDetail,
      initiallyExpanded: item.open! == 1 ? true : false,
      onExpansionChanged:(value) async => {
        print("DragAndDropListExpansion $value"),
        item.open = value == true ? 1: 0,
        await controller.updateCategoryOpen(item),
      },
      contentsWhenEmpty: const Center(child: Text("", style: TextStyle(fontSize: 16, color: Colors.white),),),
      backgroundColor: backGroundPrimary,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //todo: title
          GestureDetector(
            onLongPress: () => {
              controller.txtCategory.text = item.name!,
              controller.cateSelectedIdx = cateIndex,
              controller.isLongPress = true,
              print("onLongPress"),
            },
            onLongPressCancel: () async => {
              if(controller.isLongPress){
                controller.isLongPress = false,
                await controller.updateCategory(item),
              }
            },
            child: Transform.translate(
              offset: const Offset(-20, 0),
              child: categoryTitle(context,cateIndex,item),
              // child: inputCategory(context, cateIndex, item),
            ),
          ),
          //todo: icon delete, edit cate
          fluent.Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /// WNT_20241004 (1)
              (controller.isEditCate.value && controller.cateSelectedIdx == cateIndex && item.id! != 1)
                  ? GestureDetector(
                      onTap: () {
                        if (item.books!.isEmpty && item.id! != 1) {
                          controller.deleteCategory(item);
                          /// WNT_20241004 (2)
                          controller.isEditCate.value = false;
                        }
                      },
                      child: Transform.translate(
                        offset: const Offset(0, 0),
                        child: const SizedBox(
                          height: 40,
                          width: 40,
                          child: Icon(fluent.FluentIcons.delete, size: 20,),
                        ),
                      ),
              )
                  : const SizedBox(),
              //-- edit cate
              GestureDetector(
                onTap: () async {
                  if (kDebugMode) {
                    print("Item ${item.isDefault}");
                  }
                  controller.isEditCate.value = !controller.isEditCate.value;
                  if(controller.isEditCate.value){
                    controller.txtCategory.text = item.name!;
                    controller.cateSelectedIdx = cateIndex;
                  }

                  //todo: update name category
                  if(controller.isSaveCate.value){
                    await controller.updateCategory(item);
                  }

                },
                child: Transform.translate(
                  offset: const Offset(0, 0),
                  child:  SizedBox(
                    height: 40,
                    width: 40,
                    child: (controller.isEditCate.value && controller.cateSelectedIdx == cateIndex)
                        ? const Icon( fluent.FluentIcons.save, size: 20,)
                        : const Icon( fluent.FluentIcons.field_not_changed, size: 20,),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      /// WNT_20241004 (3)
      leading: Icon(item.open == 1 ? fluent.FluentIcons.flick_up : fluent.FluentIcons.flick_left),
      trailing: const Icon(fluent.FluentIcons.sort),
      children: List.generate(item.books!.length, (index) => controller.isDetail == false ?_buildItem(context,cateIndex, index, item.books![index]) : _buildItemDetail(context,cateIndex, index, item.books![index])),
      listKey: ObjectKey(item),
    );
  }
  _buildItem(BuildContext context, int cateIndex, int listIndex, Bshelf book) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return DragAndDropItem(
      /// WNT_20241004 (4)
      feedbackWidget: fluent.Center(
        child: Image.file(
          File('${controller.directoryPath}/web/${book.bookAppId}/thumb.jpg'),
          opacity: const AlwaysStoppedAnimation(0.5),
        ),
      ),
      child: bookThumbPhone(context,cateIndex,listIndex,book),
    );
  }
  _buildItemDetail(BuildContext context, int cateIndex, int listIndex, Bshelf book) {
    return DragAndDropItem(
      child: Obx(() => InkWell(
        onTap: () async {
          if(controller.isEdit.value){
            await controller.checkedBookCate(cateIndex,listIndex,book);
            if (kDebugMode) {
            }
          }else{
            // controller.gotoBookView(book);
            book.selected = '1';
            String url = 'http://127.0.0.1:8088/?bookId=${book.bookAppId}&headx=${auth.headerX}&id=${auth.idx}#${book.lastPage}';
            controller.openBook(context,book,url);
          }
        },
        child: bookDetailPhone(context,cateIndex,listIndex,book),
      )),
    );
  }
  _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex,int newListIndex) {

    CategoryDownLoad cateNewItem = controller.cateDownloads[newListIndex];
    Bshelf bookUpdate = controller.cateDownloads[oldListIndex].books![oldItemIndex];
    bookUpdate.cateId = cateNewItem.id;
    var movedItem = controller.cateDownloads[oldListIndex].books!.removeAt(oldItemIndex);
    controller.cateDownloads[newListIndex].books!.insert(newItemIndex, movedItem);
    var listBook  =  controller.cateDownloads[newListIndex].books;
    var newCateId =  cateNewItem.id;
    controller.updateBookPosition(listBook!,newCateId!).then((value) => {});
  }
  _onListReorder(int oldListIndex, int newListIndex) {
    var movedList = controller.cateDownloads.removeAt(oldListIndex);
    controller.cateDownloads.insert(newListIndex, movedList);
    var newPosition = controller.cateDownloads[newListIndex];
    newPosition.sort= newListIndex;
    controller.sortCategory();

  }

  //1. todo: category
  Widget categoryShelfBar() {
    return Container(
      height: 70,
      margin: marginTop20,
      padding: paddingLeft8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // todo: add, remove category action
          auth.device.value == 'phone' ? Flexible(
              flex: 3,
              child: InkWell(
                onTap: () {
                  controller.resetBshelfPage();
                  controller.pageContentcontroller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: const Cubic(0.35, 0.91, 0.33, 0.97));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //todo: add category
                    Flexible(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: () async {
                          controller.txtCategory.text = "カテゴリ ${controller.cateDownloads.length + 1}";
                          var addCate = await controller.createModalCategory();
                          if (kDebugMode) {
                          }
                        },
                        style: elevatedButtonMobileStyle,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('カテゴリ追加', style: TextStyle(fontSize: 16),),
                            // <-- Text
                            SizedBox(width: 10,),
                            Icon(Icons.add, size: 20.0,),
                          ],
                        ), // <-- Text

                      ),
                    ),
                  ],
                ),
              )
          ) : Flexible(
              flex: 3,
              child: InkWell(
                onTap: () {
                  controller.resetBshelfPage();
                  controller.pageContentcontroller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: const Cubic(0.35, 0.91, 0.33, 0.97));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //todo: add category
                    Flexible(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: () async {
                          controller.txtCategory.text = "カテゴリ ${controller.cateDownloads.length + 1}";
                          var addCate = await controller.createModalCategory();
                          if (kDebugMode) {
                          }
                        },
                        style: elevatedButtonTabletStyle,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('カテゴリ追加', style: TextStyle(fontSize: 18),),
                            // <-- Text
                            SizedBox(width: 10,),
                            Icon(Icons.add, size: 30.0,),
                          ],
                        ), // <-- Text

                      ),
                    ),
                  ],
                ),
              )
          ),
          // todo: delete, detail  book
          Flexible(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //todo: delete book
                Obx(() => auth.device.value == 'phone' ? Container(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                      onPressed: () {
                        if(controller.hasChecked.value == false){

                        }
                        if(controller.isEdit.value == true && controller.hasChecked.value == true){
                          Get.dialog(
                            CupertinoAlertDialog(
                              title:  const Padding(padding: EdgeInsets.only(bottom: 8), child: Text("選択したブックを削除します"),),
                              content: const Text("本当によろしいですか。"),
                              actions: [
                                CupertinoDialogAction(
                                  onPressed: () async {
                                    Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                                    controller.resetEditBook();
                                  },
                                  isDefaultAction: true,
                                  child: const Text("いいえ"),
                                ),
                                CupertinoDialogAction(
                                  onPressed: () async {
                                    Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                                    controller.deleteBooks().then((value) => {
                                    });
                                  },
                                  isDefaultAction: true,
                                  child: const Text("はい"),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: elevatedButtonPrimaryMobileStyle,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children:  [
                          const Icon(Icons.delete, size: 30,),
                          const SizedBox(width: 10,),
                          Text( (controller.isEdit.value == true && controller.hasChecked.value == true) ?"実行"
                              :(controller.isEdit.value == true && controller.hasChecked.value == false) ?"削除" : "削除"), // <-- Text
                        ],
                      ) // <-- Text

                  ),
                ) : Container(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                      onPressed: () {
                        if(controller.hasChecked.value == false){

                        }
                        if(controller.isEdit.value == true && controller.hasChecked.value == true){
                          Get.dialog(
                            CupertinoAlertDialog(
                              title:  const Padding(padding: EdgeInsets.only(bottom: 8), child: Text("選択したブックを削除します"),),
                              content: const Text("本当によろしいですか。"),
                              actions: [
                                CupertinoDialogAction(
                                  onPressed: () async {
                                    Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                                    controller.resetEditBook();
                                  },
                                  isDefaultAction: true,
                                  child: const Text("いいえ"),
                                ),
                                CupertinoDialogAction(
                                  onPressed: () async {
                                    Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                                    controller.deleteBooks().then((value) => {
                                    });
                                  },
                                  isDefaultAction: true,
                                  child: const Text("はい"),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: elevatedButtonPrimaryStyle,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children:  [
                          const Icon(Icons.delete, size: 30,),
                          const SizedBox(width: 10,),
                          Text( (controller.isEdit.value == true && controller.hasChecked.value == true)
                              ?"実行" :(controller.isEdit.value == true && controller.hasChecked.value == false)
                              ?"削除" : "削除"), // <-- Text
                        ],
                      ) // <-- Text

                  ),
                )),
                const SizedBox(width: 16,),
                // on/off edit - del category in phone
                InkWell(
                  onTap: () {
                    controller.isDetail = !controller.isDetail;
                  },
                  child: auth.device.value == 'phone' ?  Container(
                    height: 50,
                    padding: const EdgeInsets.only(right: 0),
                    child: Obx(() =>  Icon( // <-- Icon
                      controller.isDetail ? Icons.assignment: Icons.apps,
                      size: 50.0,
                      color: Colors.blueAccent,
                    )),
                  ) :Container(
                    height: 70,
                    padding: const EdgeInsets.only(right: 8) ,
                    child: Obx(() =>  Icon( // <-- Icon
                      controller.isDetail ? Icons.assignment: Icons.apps,
                      size: 60.0,
                      color: Colors.blueAccent,
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget inputCategory(BuildContext context, int cateIndex, CategoryDownLoad item) {
    return Obx(() =>(controller.isLongPress && controller.cateSelectedIdx == cateIndex)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width/3,
                margin: const EdgeInsets.only(left: 0, right: 8,bottom: 8, top: 4),
                padding: const EdgeInsets.only(left: 0, right:0,bottom: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child:  TextField(
                  controller: controller.txtCategory,
                  style: subTitleMobileStyle,
                  decoration: InputDecoration(
                    hintText: item.name!,
                    hintStyle: subTitleMobieStyle,
                    contentPadding: const EdgeInsets.only(right: 8, left: 8),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    suffixText: "",
                    suffixStyle: const TextStyle(color: Colors.green),
                    labelStyle: const TextStyle(fontSize: 15,fontStyle: FontStyle.normal),
                  ),
                  autofocus: true,
                  maxLines: 1,
                  onSubmitted: (value) async {
                    controller.isLongPress = false;
                    await controller.updateCategory(item);
                  },
                  // onTapOutside:(value) async {
                  //   controller.isLongPress = false;
                  //   await controller.updateCategory(item);
                  // }
                ),
              ),
              IconButton(
                onPressed: (){
                  controller.isDetail = !controller.isDetail;
                },
                icon: Obx(() => Icon(controller.isDetail
                    ? fluent.FluentIcons.bulleted_list2
                    : fluent.FluentIcons.grid_view_medium, size: 14,color: Colors.black87,)),
              ),
              IconButton(
                onPressed: (){
                  controller.isDetail = !controller.isDetail;
                },
                icon: Obx(() => Icon(controller.isDetail
                    ? fluent.FluentIcons.bulleted_list2
                    : fluent.FluentIcons.grid_view_medium, size: 14,color: Colors.black87,)),
              )
              // item.id != 1 ? fluent.SizedBox(
              //     width: 100,
              //     child: ElevatedButton(
              //       onPressed: () {
              //         if(item.books!.isEmpty && item.id! != 1){ // <> total category
              //           controller.deleteCategory(item);
              //         }else{
              //           Get.dialog(
              //             CupertinoAlertDialog(
              //               title:  const Padding(padding: EdgeInsets.only(bottom: 8), child: Text("カテゴリ内にブックが残っています"),),
              //               content: const Text("ブックを別のカテゴリに移動、\n もしくはブックを削除してから、\nカテゴリの削除を行ってください。"),
              //               actions: [
              //                 CupertinoDialogAction(
              //                   onPressed: () async {
              //                     Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
              //                   },
              //                   isDefaultAction: true,
              //                   child: const Text("OK"),
              //                 ),
              //               ],
              //             ),
              //           );
              //         }
              //       },
              //       style: ElevatedButton.styleFrom(
              //           side: const BorderSide(width: 2.5, color: Colors.white,),
              //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              //           primary: backGroundPrimary,
              //           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              //           textStyle:const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              //       child: const Row(
              //         mainAxisSize: MainAxisSize.min,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [ // <-- Text
              //           Expanded(
              //             flex: 4,
              //             child: Text('削除', style: TextStyle(fontSize: 16),),
              //           ),
              //           Expanded(
              //             flex: 2,
              //             child: Icon( // <-- Icon
              //               Icons.remove_circle,
              //               size: 20.0,
              //             ),
              //           )
              //         ],
              //       ),// <-- Text
              //
              //     )
              // ) : const SizedBox(),
            ],
      ) :  Text('${item.name}', style: const TextStyle(fontSize: 16),));
  }
  Widget categoryTitle(BuildContext context, int cateIndex, CategoryDownLoad item) {
    return Obx(() => (controller.isEditCate.value && controller.cateSelectedIdx == cateIndex)
        ? Container(
          height: 40,
          width: MediaQuery.of(context).size.width/3,
          margin: const EdgeInsets.only(left: 0, right: 8,bottom: 8, top: 4),
          padding: const EdgeInsets.only(left: 0, right:0,bottom: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child:  TextField(
            controller: controller.txtCategory,
            style: subTitleMobileStyle,
            decoration: InputDecoration(
              hintText: item.name!,
              hintStyle: subTitleMobieStyle,
              contentPadding: const EdgeInsets.only(right: 8, left: 8),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              suffixText: "",
              suffixStyle: const TextStyle(color: Colors.green),
              labelStyle: const TextStyle(fontSize: 15,fontStyle: FontStyle.normal),
            ),
            autofocus: true,
            maxLines: 1,
            onChanged: (value){
              controller.isSaveCate.value = true;
            },
            onSubmitted: (value) async {
              await controller.updateCategory(item);
            },
          ),
        )
        : Text('${item.name}', style: const TextStyle(fontSize: 16),)
    );
  }
  Row editCategoryName(BuildContext context, int cateIndex, CategoryDownLoad item){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: 40,
          width: MediaQuery.of(context).size.width/3,
          margin: const EdgeInsets.only(left: 0, right: 8,bottom: 8, top: 4),
          padding: const EdgeInsets.only(left: 0, right:0,bottom: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child:  TextField(
            controller: controller.txtCategory,
            style: subTitleMobileStyle,
            decoration: InputDecoration(
              hintText: item.name!,
              hintStyle: subTitleMobieStyle,
              contentPadding: const EdgeInsets.only(right: 8, left: 8),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              suffixText: "",
              suffixStyle: const TextStyle(color: Colors.green),
              labelStyle: const TextStyle(fontSize: 15,fontStyle: FontStyle.normal),
            ),
            autofocus: true,
            maxLines: 1,
            onSubmitted: (value) async {
              controller.isLongPress = false;
              await controller.updateCategory(item);
            },
            // onTapOutside:(value) async {
            //   controller.isLongPress = false;
            //   await controller.updateCategory(item);
            // }
          ),
        ),
        // item.id != 1 ? fluent.SizedBox(
        //     width: 100,
        //     child: ElevatedButton(
        //       onPressed: () {
        //         if(item.books!.isEmpty && item.id! != 1){ // <> total category
        //           controller.deleteCategory(item);
        //         }else{
        //           Get.dialog(
        //             CupertinoAlertDialog(
        //               title:  const Padding(padding: EdgeInsets.only(bottom: 8), child: Text("カテゴリ内にブックが残っています"),),
        //               content: const Text("ブックを別のカテゴリに移動、\n もしくはブックを削除してから、\nカテゴリの削除を行ってください。"),
        //               actions: [
        //                 CupertinoDialogAction(
        //                   onPressed: () async {
        //                     Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
        //                   },
        //                   isDefaultAction: true,
        //                   child: const Text("OK"),
        //                 ),
        //               ],
        //             ),
        //           );
        //         }
        //       },
        //       style: ElevatedButton.styleFrom(
        //           side: const BorderSide(width: 2.5, color: Colors.white,),
        //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        //           primary: backGroundPrimary,
        //           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        //           textStyle:const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        //       child: const Row(
        //         mainAxisSize: MainAxisSize.min,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [ // <-- Text
        //           Expanded(
        //             flex: 4,
        //             child: Text('削除', style: TextStyle(fontSize: 16),),
        //           ),
        //           Expanded(
        //             flex: 2,
        //             child: Icon( // <-- Icon
        //               Icons.remove_circle,
        //               size: 20.0,
        //             ),
        //           )
        //         ],
        //       ),// <-- Text
        //
        //     )
        // ) : const SizedBox(),
      ],
    );
  }
  Row titleCategory(BuildContext context, int cateIndex, CategoryDownLoad item){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('${item.name}', style: const TextStyle(fontSize: 16),),
        GestureDetector(
          onTap: (){
            print("1111");
          },
          child:  Transform.translate(
            offset: const Offset(25, 0),
            child: IconButton(
              onPressed: (){
                print("edit category");
                controller.isDetail = !controller.isDetail;
              },
              //FluentIcons.field_changed,
              // FluentIcons.insert_signature_line,FluentIcons.insert_text_box
              icon: Obx(() => Icon(controller.isDetail
                  ? fluent.FluentIcons.field_not_changed
                  : fluent.FluentIcons.remove_content, size: 20,color: Colors.black87,)),
            ),
          ),
        )
      ],
    );
  }
  fluent.SizedBox bookThumbPhone(BuildContext context, int cateIndex, int listIndex, Bshelf book){
    return SizedBox(
      height: MediaQuery.of(context).size.width/5.8,
      child: Obx(() => InkWell(
        onTap: () async {
          controller.onTapBookID = book.bookAppId!;
          if(controller.isEdit.isFalse) {
            book.selected = '1';
            String url = 'http://127.0.0.1:8088/?bookId=${book.bookAppId}&headx=${auth.headerX}&id=${auth.idx}#${book.lastPage}';
            print(url);
            controller.openBook(context,book,url);
          }else{
            printInfo(info:"Check book");
            controller.actionBook(cateIndex,listIndex,book);
          }
        },
        child: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    image: book.isDownload == 1 ? DecorationImage(
                        image: FileImage(File('${controller.directoryPath}/web/${book.bookAppId}/thumb.jpg')),
                        fit: BoxFit.fill
                    ) : DecorationImage(
                      image: NetworkImage(book.thumbPath.toString()),
                    ),
                  ),
                  child: Center(
                    child: (controller.loading && book.selected == "1" && controller.onTapBookID == book.bookAppId!)
                        ? const fluent.ProgressRing()
                        : const SizedBox(),
                  )
              ),
            ),
            //todo: icon check
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.only(top: 12, left: 8),
                child: (book.selected == "1" && controller.isEdit.value == true && controller.hasChecked.value)
                    ? const Icon(Icons.check_circle, color: Colors.green, size: 30.0,)
                    :(controller.isEdit.value == true)
                    ? const Icon(Icons.check_circle, color: Colors.grey, size: 30.0,)
                    : const Text(""),
              ),
            ),
          ],
        ),
      )),
    ) ;
  }
  Container bookDetailPhone(BuildContext context, int cateIndex, int listIndex, Bshelf book){
    double ch = MediaQuery.of(context).size.height/2.8;
    double cw = ch*0.7;
    return fluent.Container(
      decoration: const BoxDecoration(
          color: Colors.white,
      ),
      height: ch,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //todo: checked button and image
          Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    width: cw,
                    margin: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      image: book.isDownload == 1 ? DecorationImage(
                          image: FileImage(File('${controller.directoryPath}/web/${book.bookAppId}/thumb.jpg')),
                          fit: BoxFit.fill
                      ) : DecorationImage(
                        image: NetworkImage(book.thumbPath.toString()),
                      ),
                      border: Border.all(color: Colors.white70, width: 0.3 ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: (controller.loading && book.selected == "1")
                          ? const fluent.ProgressRing()
                          : const SizedBox(),
                    )
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.only(top: 6, left: 6),
                  child: (book.selected == "1" && controller.isEdit.value == true && controller.hasChecked.value)
                      ? const Icon(Icons.check_circle, color: Colors.green, size: 30.0,)
                      :(controller.isEdit.value == true)
                      ? const Icon(Icons.check_circle, color: Colors.grey, size: 30.0,)
                      : const Text(""),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16,),
          //todo: info books
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 6,
                      child: BodyStrongTextView(txtText: "出版社 : 株式会社ウイネット", type: TextAlign.justify, scale: 1.0,),
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
                        child: const BodyStrongTextView(txtText: "著者:", type: TextAlign.justify, scale: 1.0,),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(
                          padding: padding4,
                          width: MediaQuery.of(context).size.width,
                          child:  const BodyStrongTextView(txtText: "カテゴリ : Microsoft office ", type: TextAlign.justify, scale: 1.0,)
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
                        child: const BodyStrongTextView(txtText: "発行日: 2019/04/19:", type: TextAlign.justify, scale: 1.0,),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(
                          padding: padding4,
                          width: MediaQuery.of(context).size.width,
                          child: BodyStrongTextView(txtText: "サイズ : ${book.size}", type: TextAlign.justify, scale: 1.0,)
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
                        child: BodyStrongTextView(txtText: "ページ数 : ${book.pages}", type: TextAlign.justify, scale: 1.0,),
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
                      if(controller.isEdit.isFalse) {
                        book.selected = '1';
                        printInfo(info:"Open");
                        String url = 'http://127.0.0.1:8088/?bookId=${book.bookAppId}&headx=${auth.headerX}&id=${auth.idx}#${book.lastPage}';
                        controller.openBook(context,book,url);
                      }
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
      ),
    );
  }


  //2 todo: dialog
  void showContentDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => fluent.ContentDialog(
        title: const Text('Delete file permanently?'),
        content: const Text(
          'If you delete this file, you won\'t be able to recover it. Do you want to delete it?',
        ),
        actions: [
          fluent.Button(
            child: const Text('Delete'),
            onPressed: () {
              Navigator.pop(context, 'User deleted file');
              // Delete file here
            },
          ),
          FilledButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, 'User canceled dialog'),
          ),
        ],
      ),
    );
  }
}