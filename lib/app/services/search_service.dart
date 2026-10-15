import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as getX ;
import '../../data/models/search_view_model.dart';
import '../utils/server.dart';
import 'authen_service.dart';
import 'base_service.dart';
import 'package:dio/dio.dart';


class SearchService extends BaseService {
  final auth = getX.Get.find<AuthenService>();

  //todo: get list categories book in home
  Future<BookSearchModel> searchBook(
    String userId,
    String keyWord,
    String searchType,
    String searchOption,
  ) async {
    var result = BookSearchModel();
    BaseOptions options = BaseOptions(
        baseUrl: '${host}wiseapi/l/v1/',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(minutes: 1), // 60 seconds
        receiveTimeout: const Duration(minutes: 1), // 60 seconds
        headers       : auth.getHeader()

    );
    var dio = Dio(options);
    var formData = FormData.fromMap({
      'user_id'    : userId,
      'keyword'    : keyWord,
      'search_type': searchType,
      // search_opt is only used for full-text search (solr)
      if (searchType != 'normal') 'search_opt' : searchOption,
    });
    Response response = await dio.post('manamoSearch.json',data: formData);
    if (kDebugMode) {
      // print('headers $headers');
      // print('userId $userId');
      // print('keyWord $keyWord');
      // print('searchType $searchType');
      // print(response.data);
    }
    if (response.data['result'] == 'true') {
      var resp = response.data['data'];
      result = BookSearchModel.fromJson(resp);
    }
    return result;
  }

}

