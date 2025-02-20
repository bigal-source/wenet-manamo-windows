
import 'package:flutter/material.dart';
import 'package:get/get_core/src/smart_management.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:upgrader/upgrader.dart';
import '/presentation/routes/app_pages.dart';

import 'controllers/auth/auth_binding.dart';
import 'fluent.dart';

class MyApp2 extends StatelessWidget {
  const MyApp2({Key? key, required this.isLoggedIn}) : super(key: key);
  final bool isLoggedIn;
  @override
  Widget build(BuildContext context) {
    print("isLoggedIn = $isLoggedIn");
    return  UpgradeAlert(
      upgrader: Upgrader(
        dialogStyle: UpgradeDialogStyle.cupertino,
        durationUntilAlertAgain: const Duration(days: 5),
        debugLogging: true,
        showLater:false,
        showReleaseNotes: false,
        showIgnore: false,
        messages: MyUpgraderMessages(),
        canDismissDialog: true,
      ),
      child: GetMaterialApp(
        title: "Manamo",
        enableLog: true,
        initialBinding: AuthBinding(),
        debugShowCheckedModeBanner: false,
        smartManagement: SmartManagement.full,
        themeMode: ThemeMode.system,
        // home: isLoggedIn == false ? LoginView() : const BoardView(),
        initialRoute: isLoggedIn == true ? AppPages.board : AppPages.login,
        getPages: AppPages.routes,
      ),
    );
  }
}

