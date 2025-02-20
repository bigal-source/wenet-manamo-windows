import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import '../../../app/services/authen_service.dart';

class LogoutController extends GetxController with GetSingleTickerProviderStateMixin {

  //TODO: Implement LogoutController
  static LogoutController get to => Get.find();
  final auth                     = Get.find<AuthenService>();
  GlobalKey bottomNavigationKey  = GlobalKey();

  @override
  Future<void> onInit() async {
    super.onInit();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void logOutDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) {
        return ContentDialog(
          title: const Text('ログアウト'),
          content: const Text('ログアウトしますか？'),
          actions: [
            FilledButton(
              child: const Text('はい'), // yes
              onPressed: () {
                Navigator.pop(context);
                // var idx = auth.box.read('idx');
                // auth.box.erase();
                // auth.box.write('idx', idx);
                // if(FirebaseAuth.instance.currentUser != null){
                //   FirebaseAuth.instance.signOut();
                // }
                context.go('/');
              },
            ),
            Button(
              child: const Text('いいえ'), // cancel  - いいえ
              onPressed: () {
                context.go('/home');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  @override
  void onClose() {
   // Get.delete<BookShelfController>();
  }
}
