import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:manamo/app/services/base_service.dart';
import '../../data/models/check_change_mail_model.dart';
import '../utils/server.dart';
class ChangePassServices extends BaseService {
  Future<Map> changePassLoggedIn(String email, String pass, String idx, String corpName) async {
    var staticUrl = corpName == 'manamo' ? emailManamoURL : emailM101507URL;
    var header = corpName == 'manamo' ? manamoHead : headercode;
    var customHeader = {'X-Wisebook-Authorization': header, };
    BaseOptions options = BaseOptions(
        baseUrl: '$staticUrl/api',
        receiveDataWhenStatusError: true,
        connectTimeout:const Duration(seconds: 60), // 60 seconds
        receiveTimeout:const Duration(seconds: 60), // 60 seconds
        headers       : customHeader
    );
    var dio = Dio(options);
    var formData = FormData.fromMap({
      'email': email,
      'user_pw': pass,
      'idx': idx
    });
    Response response = await dio.post('/update-password',data: formData);
    var resp = response.data;
    if (response.statusCode == 200) {
      print('111111111');
    } else {
      print('22222222222');
    }
    return resp;
  }
  Future<Map> changePass(String email, String pass, String keyWord) async {
    var staticUrl    ='$emailManamoURL/';
    var customHeader = {'X-Wisebook-Authorization': manamoHead};
    BaseOptions options = BaseOptions(
        baseUrl: '$staticUrl/api',
        receiveDataWhenStatusError: true,
        connectTimeout:const Duration(seconds: 60), // 60 seconds
        receiveTimeout:const Duration(seconds: 60), // 60 seconds
        headers       : customHeader
    );
    var dio = Dio(options);
    var formData = FormData.fromMap({
      'email': email,
      'user_pw': pass,
      'keyword': keyWord
    });
    Response response = await dio.post('/update-password',data: formData);
    var resp = response.data;
    if (response.statusCode == 200) {
    }
    return resp;
  }
}
class ChangeMailServices extends BaseService {
  Future<Map> checkEmailForChangeEmail(int idx, String email, String corpName) async {
    var staticUrl = corpName == 'manamo' ? emailManamoURL : emailM101507URL;
    var header = corpName == 'manamo' ? manamoHead : headercode;
    var customHeader = {'X-Wisebook-Authorization': header, };
    BaseOptions options = BaseOptions(
        baseUrl: '$staticUrl/api',
        receiveDataWhenStatusError: true,
        connectTimeout:const Duration(seconds: 60), // 60 seconds
        receiveTimeout:const Duration(seconds: 60), // 60 seconds
        headers       : customHeader
    );
    var dio = Dio(options);
    var formData = FormData.fromMap({
      'idx': idx,
      'email': email,
    });
    Response response = await dio.post('/check-mail',data: formData);
    var resp = response.data;
    if (response.statusCode == 200) {
    }
    return resp;
  }
  Future<EmailReview> checkChangeEmail(String idx, String cropName) async {
    var cmsUrl = cropName == 'manamo' ? emailManamoURL : emailM101507URL;
    var customHeader = {'X-Wisebook-Authorization': headercode, };
    BaseOptions options = BaseOptions(
        baseUrl: '$cmsUrl/api',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(minutes: 1), // 60 seconds
        receiveTimeout: const Duration(minutes: 1), // 60 seconds
        headers       : customHeader
    );
    var dio = Dio(options);
    var formData = FormData.fromMap({'idx': idx});
    var res    =  EmailReview(idx: 0, mailChangeFlg: 0, email: '');
    try{
      Response checkedData = await dio.post('/get-user-info',data: formData);
      if (checkedData.statusCode == 200 && checkedData.data['status'].toString() == 'true') {
        res.idx              = checkedData.data['resultList']['idx'];
        res.email            = checkedData.data['resultList']['email'];
        res.mailChangeFlg    = checkedData.data['resultList']['mailchange_flg'];
      }
    } catch (ex) {
      if (kDebugMode) {
        print("ex");
      }
    }
    return res;
  }
  Future<Map> changeEmail(int idx, String email, String keyWord, String corpName) async {
    var staticUrl = corpName == 'manamo' ? emailManamoURL : emailM101507URL;
    var header = corpName == 'manamo' ? manamoHead : headercode;
    var customHeader = {'X-Wisebook-Authorization': header, };
    BaseOptions options = BaseOptions(
        baseUrl: '$staticUrl/api',
        receiveDataWhenStatusError: true,
        connectTimeout:const Duration(seconds: 60), // 60 seconds
        receiveTimeout:const Duration(seconds: 60), // 60 seconds
        headers       : customHeader
    );
    var dio = Dio(options);
    var formData = FormData.fromMap({
      'idx': idx,
      'email': email,
      'keyword': keyWord
    });
    Response response = await dio.post('/update-mail',data: formData);
    var resp = response.data;
    if (response.statusCode == 200) {
    }
    return resp;
  }
}