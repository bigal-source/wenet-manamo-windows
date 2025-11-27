import 'dart:io';
import 'package:archive/archive.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';
import 'package:get/get.dart';
import 'app/config/theme.dart';
import 'app/router/router.dart';
import 'app/services/authen_service.dart';
import 'app/utils/constants/strings.dart';
import 'app/utils/dependency.dart';
import 'app/utils/setting.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'data/datasources/local/db_help.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:win32_registry/win32_registry.dart';
import 'package:flutter/material.dart' as material;
import 'package:windows_ime_manager/windows_ime_manager.dart';
import 'package:flutter_udid/flutter_udid.dart';

/// Checks if the current environment is a desktop environment.
bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  dir = (await PathProviderWindows().getApplicationSupportPath())!;
  GetStorage('info', dir);
  await GetStorage.init('info');
  await DependencyCreator.init();
  await initServices();
  if (!kIsWeb &&
      [
        TargetPlatform.windows,
        TargetPlatform.android,
      ].contains(defaultTargetPlatform)) {
    SystemTheme.accentColor.load();
  }
  if (isDesktop) {
    await flutter_acrylic.Window.initialize();
    await flutter_acrylic.Window.hideWindowControls();
    WindowOptions windowOptions = const WindowOptions(
      center: true,
      skipTaskbar: false,
      minimumSize: Size(900, 700),
      windowButtonVisibility: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.setPreventClose(true);
      // await Future.delayed(const Duration(milliseconds: 500));
      // await windowManager.maximize();
    });
  }
  if (Platform.isWindows) {
    register('manamoapp');
    sqfliteFfiInit();
    SQLHelper();
  }
  await setLanguageIme(LanguageIme.japaneseHiraganaIme);
  udid = await FlutterUdid.udid;
  runApp(const MyApp());
}

  Future<void> setLanguageIme(LanguageIme languageIme) async {
  final windowsImeManagerPlugin = WindowsImeManager();
  try {
    await windowsImeManagerPlugin.setLanguageIme(languageIme);
    debugPrint('SET IME.');
  } on PlatformException {
    debugPrint('Failed to set language IME.');
  }
}

initServices() async {
  if (kDebugMode) {
    print('starting services ...');
  }
  await Get.putAsync(() => AuthenService().init());
  await initServer();
  if (kDebugMode) {
    print('All services started...');
  }
}

Future<void> register(String scheme) async {
  String appPath = Platform.resolvedExecutable;

  String protocolRegKey = 'Software\\Classes\\$scheme';
  RegistryValue protocolRegValue = const RegistryValue(
    'URL Protocol',
    RegistryValueType.string,
    '',
  );
  String protocolCmdRegKey = 'shell\\open\\command';
  RegistryValue protocolCmdRegValue = RegistryValue(
    '',
    RegistryValueType.string,
    '"$appPath" "%1"',
  );

  final regKey = Registry.currentUser.createKey(protocolRegKey);
  regKey.createValue(protocolRegValue);
  regKey.createKey(protocolCmdRegKey).createValue(protocolCmdRegValue);
}

Future<void> initServer() async {
  String path = "$dir/web";
  //todo: file folder
  var zipPath = "$dir/viewer.zip";
  bool directoryExists = await Directory(path).exists();
  var box = GetStorage('info', dir);

  if (!directoryExists) {
    //todo: check override web folder
    var resp = await exactFile(path, zipPath);
    box.write('updateViewerFolder', updateViewerFolder);
    if (resp) {
      if (kDebugMode) {
        print("exact Resp $resp");
      }
    }
  } else {
    List<String> listFolderName = ["v2_lib.zip", "v2_viewhtml.zip", "v2_images.zip", "v2_css.zip"];
    if (!box.hasData('updateViewerFolder')) {
      box.write('updateViewerFolder', updateViewerFolder);
      await updateFolderForViewer(box, path, listFolderName);
      await moveFileFromAssetsToApp('index.html', 'update_files/', '');
    } else {
      if (box.read('updateViewerFolder') < updateViewerFolder) {
        await updateFolderForViewer(box, path, listFolderName);
        await moveFileFromAssetsToApp('index.html', 'update_files/', '');
        box.write('updateViewerFolder', updateViewerFolder);
      }
    }
  }

  //todo: start server
  var handler = createStaticHandler(path, defaultDocument: 'index.html');
  io.serve(handler, InternetAddress.loopbackIPv4, 8088).then((server) {
    if (kDebugMode) {
      print("Server Start");
      print("${InternetAddress.loopbackIPv4}");
      print('Serving at http://${server.address.host}:${server.port}');
    }
  });
}

