
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/smart_management.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:upgrader/upgrader.dart';
import '/presentation/routes/app_pages.dart';

import 'controllers/auth/auth_binding.dart';
import 'fluent.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor:Colors.lightBlue,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark, // 2
            foregroundColor: Colors.lightBlue,
            backgroundColor: Colors.lightBlue,
            // brightness: Brightness.dark,
          ),
        ),
        home: UpgradeAlert(
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
          child:  GetMaterialApp(
            title: "Manamo",
            enableLog: true,
            defaultTransition: Transition.rightToLeft,
            initialBinding: AuthBinding(),
            debugShowCheckedModeBanner: false,
            smartManagement: SmartManagement.full,
            themeMode: ThemeMode.system,
            initialRoute: AppPages.home,
            getPages: AppPages.routes,
          ),
        )
    );
  }
}

