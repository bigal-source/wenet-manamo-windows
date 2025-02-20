import 'package:get/get.dart';
import '../utils/server.dart';
class BaseService extends GetConnect {
  @override
  void onInit() {
    httpClient.userAgent       = '{"default":null,"ostp":"A","appver":1}';
    httpClient.baseUrl         = '${host}cloudapps/menu';
    httpClient.sendUserAgent   = true;
    httpClient.defaultContentType = "application/json";
    httpClient.timeout = const Duration(seconds: 1000);
    httpClient.maxAuthRetries = 3;
    httpClient.addRequestModifier<void>((request) async {
      return request;
    });
    httpClient.addRequestModifier<void>((request) async {
      return request;
    });
    httpClient.addAuthenticator<void>((request) async {
      return request;
    });
  }
}
