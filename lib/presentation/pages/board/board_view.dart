
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../../../app/utils/constants/strings.dart';
import '/presentation/pages/home/home_view.dart';
import '/presentation/views/term.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import '../../../app/config/theme.dart';
import '../../../app/router/getGoRouter.dart';
import '../../../app/utils/setting.dart';
import '../../views/book_shelf.dart';
import '../../views/catalog.dart';
import '../../views/help.dart';
import '../../views/link_item.dart';
import '../../views/policy.dart';
import '../../views/search.dart';
import '../../views/setting.dart';
import '../../views/slo.dart';

class BoardView extends StatelessWidget {
  const BoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp.router(
          title: appTitle,
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
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
          routeInformationParser: getGoRouter.routeInformationParser,
          routerDelegate: getGoRouter.routerDelegate,
          routeInformationProvider: getGoRouter.routeInformationProvider,
        );
        return FluentApp(
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
          home: const MainBoard(),
        ) ;
      },
    );
  }
}

class MainBoard extends StatefulWidget {
  const MainBoard({super.key});

  @override
  State<MainBoard> createState() => _MainBoardState();
}

class _MainBoardState extends State<MainBoard> with WindowListener {
  bool value = false;
  int _currentPage = 0;
  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  final searchKey = GlobalKey(debugLabel: 'Search Bar Key');
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();
  final List<NavigationPaneItem> originalItems = [
    PaneItem(
      key: const Key('/home'),
      icon: const Icon(FluentIcons.home),
      title: const Text('Home'),
      body: HomeView(),
      onTap: () {
      },
    ),
    PaneItem(
      key: const Key('/category'),
      icon: const Icon(FluentIcons.open_folder_horizontal),
      title: const Text('カテゴリ'),
      body: const CatalogPage(),
      onTap: () {
      },
    ),
    PaneItem(
      key: const Key('/search'),
      icon: const Icon(FluentIcons.search),
      title: const Text('検索'),
      body: const SearchPage(),
      onTap: () {
      },
    ),
    PaneItem(
      key: const Key('/bookshelf'),
      icon: const Icon(FluentIcons.library),
      title: const Text('本棚'),
      body: const BookShelfPage(),
      onTap: () {
      },
    ),
    PaneItem(
      key: const Key('/logout'),
      icon: const Icon(FluentIcons.lock_solid),
      title: const Text('ログアウト'),
      body: const SizedBox.shrink(),
      onTap: () {
      },
    ),
    // PaneItem(
    //   key: const Key('/notice'),
    //   icon: const Icon(FluentIcons.info),
    //   title: const Text('お知らせ'),
    //   body: const NoticePage(),
    //   onTap: () {
    //     if (kDebugMode) {
    //       print("tap notice");
    //     }
    //   },
    // ),
    PaneItem(
      key: const Key('/policy'),
      icon: const Icon(FluentIcons.contact),
      title: const Text('プライバシーポリシー'),
      body: const PolicyView(),
      onTap: () {
      },
    ),
    PaneItem(
      key: const Key('/slo'),
      icon: const Icon(FluentIcons.completed12),
      title: const Text('SLOガイドライン'),
      body: const SloView(),
      onTap: () {
      },
    ),
    PaneItem(
      key: const Key('/term'),
      icon: const Icon(FluentIcons.edit_solid12),
      title: const Text('利用規約'),
      body: const TermView(),
      onTap: () {
      },
    ),
    PaneItem(
      key: const Key('/help'),
      icon: const Icon(FluentIcons.book_answers),
      title: const Text('ヘルプ'),
      body: const HelpView(),
      onTap: () {
      },
    ),
  ];
  final List<NavigationPaneItem> footerItems = [
    PaneItemSeparator(),
    PaneItem(
      key: const Key('/setting'),
      icon: const Icon(FluentIcons.settings),
      title: const Text('Settings'),
      body: const SettingPage(),
      onTap: () {
      },
    ),
    LinkPaneItemAction(
      icon: const Icon(FluentIcons.open_source),
      title: const Text('About Us'),
      link: 'https://manamo.jp',
      body: const SizedBox.shrink(),
    ),
    // TODO: mobile widgets, Scrollbar, BottomNavigationBar, RatingBar
  ];
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FluentLocalizations.of(context);
    final appTheme = context.watch<AppTheme>();
    final theme = FluentTheme.of(context);
    if (kDebugMode) {
      print("widget.state.location");
    }
    // if (widget.shellContext != null) {
    //   if (router.canPop() == false) {
    //     setState(() {});
    //   }
    // }
    return NavigationView(
      key: viewKey,
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: () {
          if (kIsWeb) {
            return const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(appTitle),
            );
          }
          return const DragToMoveArea(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(appTitle),
            ),
          );
        }(),
        actions: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8.0),
            child: ToggleSwitch(
              content: const Text('Dark Mode'),
              checked: FluentTheme.of(context).brightness.isDark,
              onChanged: (v) {
                if (v) {
                  appTheme.mode = ThemeMode.dark;
                } else {
                  appTheme.mode = ThemeMode.light;
                }
              },
            ),
          ),
          if (!kIsWeb) const WindowButtons(),
        ]),
      ),
      pane: NavigationPane(
        selected: _currentPage,
        onChanged: (index) => setState(() {
          _currentPage = index;
          if (kDebugMode) {
            print("index $index");
          }
          if(index == 4){
           // _showDialog('Thông báo',"Bạn có muốn đăng xuất không?");
            _showMacDialog('ログアウト','ログアウトしますか？');
          }

        }),
        header: SizedBox(
          height: kOneLineTileHeight,
          child: ShaderMask(
              shaderCallback: (rect) {
                final color = appTheme.color.defaultBrushFor(
                  theme.brightness,
                );
                return LinearGradient(
                  colors: [
                    color,
                    color,
                  ],
                ).createShader(rect);
              },
              child: Image.asset('assets/images/icon/manamo-icon.png')
          ),
        ),
        displayMode: appTheme.displayMode,
        indicator: () {
          switch (appTheme.indicator) {
            case NavigationIndicators.end:
              return const EndNavigationIndicator();
            case NavigationIndicators.sticky:
            default:
              return const StickyNavigationIndicator();
          }
        }(),
        items: originalItems,
        // autoSuggestBox: AutoSuggestBox(
        //   key: searchKey,
        //   focusNode: searchFocusNode,
        //   controller: searchController,
        //   unfocusedColor: Colors.transparent,
        //   items: originalItems.whereType<PaneItem>().map((item) {
        //     assert(item.title is Text);
        //     final text = (item.title as Text).data!;
        //     return AutoSuggestBoxItem(
        //       label: text,
        //       value: text,
        //       onSelected: () {
        //         item.onTap?.call();
        //         searchController.clear();
        //       },
        //     );
        //   }).toList(),
        //   trailingIcon: IgnorePointer(
        //     child: IconButton(
        //       onPressed: () {},
        //       icon: const Icon(FluentIcons.search),
        //     ),
        //   ),
        //   placeholder: 'Search',
        // ),
        autoSuggestBoxReplacement: const Icon(FluentIcons.search),
        footerItems: footerItems,
      ),
      onOpenSearch: () {
        searchFocusNode.requestFocus();
      },
    );
  }
  // Widget build(BuildContext context) => NavigationView(
  //   appBar: NavigationAppBar(
  //       title: Container(
  //         margin:  const EdgeInsets.only( left: 20),
  //         child: const Text("Fluent UI", style: TextStyle(fontSize: 20, color:  Colors.white),),
  //
  //       ),
  //       backgroundColor: Colors.teal,
  //       automaticallyImplyLeading:  false
  //   ),
  //   pane: NavigationPane(
  //     size: const NavigationPaneSize(
  //       openMaxWidth: 320.0,
  //       openMinWidth: 250.0,
  //     ),
  //     items: <NavigationPaneItem>[
  //       PaneItem(
  //           icon: const Icon(FluentIcons.home, size: 20,),
  //           title: const Text('Home'),
  //           body: const Text('Home body')
  //       ),
  //       PaneItem(
  //           icon: const Icon(FluentIcons.fabric_folder, size: 20,),
  //           title: const Text('Files'),
  //           body: const Text('Files body')
  //       ),
  //       PaneItem(
  //           icon: const Icon(FluentIcons.settings, size: 20,),
  //           title: const Text('Settings'),
  //           body: const Text('Settings body')
  //       ),
  //     ],
  //     selected:  _currentPage,
  //     onChanged: (index) => setState(() {
  //       _currentPage = index;
  //       _showDialog('Thông báo',"Bạn có muốn xoá không");
  //
  //     }),
  //   ),
  // );
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
  Future<Object?> _showMacDialog(String title, String contentTxt){
    return  Get.dialog(
      CupertinoAlertDialog(
        title:  Text(title),
        content: Text(contentTxt),
        actions: [
          CupertinoDialogAction(
            onPressed: () async {
              // var box = GetStorage('info',dir);
              // var idx = box.read('idx');
              // box.erase();
              // box.write('idx', idx);
              // Get.offAndToNamed('login');
              Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
            },
            isDefaultAction: true,
            child: const Text("はい"), // ok
          ),
          CupertinoDialogAction(
            onPressed: (){
              Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
            },
            child: const Text("キャンセル"), // cancel
          ),
        ],
      ),
      barrierDismissible: false,
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