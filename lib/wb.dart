import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:webview_windows/webview_windows.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = WebviewController();
  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await _controller.initialize();
    await _controller.loadUrl(getAssetFileUrl('assets/test.html'));
    // LISTEN DATA FROM HTML CONTENT
    _controller.webMessage.listen((event) {
      print("event");
      print(event);
    });
    if (!mounted) return;

    setState(() {});
  }

  Widget compositeView() {
    if (!_controller.value.isInitialized) {
      return const Text(
        'Not Initialized',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            children: [
              Webview(_controller),
              StreamBuilder<LoadingState>(
                  stream: _controller.loadingState,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data == LoadingState.loading) {
                      return const LinearProgressIndicator();
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("123"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                var json = '{"name":"John", "age":30, "car":null}';
                // SENT DATA TO HTML CONTENT
                _controller.postWebMessage(json);
              },
            )
          ],
        ),
        body: Center(
          child: compositeView(),
        ),
      ),
    );
  }

  String getAssetFileUrl(String asset) {
    final assetsDirectory = p.join(p.dirname(Platform.resolvedExecutable),
        'data', 'flutter_assets', asset);
    print(assetsDirectory);
    return Uri.file(assetsDirectory).toString();
  }
}