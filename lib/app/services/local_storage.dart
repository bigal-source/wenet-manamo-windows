import 'dart:convert';

import 'package:get/get.dart';
import '../../domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _Key {
  user,
}

class LocalStorageService extends GetxService {
  SharedPreferences? _sharedPreferences;
  Future<LocalStorageService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  UserEntity? get user {
    final rawJson = _sharedPreferences?.getString(_Key.user.toString());
    if (rawJson == null) {
      return null;
    }
    Map<String, dynamic> map = jsonDecode(rawJson);
    return UserEntity.fromMap(map);
  }

  set user(UserEntity? value) {
    if (value != null) {
      _sharedPreferences?.setString(
          _Key.user.toString(), json.encode(value.toMap()));
    } else {
      _sharedPreferences?.remove(_Key.user.toString());
    }
  }
}
