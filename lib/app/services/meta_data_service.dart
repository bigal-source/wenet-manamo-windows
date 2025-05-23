import 'dart:convert';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as getX ;
import '../../data/datasources/local/db_help.dart';
import '../utils/server.dart';
import 'authen_service.dart';
import 'base_service.dart';
import 'package:dio/dio.dart';


class MetaDataService extends BaseService {
  final auth = getX.Get.find<AuthenService>();

  Future<bool> checkMetaData() async {
    bool result  = false;
    auth.syncing.value = true;
    var resp     = await SQLHelper.getMetaDataUpdate();
    if (kDebugMode) {
      print("-------------------------111------------------");
    }
    if(resp.isNotEmpty){
      result     = true;
      var books  = [];
      var metas  = [];
      var bookId = resp[0].bookAppId;
      var book       = {};
      String? bookmark   = '';
      for (var item in resp) {

        if(item.bookAppId != bookId){
          book['bookId']  = bookId;
          book['datas']   = metas;
          book['bookmark']= bookmark;
          books.add(book);
          book           = {};
          bookmark       = '';
          metas          = [];
          bookId         = item.bookAppId;
        }

        if(item.page! > 0){
          var obj         = {"page": item.page!,"dataobj":jsonDecode(item.dataObj!)};
          metas.add(obj);
        }else{
          bookmark = item.dataObj;
        }

      }
      books.add({'bookId': bookId, 'datas': metas,'bookmark':bookmark});
      for(var bookUpdate in books){
        bool data = await overrideDataServer(auth.idx.value,bookUpdate);
        bool bookmark = await overrideBookmarkServer(auth.idx.value,bookUpdate);
        if (data && bookmark) {
          await SQLHelper.updateMetaDataLocal(bookUpdate);
        }
        // List responses = await Future.wait([overrideDataServer(auth.idx.value,bookUpdate), overrideBookmarkServer(auth.idx.value,bookUpdate)]);
        // if(responses.isNotEmpty){
        //   SQLHelper.updateMetaDataLocal(bookUpdate);
        //   if (kDebugMode) {
        //     print(bookUpdate["bookId"]);
        //     print("update Data = ${responses[0]} update bookmark = ${responses[1]}".toString());
        //   }
        // }

      }
    }else{printInfo(info: "not update");}
    auth.syncing.value = false;
    return result;
  }
  Future<bool> overrideDataServer(String idx, Map bookUpdate) async {
    var result = false;
    BaseOptions options = BaseOptions(
        baseUrl: '${host}wiseapi/l/v1/',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(minutes: 1), // 60 seconds
        receiveTimeout: const Duration(minutes: 1), // 60 seconds
        headers       : auth.corpId.value == 'manamo' ? headersManamo : headers
    );
    var dio = Dio(options);
    var formData = FormData.fromMap({
      'idx'        : idx,
      'book_id'    : bookUpdate["bookId"],
      'annotation' : jsonEncode(bookUpdate["datas"]),
    });
    Response response = await dio.post('/syncAnnotFromApp.json',data: formData);
    if (response.data['result'].toString() == 'true') {
      await SQLHelper.saveWBookSynchroTime(bookUpdate['bookId'], auth.userId.value, idx, response.data['syncro_at']);
      auth.latestSyncTimeOnline.value = response.data['syncro_at'];
      result = true;
    }else{
      result = false;
    }
    return result;
  }
  Future<bool> overrideBookmarkServer(String idx, Map bookUpdate) async {
    var result = false;
    if(bookUpdate["bookmark"].length == 0){
      return true;
    }
    BaseOptions options = BaseOptions(
        baseUrl: '${host}wiseapi/l/v1/',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(minutes: 1), // 60 seconds
        receiveTimeout: const Duration(minutes: 1), // 60 seconds
        headers       : auth.corpId.value == 'manamo' ? headersManamo : headers
    );
    var dio = Dio(options);
    var formData = FormData.fromMap({
      'idx'        : idx,
      'book_id'    : bookUpdate["bookId"],
      'bookmark' : bookUpdate["bookmark"],
    });
    if (kDebugMode) {
      print("bookmark = ${bookUpdate["bookmark"]}");
    }
    Response response = await dio.post('/storeData.json',data: formData);
    if (response.data['result'].toString() == 'true') {
      await SQLHelper.saveWBookSynchroTime(bookUpdate['bookId'], auth.userId.value, idx, response.data['syncro_at']);
      auth.latestSyncTimeOnline.value = response.data['syncro_at'];
      result = true;
    }else{
      result = false;
    }
    return result;
  }
  Future<String> getLatestSyncTime() async {
    var result = '';
    BaseOptions options = BaseOptions(
        baseUrl: '${host}wiseapi/l/v1/',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(minutes: 1),
        receiveTimeout: const Duration(minutes: 1),
        headers       : auth.corpId.value == 'manamo' ? headersManamo : headers
    );
    var dio = Dio(options);
    var formData = FormData.fromMap({
      'idx': auth.idx.value,
      'mem_id': auth.corpId.value
    });
    try {
      Response response = await dio.post('/getLatestSyncAtData.json', data: formData);
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['latest_syncro_at'] != null) {
          result = response.data['latest_syncro_at'];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("REQUEST ERROR: $e");
      }
    }
    return result;
  }
}