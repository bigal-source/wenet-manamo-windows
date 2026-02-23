import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_windows/webview_windows.dart';
import '../../controllers/windows/window_off_controller.dart';

class WindowOffView extends StatefulWidget{
  WindowOffView({Key? key}) : super(key: key);

  @override
  State<WindowOffView> createState() => _WindowOffViewState();
}

class _WindowOffViewState extends State<WindowOffView> {
  var scaffoldOffline  = GlobalKey<ScaffoldState>();

  var controller       = Get.put(WindowOffController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldOffline,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black45,size: 24),
        leading: IconButton(
          onPressed: () {
            controller.goBack(context: context);
          },
          icon: const Icon(Icons.chevron_left),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.only(top: 0,bottom: 0),
          width: MediaQuery.of(context).size.width,
          height: 80,
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.translate(
                offset: const Offset(0, 0),
                child: Text('${controller.bookShelf.value.title}', style: const TextStyle( fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black45),),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: compositeView(),
      ),
    );
  }

  Widget compositeView() {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<LoadingState>(
                stream: controller.wController.loadingState,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data == LoadingState.loading) {
                    return const SizedBox();
                  } else if(snapshot.hasData && snapshot.data == LoadingState.navigationCompleted) {
                    controller.addButtonEvent();
                    return Listener(
                      onPointerSignal: (signal) {
                        if (signal is PointerScrollEvent) {
                          final Offset scrollDelta = signal.scrollDelta;
                          final Offset position = signal.position;
                          controller.scrollWebView(position.dx, position.dy, scrollDelta.dx, scrollDelta.dy);
                        }
                      },
                      child: Webview(
                        controller.wController,
                        permissionRequested: _onPermissionRequested,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                })
            ),
          ],
        ),
      );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: controller.navigatorKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }

  @override
  void dispose() async {
    super.dispose();
    for (var data in controller.subscriptions) {
      data.cancel();
      print('cancel');
    }
    controller.wController.dispose();
    await controller.auth.getSyncTime();
  }
}
