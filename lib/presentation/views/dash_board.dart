import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../../app/config/theme.dart';
import '../../app/router/router.dart';
import '../../app/services/authen_service.dart';
import '../../app/services/change_pass_service.dart';
import '../../app/services/connectivity_service.dart';
import '../../app/utils/constants/strings.dart';
import '../../app/utils/setting.dart';
import '../../desktop.dart';
import '../controllers/change_mail/change_mail_controller.dart';
import '../controllers/change_pass/change_pass_controller.dart';
import 'link_item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.child,
    required this.shellContext,
    required this.state,
  });

  final Widget child;
  final BuildContext? shellContext;
  final GoRouterState state;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  var auth               = Get.put(AuthenService());
  var connect            = Get.put(ConnectivityService());
  bool value             = false;
  bool isNavi            = true;
  var box                = GetStorage('info',dir);
  final viewKey          = GlobalKey(debugLabel: 'Navigation View Key');
  final searchKey        = GlobalKey(debugLabel: 'Search Bar Key');
  final searchFocusNode  = FocusNode();
  final searchController = TextEditingController();

  late List<NavigationPaneItem> originalItems = [];
  late List<NavigationPaneItem> footerItems   = [];
  StreamController controller = StreamController();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("initState Dashboard");
    }
    windowManager.addListener(this);
    originalItems = [
      PaneItem(
        key: const Key('/home'),
        icon: const Icon(FluentIcons.home),
        title: const Text('HOME'),
        body: const SizedBox.shrink(),
        enabled: auth.isLogin.isFalse,
        onTap: () {
          if (router.location != '/home') router.pushNamed('home');
        },
      ),
      PaneItem(
        key: const Key('/category'),
        icon: const Icon(FluentIcons.open_folder_horizontal),
        title: const Text('カテゴリ'),
        body: const SizedBox.shrink(),
        enabled: auth.isLogin.isFalse,
        onTap: () {
          if (router.location != '/category') router.pushNamed('category');
        },
      ),
      PaneItem(
        key: const Key('/search'),
        icon: const Icon(FluentIcons.search),
        title: const Text('検索'),
        body: const SizedBox.shrink(),
        enabled: auth.isLogin.isFalse,
        onTap: () {
          if (router.location != '/search') router.pushNamed('search');
        },
      ),
      PaneItem(
        key: const Key('/bookshelf'),
        icon: const Icon(FluentIcons.library),
        title: const Text('本棚'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (router.location != '/bookshelf') router.pushNamed('bookshelf');
        },
      ),
      PaneItem(
        key: const Key('/logout'),
        icon: const Icon(FluentIcons.lock_solid),
        title: const Text('ログアウト'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (router.location != '/logout') router.pushNamed('logout');
        },
      ),
      PaneItem(
        key: const Key('/notice'),
        icon: const Icon(FluentIcons.info),
        title: const Text('お知らせ'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (router.location != '/notice') {
            router.pushNamed('notice');
          }
        },
      ),
      PaneItem(
        key: const Key('/policy'),
        icon: const Icon(FluentIcons.contact),
        title: const Text('プライバシーポリシー'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (router.location != '/policy') {
            router.namedLocation('policy');
            router.pushNamed('policy');
          }
        },
      ),
      PaneItem(
        key: const Key('/slo'),
        icon: const Icon(FluentIcons.completed12),
        title: const Text('SLOガイドライン'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (router.location != '/slo') {
            router.pushNamed('slo');
          }
        },
      ),
      PaneItem(
        key: const Key('/term'),
        icon: const Icon(FluentIcons.edit_solid12),
        title: const Text('利用規約'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (router.location != '/term') {
            router.pushNamed('term');
          }
        },
      ),
      PaneItem(
        key: const Key('/help'),
        icon: const Icon(FluentIcons.book_answers),
        title: const Text('ヘルプ'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (router.location != '/help') {
            router.pushNamed('help');
          }
        },
      ),
    ];
    footerItems   = [
      PaneItemSeparator(),
      PaneItem(
        key: const Key('/setting'),
        icon: const Icon(FluentIcons.settings),
        title: const Text('Settings'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (router.location != '/setting') {
            router.pushNamed('setting');
          }
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
    sortMenuItems();
  }

  @override
  void didChangeDependencies() {
    MediaQuery.of(context);
    super.didChangeDependencies();
    if (kDebugMode) {
      print("didChangeDependencies");
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location    = router.location;
    int indexOriginal = originalItems.where((element) => element.key != null).toList().indexWhere((element) => element.key == Key(location));
    if (kDebugMode) {
      print('indexOriginal $indexOriginal');
    }
    if (indexOriginal == -1) {
      isNavi  = false;
      return 0;
    } else {
      if (kDebugMode) {
        print('indexOriginal $indexOriginal');
      }
      if(indexOriginal == 0){
        isNavi  = false;
      }else{
        isNavi  = true;
      }
      return indexOriginal;
    }
  }

  @override
  Widget build(BuildContext context) {
    sortMenuItems();
    final localizations = FluentLocalizations.of(context);
    final appTheme      = context.watch<AppTheme>();
    final theme         = FluentTheme.of(context);
    if (widget.shellContext != null) {
      if (router.canPop() == false) {
        setState(() {});
      }
    }
    return NavigationView(
      key: viewKey,
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        leading: () {
          // final enabled = widget.shellContext != null && router.canPop();
          // if (kDebugMode) {
          //   print('enabled $enabled');
          // }
          final onPressed = isNavi ? () {
            if (router.canPop()) {
              context.pop();
              setState(() {});
            }
          }: null;
          return NavigationPaneTheme(
            data: NavigationPaneTheme.of(context).merge(NavigationPaneThemeData(
              unselectedIconColor: ButtonState.resolveWith((states) {
                if (states.isDisabled) {
                  return ButtonThemeData.buttonColor(context, states);
                }
                return ButtonThemeData.uncheckedInputColor(
                  FluentTheme.of(context),
                  states,
                ).basedOnLuminance();
              }),
            )),
            child: Builder(
              builder: (context) => PaneItem(
                icon: const Center(child: Icon(FluentIcons.back, size: 12.0)),
                title: Text(localizations.backButtonTooltip),
                body: const SizedBox.shrink(),
                enabled: isNavi,
              ).build( context, false, onPressed, displayMode: PaneDisplayMode.compact, ),
            ),
          );
        }(),
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
        actions: Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
          // Padding(
          //   padding: const EdgeInsetsDirectional.only(end: 8.0),
          //   child: ToggleSwitch(
          //     content: const Text('Dark Mode'),
          //     checked: FluentTheme.of(context).brightness.isDark,
          //     onChanged: (v) {
          //       if (v) {
          //         appTheme.mode = ThemeMode.dark;
          //       } else {
          //         appTheme.mode = ThemeMode.light;
          //       }
          //     },
          //   ),
          // ),
          if (!kIsWeb) WindowButtons(),
        ]),
      ),
      paneBodyBuilder: (item, child) {
        final name = item?.key is ValueKey ? (item!.key as ValueKey).value : null;
        return FocusTraversalGroup(
          key: ValueKey('body$name'),
          child: widget.child,
        );
      },
      pane: NavigationPane(
        selected: _calculateSelectedIndex(context),
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
        autoSuggestBoxReplacement: const Icon(FluentIcons.search),
        onChanged: (index) async {
          if (auth.isLogin.isFalse) {
            await ChangeMailServices().checkChangeEmail(auth.idx.value, auth.corpId.value).then((value) {
              auth.checkChangeMail.value = value.mailChangeFlg!;
            });
            setState(() {
                if (kDebugMode) {
                  print("index $index");
                  print("disconnect ${auth.isConnected}");
                }
              if(index == 4 && auth.isLogin.isFalse && auth.isConnected.isTrue ){
                logOutDialog();
              }
              if(index == 1 && !auth.isLogin.isFalse){
                //logOutDialog();
                if (kDebugMode) {
                  print("Login");
                }
              }
              if(index == 0){
                isNavi = false;
              }
            });
          }
        }
      ),
      onOpenSearch: () {searchFocusNode.requestFocus();},
    );
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    preventClose(isPreventClose);
  }

  void preventClose(bool isPreventClose) {
    if (isPreventClose) {
      showDialog(
        context: context,
        builder: (_) {
          return ContentDialog(
            title: const Text('アプリの終了'),
            content: const Text('アプリを終了してもよろしいですか？'),
            actions: [
              FilledButton(
                autofocus: true,
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.destroy();
                },
                child: const Text('はい'),
              ),
              Button(
                child: const Text('いいえ'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  void logOutDialog() async {
    showDialog(
      context: context,
      builder: (_) {
        return ContentDialog(
          title: const Text('ログアウト'),
          content: const Text('ログアウトしますか？'),
          actions: [
            FilledButton(
              child: const Text('はい'), // yes
              onPressed: () async {
                Navigator.pop(context);
                // var idx = box.read('idx');
                // box.erase();
                // box.write('idx', idx);
                await auth.onInit();
                auth.isLogin.value = true;
                // if(FirebaseAuth.instance.currentUser != null){
                //   FirebaseAuth.instance.signOut();
                // }
                router.goNamed('login');
                // context.go('/');
              },
            ),
            Button(
              child: const Text('いいえ'), // cancel いいえ - ログイン
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

  void sortMenuItems() {
    var auth = Get.put(AuthenService());
    PaneItem data = PaneItem(
      key: const Key('/changeMail'),
      icon: const Icon(IconData(0xe3c3, fontFamily: 'MaterialIcons')),
      title: const Text('ID（メールアドレス）変更'),
      body: const SizedBox.shrink(),
      onTap: () {
        Get.lazyPut(() => ChangeMailController());
        if (router.location != '/change-mail') router.pushNamed('change-mail');
      },
    );
    
    if(!auth.isLogin.isFalse || auth.isConnected.isFalse){ //todo: unauthenticated or
      originalItems = [
        PaneItem(
          key: const Key('/bookshelf'),
          icon: const Icon(FluentIcons.library),
          title: const Text('本棚'),
          body: const SizedBox.shrink(),
          onTap: () {
            if (router.location != '/bookshelf') router.pushNamed('bookshelf');
          },
        ),
        PaneItem(
          key: const Key('/login'),
          icon: const Icon(FluentIcons.lock_solid),
          title: const Text('ログイン'),
          body: const SizedBox.shrink(),
          onTap: () {
            if (router.location != '/login') router.pushNamed('login');
          },
        ),
        PaneItem(
          key: const Key('/notice'),
          icon: const Icon(FluentIcons.info),
          title: const Text('お知らせ'),
          body: const SizedBox.shrink(),
          onTap: () {
            if (router.location != '/notice') {
              router.pushNamed('notice');
            }
          },
        ),
        PaneItem(
          key: const Key('/policy'),
          icon: const Icon(FluentIcons.contact),
          title: const Text('プライバシーポリシー'),
          body: const SizedBox.shrink(),
          onTap: () {
            if (router.location != '/policy') {
              router.namedLocation('policy');
              router.pushNamed('policy');
            }
          },
        ),
        PaneItem(
          key: const Key('/slo'),
          icon: const Icon(FluentIcons.completed12),
          title: const Text('SLOガイドライン'),
          body: const SizedBox.shrink(),
          onTap: () {
            if (router.location != '/slo') {
              router.pushNamed('slo');
            }
          },
        ),
        PaneItem(
          key: const Key('/term'),
          icon: const Icon(FluentIcons.edit_solid12),
          title: const Text('利用規約'),
          body: const SizedBox.shrink(),
          onTap: () {
            if (router.location != '/term') {
              router.pushNamed('term');
            }
          },
        ),
        PaneItem(
        key: const Key('/change-pass'),
        icon: const Icon(IconData(0xf052b, fontFamily: 'MaterialIcons')),
        title: const Text('パスワード再発行'),
        body: const SizedBox.shrink(),
        onTap: () {
          Get.lazyPut(() => ChangePassController());
          if (router.location != '/change-pass') {
            router.pushNamed('change-pass');
          }
        },
        ),
        PaneItem(
          key: const Key('/help'),
          icon: const Icon(FluentIcons.book_answers),
          title: const Text('ヘルプ'),
          body: const SizedBox.shrink(),
          onTap: () {
            if (router.location != '/help') {
              router.pushNamed('help');
            }
          },
        ),
      ];
    }else{ 
      setState(() {});                   //todo: authenticated
      originalItems = [
        PaneItem(
          key: const Key('/home'),
          icon: const Icon(FluentIcons.home),
          title: const Text('HOME'),
          body: const SizedBox.shrink(),
          enabled: auth.isLogin.isFalse,
          onTap: () {
            if (router.location != '/home') router.pushNamed('home');
          },
        ),
        PaneItem(
          key: const Key('/category'),
          icon: const Icon(FluentIcons.open_folder_horizontal),
          title: const Text('カテゴリ'),
          body: const SizedBox.shrink(),
          enabled: auth.isLogin.isFalse,
          onTap: () {
            if (router.location != '/category') router.pushNamed('category');
          },
        ),
        PaneItem(
          key: const Key('/search'),
          icon: const Icon(FluentIcons.search),
          title: const Text('検索'),
          body: const SizedBox.shrink(),
          enabled: auth.isLogin.isFalse,
          onTap: () {
            if (router.location != '/search') router.pushNamed('search');
          },
        ),
        PaneItem(
          key: const Key('/bookshelf'),
          icon: const Icon(FluentIcons.library),
          title: const Text('本棚'),
          body: const SizedBox.shrink(),
          onTap: () {
            if (router.location != '/bookshelf') router.pushNamed('bookshelf');
          },
        ),
        PaneItem(
          key: const Key('/logout'),
          icon: const Icon(FluentIcons.lock_solid),
          title: const Text('ログアウト'),
          body: const SizedBox.shrink(),
          onTap: () {
            if (router.location != '/logout') router.pushNamed('logout');
          },
        ),
        PaneItem(
          key: const Key('/notice'),
          icon: const Icon(FluentIcons.info),
          title: const Text('お知らせ'),
          body: const SizedBox.shrink(),
          onTap: () {
            if (router.location != '/notice') {
              router.pushNamed('notice');
            }
          },
        ),
        PaneItem(
          key: const Key('/policy'),
          icon: const Icon(FluentIcons.contact),
          title: const Text('プライバシーポリシー'),
          body: const SizedBox.shrink(),
          onTap: () {
            if (router.location != '/policy') {
              router.namedLocation('policy');
              router.pushNamed('policy');
            }
          },
        ),
        PaneItem(
          key: const Key('/slo'),
          icon: const Icon(FluentIcons.completed12),
          title: const Text('SLOガイドライン'),
          body: const SizedBox.shrink(),
          onTap: () {
            if (router.location != '/slo') {
              router.pushNamed('slo');
            }
          },
        ),
        PaneItem(
          key: const Key('/change-pass'),
          icon: const Icon(IconData(0xf052b, fontFamily: 'MaterialIcons')),
          title: const Text('パスワード再発行'),
          body: const SizedBox.shrink(),
          onTap: () {
            Get.lazyPut(() => ChangePassController());
            if (router.location != '/change-pass') {
              router.pushNamed('change-pass');
            }
          },
        ),
        PaneItem(
          key: const Key('/term'),
          icon: const Icon(FluentIcons.edit_solid12),
          title: const Text('利用規約'),
          body: const SizedBox.shrink(),
          onTap: () {
            if (router.location != '/term') {
              router.pushNamed('term');
            }
          },
        ),
        PaneItem(
          key: const Key('/help'),
          icon: const Icon(FluentIcons.book_answers),
          title: const Text('ヘルプ'),
          body: const SizedBox.shrink(),
          onTap: () {
            if (router.location != '/help') {
              router.pushNamed('help');
            }
          },
        ),
      ];
      if (auth.checkChangeMail.value == 1) {
        originalItems.insert(originalItems.length - 2, data);
        setState(() {});
      }
    }

    footerItems   = [
      PaneItemSeparator(),
      PaneItem(
        key: const Key('/setting'),
        icon: const Icon(FluentIcons.settings),
        title: const Text('Settings'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (router.location != '/setting') {
            router.pushNamed('setting');
          }
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
  }
}