Future<void> updateFolderForViewer(GetStorage box, String path, List<String> listFolderName) async {
  for (String file in listFolderName) {
    Directory folder = Directory('$path/${file.replaceAll('.zip', '')}');
    bool folderExists = folder.existsSync();
    if (folderExists) {
      print("DELETE FOLDER: $folder");
      await folder.delete(recursive: true);
      await moveFolderFromAssetsToAppDirectory(path, file);
    }
  }
}
Future<void> moveFolderFromAssetsToAppDirectory(String appPath, String folderName) async {
  ByteData assetsFolder = await rootBundle.load("assets/$folderName");
  await writeToFile(assetsFolder, "$appPath/$folderName").then((value) {
    if (value.existsSync()) {
      var newFolder = value.readAsBytesSync();
      var archive = ZipDecoder().decodeBytes(newFolder);
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          File('$appPath/${folderName.replaceAll('.zip', '')}/$filename')..createSync(recursive: true)..writeAsBytesSync(data);
        } else {
          Directory('$appPath/${folderName.replaceAll('.zip', '')}/$filename').create(recursive: true);
        }
      }
      value.delete();
    }
  });
}

Future<bool> moveFileFromAssetsToApp(String fileName, String fromPath, String toPath) async {
  String appDocumentPath = dir;
  bool isDone = false;
  ByteData data = await rootBundle.load("assets/$fromPath$fileName");
  if (await checkExistFile("$appDocumentPath/web/$toPath$fileName")) {
    print('old file exist ($fileName) -> delete file');
    await deleteFile("$appDocumentPath/web/$toPath$fileName");
    print('delete ($fileName) done -> move new file');
  }
  await writeToFile(data, "$appDocumentPath/web/$toPath$fileName").then((value) async {
    isDone = await checkExistFile(value.path);
    print('move ($fileName) done');
  });
  return isDone;
}
Future<bool> checkExistFile(String path) async {
  return File(path).exists();
}
Future<void> deleteFile(String path) async {
  try {
    await File(path).delete();
  } catch (e) {
    rethrow;
  }
}

Future<bool> exactFile(String webPath, String zipPath) async {
  bool result = true;
  if (FileSystemEntity.typeSync(webPath) == FileSystemEntityType.notFound) {
    ByteData data = await rootBundle.load("assets/viewer.zip");
    final File zip = await writeToFile(data, zipPath);
    try {
      final bytes = zip.readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);
      //exact
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          File('$webPath/$filename')
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory('$webPath/$filename').create(recursive: true);
        }
      }
      if (zip.existsSync()) {
        zip.delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print("exact error");
      }
      return false;
    }
  }
  return result;
}

Future<File> writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return File(path)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

Future<bool> moveFile() async {
  //todo: check db
  var bookAppIds = await SQLHelper.getAllBookAppId();
  if (kDebugMode) {}
  for (int i = 0; i < bookAppIds.length; i++) {
    String dirPath = "$dir/${bookAppIds[i]}";
    bool directoryExists = await Directory(dirPath).exists();
    if (directoryExists) {
      // has directory
      String newDesBookPath = "$dir/web/${bookAppIds[i]}";
      String zipFilePath = "$dir/${bookAppIds[i]}";
      final sourceDir = Directory(zipFilePath);
      if (kDebugMode) {}
      sourceDir.renameSync(newDesBookPath);
    } else {
      if (kDebugMode) {}
    }
  }
  if (kDebugMode) {}
  return true;
}

Future<bool> moveFileOut() async {
  //todo: check db
  var bookAppIds = await SQLHelper.getAllBookAppId();
  if (kDebugMode) {}
  for (int i = 0; i < bookAppIds.length; i++) {
    // zip
    String dirPath = "$dir/web/${bookAppIds[i]}";
    bool directoryExists = await Directory(dirPath).exists();
    if (directoryExists) {
      // has directory
      String newDesBookPath = "$dir/${bookAppIds[i]}";
      String zipFilePath = "$dir/web/${bookAppIds[i]}";
      final sourceDir = Directory(zipFilePath);
      sourceDir.renameSync(newDesBookPath);
    } else {
      if (kDebugMode) {}
    }
  }
  return true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemNavigator.pop();
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp.router(
          scrollBehavior: MyCustomScrollBehavior(),
          title: appTitle,
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          color: appTheme.color,
          // darkTheme: FluentThemeData(
          //   brightness: Brightness.dark,
          //   accentColor: appTheme.color,
          //   visualDensity: VisualDensity.standard,
          //   focusTheme: FocusThemeData(
          //     glowFactor: is10footScreen(context) ? 2.0 : 0.0,
          //   ),
          // ),
          theme: FluentThemeData(
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            ),
          ),
          locale: appTheme.locale,
          builder: (context, child) {
            return Directionality(
              textDirection: appTheme.textDirection,
              child: NavigationPaneTheme(
                data: NavigationPaneThemeData(
                  backgroundColor: appTheme.windowEffect !=
                      flutter_acrylic.WindowEffect.disabled
                      ? Colors.transparent
                      : null,
                ),
                child: child!,
              ),
            );
          },
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
        );
      },
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final FluentThemeData theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class MyCustomScrollBehavior extends material.MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
