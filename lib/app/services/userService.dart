import 'dart:core';
import 'package:flutter/foundation.dart';
import '/app/utils/setting.dart';

import '../../data/models/user_models.dart';
import '../utils/server.dart';
import 'base_service.dart';
import 'package:dio/dio.dart' ;

class UserService extends BaseService {
  Future<LoginModel> checkEmail(String email) async {
    var customHeader = {
      'X-Wisebook-Authorization': header,
      'User-Agent':ua
    };
    BaseOptions options = BaseOptions(
        baseUrl: '${host}wiseapi/l/v1/',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(minutes: 1), // 60 seconds
        receiveTimeout: const Duration(minutes: 1),
        headers       : customHeader
    );
    var dio = Dio(options);
    var formData = FormData.fromMap({
      'email': email,
      'userDevice': "78538572df56",
    });

    var result =  LoginModel();
    Response user = await dio.post('/appUserInfo.json',data: formData);
    if (kDebugMode) {
    }
    var resp = user.data;
    if (user.statusCode == 200) {
      result =  LoginModel(
          result             :               resp['result'],
          idX                :               resp['result'] == 'true'  ? resp['data']['idx']            : null,
          userId             :               resp['result'] == 'true'  ? resp['data']['user_id']        : null,
          userPw             :               resp['result'] == 'true'  ? resp['data']['user_pw']        : null,
          email              :               resp['result'] == 'true'  ? resp['data']['email']          : null,
          state              :               resp['result'] == 'true'  ? resp['data']['state']          : null,
          loginPrevious      :               resp['result'] == 'true'  ? resp['data']['login_previous'] : null,
          loginType          :               resp['result'] == 'true'  ? resp['data']['login_type']     : null,
          autoLogin          :               resp['result'] == 'true'  ? resp['data']['autologin']      : null,
          sessionId          :               resp['result'] == 'true'  ? resp['data']['session_id']     : null,
          corpName           :               resp['result'] == 'true'  ? resp['data']['mem_id'].toString()          : null,
          errorMessage       :               resp['result'] == 'false' ? resp['data']['msg']            : null
      );
    }
    return result;
  }
  Future<LoginModel> loginDB(String userName, String passWord) async {
    var customHeader = {'X-Wisebook-Authorization': header, 'User-Agent':ua };
    BaseOptions options = BaseOptions(
        baseUrl: '${host}wiseapi/l/v1/',
        receiveDataWhenStatusError: true,
        // connectTimeout:60, // 60 seconds
        // receiveTimeout: 60, // 60 seconds
        headers       : customHeader
    );
    var dio = Dio(options);
    var formData = FormData.fromMap({
      'email'     : userName,
      'user_pw'   : passWord,
      'userDevice': deviceId,
    });
    if (kDebugMode) {
    }
    var result =  LoginModel();

    try{
      Response response = await dio.post('/appUserLogin.json',data: formData);
      if (kDebugMode) {
        print(response.data);
      }
      var resp = response.data;
      if (response.statusCode == 200) {
        result =  LoginModel(
            result             :               resp['result'],
            idX                :               resp['result'] == 'true'  ? resp['data']['idx'].toString()            : null,
            userId             :               resp['result'] == 'true'  ? resp['data']['user_id'].toString()         : null,
            userPw             :               resp['result'] == 'true'  ? resp['data']['user_pw'].toString()         : null,
            email              :               resp['result'] == 'true'  ? resp['data']['email'].toString()           : null,
            state              :               resp['result'] == 'true'  ? resp['data']['state'].toString()           : null,
            loginPrevious      :               resp['result'] == 'true'  ? resp['data']['login_previous'].toString()  : null,
            loginType          :               resp['result'] == 'true'  ? resp['data']['login_type'].toString()      : null,
            autoLogin          :               resp['result'] == 'true'  ? resp['data']['autologin'].toString()       : null,
            sessionId          :               resp['result'] == 'true'  ? resp['data']['session_id'].toString()      : null,
            corpName           :               resp['result'] == 'true'  ? resp['data']['mem_id'].toString()          : null,
            errorMessage       :               resp['result'] == 'false' ? resp['data']['msg'] : null
        );
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    return result;
  }
  Future<int> registerDevice(String email) async {
    BaseOptions options = BaseOptions(
        baseUrl: '${host}bookstorexp/security_device/app',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(minutes: 1), // 60 seconds
        receiveTimeout: const Duration(minutes: 1),
        headers       : headers
    );
    var dio = Dio(options);
    var formData = FormData.fromMap({
      'device_id': "deviceId",
      'device_name': "deviceName",
      'user_id': email,
      'mem_id': corpname,
      'state': '',
    });
    Response response = await dio.post('/',data: formData);
    var resp = response.data;
    if (response.statusCode == 200) {
    }
    return 1;
  }
  Future<Map> getMetaDataFromServer(String idX, String bookId) async {
    Map result  = {};
    var headers = {
      'X-Wisebook-Authorization': header,
      'Cookie': 'PHPSESSID=9a6ff5tob7eg1la1pioj24f0p3'
    };
    var data = FormData.fromMap({
      'idx': idX,
      'book_id': bookId
    });
    var dio = Dio();
    var response = await dio.request(
      '${host}wiseapi/l/v1/getStorageData.json',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );
    // if (kDebugMode) {
    //   print("======================//=========================");
    //   print( response.statusCode.toString());
    //   print(response.toString());
    // }
    var resp = response.data;
    if (response.statusCode == 200) {

      if(resp['result'] == 'true'){
        result['status'] = true;
        result['obj']         = response.data['data']['pages'];
        result['bookmark']    = response.data['data']['bookmark']['siori'];
        if (resp["syncro_at"] != null) {
          result['syncro_at'] = resp["syncro_at"];
        }
      }else{
        result['status'] = false;
        result['obj']    = {};
      }
    }
    return result;

  }
  Future<Map> setMetaDataToServer(String idX, String bookId) async {
    var headers = {
      'X-Wisebook-Authorization': header,
      'Cookie': 'PHPSESSID=9a6ff5tob7eg1la1pioj24f0p3'
    };
    var data = FormData.fromMap({
      'idx': idX,
      'book_id': bookId
    });
    var dio = Dio();
    var response = await dio.request(
      '${host}wiseapi/l/v1/getStorageData.json',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );
    if (response.statusCode == 200) {
      return response.data['data']['pages'];
    }
    else {
      return response.data['data']['pages'];
    }

  }
}
