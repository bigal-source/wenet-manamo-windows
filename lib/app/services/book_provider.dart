import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as getX ;
import 'package:manamo/app/utils/setting.dart';
import '../../data/models/book_detail.dart';
import '../../data/models/book_info.dart';
import '../../data/models/noticeModel.dart';
import '../../data/providers/network/api_endpoint.dart';
import '../utils/server.dart';
import 'authen_service.dart';
import 'base_service.dart';
import 'package:dio/dio.dart';

class BookProvider extends BaseService {

  final auth = getX.Get.find<AuthenService>();
  Future<BookInfoModel> bookInfo(String menId, String bookId) async {
    Dio dio = Dio();
    Response response = await dio.get('${host}bookstorexp/json_book/$menId/$bookId');
    return BookInfoModel.fromJson(response.data) ;
  }
  Future<int> bookInfoPDF(String menId,String bookId) async {

    httpClient.timeout = const Duration(seconds: 600);
    httpClient.maxAuthRetries = 3;
    httpClient.baseUrl = host;
    final response = await get('vars/v2store/$menId/$bookId/stream/book.json');
    if (kDebugMode) {
    }
    return response.body == null ? 0 : int.parse(response.body['bookid_orig']) ;
  }

  //todo: get list categories book in home
  Future<List<BookCate>> getBookCategories(String userId) async {
    var customHeader = { 'X-Wisebook-Authorization': header, 'Cookie': 'PHPSESSID=iv3jv7rhitij20vo555s1h3eeb' };
    var result = <BookCate>[];
    BaseOptions options = BaseOptions(
        baseUrl: '${host}wiseapi/l/v1/',
        receiveDataWhenStatusError: true,
        headers       : customHeader
    );
    var dio = Dio(options);
    var formData = FormData.fromMap({
      'idx': userId,
    });
    print(userId);
    print(header);
    Response response = await dio.post('/listBookByCategory.json',data: formData);
    if (response.data['result'] == 'true') {
      var caterories = response.data['data'];
      result = List<BookCate>.from(caterories.map((x) => BookCate.fromJson(x)));
    }
    return result;
  }
  //todo: get list categories
  Future<List<BookCate>> getCategories(String userId) async {
    var customHeader = {
      'X-Wisebook-Authorization': header,
      'Cookie': 'PHPSESSID=iv3jv7rhitij20vo555s1h3eeb'
    };
    print("userId $userId");
    var result = <BookCate>[];
    BaseOptions options = BaseOptions(
        baseUrl: '${host}wiseapi/l/v1/',
        receiveDataWhenStatusError: true,
        headers       : customHeader
    );
    var dio = Dio(options);
    var formData = FormData.fromMap({
      'idx': userId,
    });
    Response response = await dio.post('/category.json',data: formData);
    if (kDebugMode) {
      // print(userId);
      // print(dio.options.headers);
      // print(response.data);
      // print(response.statusCode);
      // print(response.statusMessage);
      // print(response.data.toString());
    }
    if (response.data['result'] == 'true') {
      var caterories = response.data['data'];
      result = List<BookCate>.from(caterories.map((x) => BookCate.fromJson(x)));
    }
    return result;
  }
  //todo: get list book in categories
  Future<List<BookCate>> getBookInCate(String userId, String cateSeq) async {
    var customHeader = {
      'X-Wisebook-Authorization': header,
      'Cookie': 'PHPSESSID=iv3jv7rhitij20vo555s1h3eeb'
    };
    print("userId $userId");
    var result = <BookCate>[];
    BaseOptions options = BaseOptions(
        baseUrl: '${host}wiseapi/l/v1/',
        receiveDataWhenStatusError: true,
        headers       : customHeader
    );
    var dio = Dio(options);
    var formData = FormData.fromMap({
      'idx': userId,
      'parent_seq': cateSeq,
    });
    Response response = await dio.post('/category.json',data: formData);
    if (kDebugMode) {
    }
    if (response.data['result'] == 'true') {
      var caterories = response.data['data'];
      result = List<BookCate>.from(caterories.map((x) => BookCate.fromJson(x)));
    }
    return result;
  }
  //todo: get book info
  Future<BookDetailModel> getBookDetail(String bookSeq) async {
    var customHeader = {
      'X-Wisebook-Authorization': header,
      'Cookie': 'PHPSESSID=iv3jv7rhitij20vo555s1h3eeb'
    };
    var result = BookDetailModel();
    BaseOptions options = BaseOptions(
        baseUrl: '${host}wiseapi/l/v1/',
        receiveDataWhenStatusError: true,
        headers       : customHeader
    );
    var dio = Dio(options);
    var formData = FormData.fromMap({
      'book_id': bookSeq,
    });
    Response response = await dio.post('bookDetail.json',data: formData);
    if (response.data['status'] == true) {
      var x = response.data['resultList'];
      result = BookDetailModel.fromJson(x);
    }
    return result;
  }

  //todo: download limit
  Future<Map<String,dynamic>> getCountDownload(String userId, String storeBookId, String menId) async {
    var result = <String,dynamic>{};
    BaseOptions options = BaseOptions(
        baseUrl: '${host}bookstorexp/json_book_down_count',
        receiveDataWhenStatusError: true,
        headers       : {
          'X-Wisebook-Authorization': header,
          'Cookie': 'PHPSESSID=807qqa70473c2daa52ivp0lkp6'
        }
    );
    var dio = Dio(options);
    Response response = await dio.get('?user_id=$userId&store_book_id=$storeBookId&version=new&mem_id=$menId');
    return response.data;
  }


  //todo: NOTICE
  Future<NoticeView> getNotices() async {
    var customHeader = {
      'X-Wisebook-Authorization': header,
      'Cookie': 'PHPSESSID=iv3jv7rhitij20vo555s1h3eeb'
    };
    BaseOptions options = BaseOptions(
        baseUrl: APIEndpoint.wiseBookApi,
        receiveDataWhenStatusError: true,
        headers       : customHeader
    );
    var dio = Dio(options);
    Response response = await dio.post('/notice.json');
    return NoticeView.fromJson(response.data);
  }

  //todo: SEARCH RESULT
  Future<void> saveUserSearchResult(String url) async {
    var dio = Dio();
    String localServerUserAgent = '';
    if (auth.box.hasData('localServerUserAgent')) {
      localServerUserAgent = auth.box.read('localServerUserAgent');
    }
    dio.options.headers = {'User-Agent': localServerUserAgent};
    String baseURL = host.replaceRange(host.lastIndexOf('/'), host.length, '');
    if (kDebugMode) {
      print("save user search result");
      print('$baseURL$url');
    }
    await dio.get('$baseURL$url').then((value) {
      if (kDebugMode) {
        print(value.data);
      }
    });
  }

}

