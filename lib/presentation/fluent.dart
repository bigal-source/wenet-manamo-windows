
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import '../app/utils/constants/strings.dart';
import '/presentation/pages/board/board_view.dart';
import '/presentation/pages/login/login_view.dart';
import '../app/config/theme.dart';
import 'package:get/get.dart';


class FApp extends StatelessWidget {
  const FApp({Key? key, required this.isLoggedIn}) : super(key: key);
  final bool isLoggedIn;
  @override
  Widget build(BuildContext context) {
    print('222 $isLoggedIn');
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return isLoggedIn == true ? FluentApp(
          title: 'Manamo',
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          localizationsDelegates:const [
            DefaultWidgetsLocalizations.delegate,
          ],
          color: appTheme.color,
          darkTheme: FluentThemeData(
            brightness: Brightness.dark,
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            ),
          ),
          theme: FluentThemeData(
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            ),
          ),
          locale: appTheme.locale,
          home: const BoardView(),
        ) : LoginView();
      },
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome>  {
  bool value = false;
  int _currentPage = 0;
  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) => NavigationView(
    appBar: NavigationAppBar(
      title: Container(
        margin:  const EdgeInsets.only( left: 20),
        child: const Text("Fluent UI", style: TextStyle(fontSize: 20, color:  Colors.white),),

      ),
      backgroundColor: Colors.teal,
      automaticallyImplyLeading:  false
    ),
    pane: NavigationPane(
      size: const NavigationPaneSize(
        openMaxWidth: 320.0,
        openMinWidth: 250.0,
      ),
      items: <NavigationPaneItem>[
        PaneItem(
            icon: const Icon(FluentIcons.home, size: 20,),
            title: const Text('Home'),
            body: const Text('Home body')
        ),
        PaneItem(
            icon: const Icon(FluentIcons.fabric_folder, size: 20,),
            title: const Text('Files'),
            body: const Text('Files body')
        ),
        PaneItem(
            icon: const Icon(FluentIcons.settings, size: 20,),
            title: const Text('Settings'),
            body: const Text('Settings body')
        ),
      ],
      selected:  _currentPage,
      onChanged: (index) => setState(() {
         _currentPage = index;
         _showDialog('Thông báo',"Bạn có muốn xoá không");

      }),
    ),
  );
  Future<Object?> _showDialog(String title, String contentTxt){
    return showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: Text(title),
            content: Text(contentTxt),
            actions: [
              Button(
                onPressed: () {
                  // Delete file here
                  // var box = GetStorage('info',dir);
                  // var idx = box.read('idx');
                  // box.erase();
                  // box.write('idx', idx);
                  Get.offAndToNamed('login');
                },
                child: const Text('Delete'),
              ),
              Button(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        }
    );
  }

}

class MyUpgraderMessages extends UpgraderMessages {
  @override
  String get title => 'アップデートお知らせ';
  @override
  String get body => '新しいアプリが公開されました。最新バージョンにアップデードしてください。';
  @override
  String get releaseNotes => '';
  @override
  String get prompt => '';
  @override
  String get buttonTitleIgnore => '';
  @override
  String get buttonTitleUpdate => 'OK';
}

class MyUpgrader extends Upgrader {
  MyUpgrader() : super(debugLogging: true);
  /// This method overrides super class method.
  @override
  void popNavigator(BuildContext context) {
    if (kDebugMode) {
      print('this method overrides popNavigator');
    }
    super.popNavigator(context);
  }
}