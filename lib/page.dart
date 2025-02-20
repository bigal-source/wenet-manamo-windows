
import 'package:flutter/material.dart';
import 'package:path_provider_windows/path_provider_windows.dart';


// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs


void main() {
  runApp(const MyApp());
}

/// Sample app
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _tempDirectory = 'Unknown';
  String? _downloadsDirectory = 'Unknown';
  String? _appSupportDirectory = 'Unknown';
  String? _documentsDirectory = 'Unknown';
  String? _cacheDirectory = 'Unknown';

  @override
  void initState() {
    super.initState();
    initDirectories();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initDirectories() async {
    String? tempDirectory;
    String? downloadsDirectory;
    String? appSupportDirectory;
    String? documentsDirectory;
    String? cacheDirectory;
    final PathProviderWindows provider = PathProviderWindows();

    try {
      tempDirectory = await provider.getTemporaryPath();
    } catch (exception) {
      tempDirectory = 'Failed to get temp directory: $exception';
    }
    try {
      downloadsDirectory = await provider.getDownloadsPath();
    } catch (exception) {
      downloadsDirectory = 'Failed to get downloads directory: $exception';
    }

    try {
      documentsDirectory = await provider.getApplicationDocumentsPath();
    } catch (exception) {
      documentsDirectory = 'Failed to get documents directory: $exception';
    }

    try {
      appSupportDirectory = await provider.getApplicationSupportPath();
    } catch (exception) {
      appSupportDirectory = 'Failed to get app support directory: $exception';
    }

    try {
      cacheDirectory = await provider.getApplicationCachePath();
    } catch (exception) {
      cacheDirectory = 'Failed to get cache directory: $exception';
    }

    setState(() {
      _tempDirectory = tempDirectory;
      _downloadsDirectory = downloadsDirectory;
      _appSupportDirectory = appSupportDirectory;
      _documentsDirectory = documentsDirectory;
      _cacheDirectory = cacheDirectory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Path Provider example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Temp Directory: $_tempDirectory\n'),
              Text('Documents Directory: $_documentsDirectory\n'),
              Text('Downloads Directory: $_downloadsDirectory\n'),
              Text('Application Support Directory: $_appSupportDirectory\n'),
              Text('Cache Directory: $_cacheDirectory\n'),
            ],
          ),
        ),
      ),
    );
  }
}
// Future<void> main(List<String> args) async {
//   debugPrint('args: $args');
//   if (runWebViewTitleBarWidget(args)) {
//     return;
//   }
//   WidgetsFlutterBinding.ensureInitialized();
//   final PathProviderWindows provider = PathProviderWindows();
//   //todo: dev
//   final directory = await getApplicationDocumentsDirectory();
//   String? tempPath = await provider.getApplicationSupportPath();
//   dir = (Platform.isWindows ? tempPath : directory.path)!;
//   //todo:prod
//   // dir = Platform.isWindows ? Directory.current.path : directory.path;
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool? _webviewAvailable;
//   @override
//   void initState() {
//     super.initState();
//     WebviewWindow.isWebviewAvailable().then((value) {
//       setState(() {
//         print("isWebviewAvailable = $value");
//         _webviewAvailable = value;
//       });
//     });
//   }
//
//   @override
//
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 16),
//                 TextButton(
//                   onPressed: _webviewAvailable != true ? null : _onTap,
//                   child: const Text('Open'),
//                 ),
//                 const SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () async {
//                     await WebviewWindow.clearAll(
//                       userDataFolderWindows: await _getWebViewPath(),
//                     );
//                     debugPrint('clear complete');
//                   },
//                   child: const Text('Clear all'),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _onTap() async {
//     final web = await WebviewWindow.create(
//       configuration: CreateConfiguration(
//         userDataFolderWindows: await _getWebViewPath(),
//         titleBarTopPadding: Platform.isMacOS ? 20 : 0,
//       ),
//     );
//     web.addScriptToExecuteOnDocumentCreated("""
//
//                  function createCookie(name,value,days) {
//                         if (days) {
//                             var date = new Date();
//                             date.setTime(date.getTime() + (days * 24 * 60 * 60 *1000));
//                             var expires = "; expires=" + date.toGMTString();
//                         } else {
//                             var expires = "";
//                         }
//                         document.cookie = name + "=" + value + expires + "; path=/";
//                     }
//
//                     function readCookie(name) {
//                         var nameEQ = name + "=";
//                         var ca = document.cookie.split(';');
//                         for(var i=0;i < ca.length;i++) {
//                             var c = ca[i];
//                             while (c.charAt(0)==' ') {
//                                 c = c.substring(1,c.length);
//                             }
//                             if (c.indexOf(nameEQ) == 0) {
//                                 return c.substring(nameEQ.length,c.length);
//                             }
//                         }
//                         return null;
//                     }
//                     function eraseCookie(name) {
//                         createCookie(name,"7s25uagkbiaj68295c7egp44sg",30);
//                     }
//                   eraseCookie('PHPSESSID');
//                 """);
//     await Future.delayed(const Duration(seconds: 2));
//     web
//       ..setApplicationNameForUserAgent("flt")
//       ..launch('https://wb.manamo.jp/html/m101507/1212/#1')
//       ..addOnUrlRequestCallback((url) {
//         if (kDebugMode) {
//           print('URL1 = $url');
//         }
//         if (url == 'about:blank') {
//           debugPrint('about:blank');
//         }
//       })
//       ..onClose.whenComplete(() {
//         debugPrint("on close");
//       });
//     await Future.delayed(const Duration(seconds: 2));
//     for (final javaScript in _javaScriptToEval) {
//       try {
//         final ret = await web.evaluateJavaScript(javaScript);
//         debugPrint('evaluateJavaScript: $ret');
//       } catch (e) {
//         debugPrint('evaluateJavaScript error: $e \n $javaScript');
//       }
//     }
//   }
// }
//
// const _javaScriptToEval = [
//   'eval({"cookie": document.cookie, "user_agent": navigator.userAgent})',
// ];
//
// Future<String> _getWebViewPath() async {
//   return p.join(
//     dir,
//     'desktop_webview_window',
//   );
// }