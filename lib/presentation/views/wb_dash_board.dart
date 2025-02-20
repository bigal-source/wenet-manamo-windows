import 'dart:core';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../../app/config/theme.dart';
import '../../app/router/router.dart';
import '../../app/utils/setting.dart';
import '../../desktop.dart';
import 'link_item.dart';


class WbDashBoard extends StatefulWidget {
  const WbDashBoard({
    super.key,
    required this.child,
    required this.shellContext,
    required this.state,
  });

  final Widget child;
  final BuildContext? shellContext;
  final GoRouterState state;

  @override
  State<WbDashBoard> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<WbDashBoard> with WindowListener {
  bool value = false;
  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  final searchKey = GlobalKey(debugLabel: 'Search Bar Key');
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();
  final List<NavigationPaneItem> originalItems = [
    PaneItem(
      key: const Key('/home'),
      icon: const Icon(FluentIcons.home),
      title: const Text('Home'),
      body: const SizedBox.shrink(),
      onTap: () {
        if (router.location != '/home') router.pushNamed('home');
      },
    ),
    PaneItem(
      key: const Key('/category'),
      icon: const Icon(FluentIcons.open_folder_horizontal),
      title: const Text('カテゴリ'),
      body: const SizedBox.shrink(),
      onTap: () {
        if (router.location != '/category') router.pushNamed('category');
      },
    ),
    PaneItem(
      key: const Key('/search'),
      icon: const Icon(FluentIcons.search),
      title: const Text('検索'),
      body: const SizedBox.shrink(),
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
        if (kDebugMode) {
          print("tap notice");
        }
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
  final List<NavigationPaneItem> footerItems = [
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

  int _calculateSelectedIndex(BuildContext context) {
    final location = router.location;
    int indexOriginal = originalItems
        .where((element) => element.key != null)
        .toList()
        .indexWhere((element) => element.key == Key(location));

    if (indexOriginal == -1) {
      int indexFooter = footerItems
          .where((element) => element.key != null)
          .toList()
          .indexWhere((element) => element.key == Key(location));
      if (indexFooter == -1) {
        return 0;
      }
      return originalItems
          .where((element) => element.key != null)
          .toList()
          .length +
          indexFooter;
    } else {
      return indexOriginal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FluentLocalizations.of(context);
    final appTheme = context.watch<AppTheme>();
    final theme = FluentTheme.of(context);
    if (kDebugMode) {
      print("widget.state.location ${widget.state.location}");
    }
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
          final enabled = widget.shellContext != null && router.canPop();

          final onPressed = enabled
              ? () {
            if (router.canPop()) {
              context.pop();
              setState(() {});
            }
          }
              : null;
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
                enabled: enabled,
              ).build(
                context,
                false,
                onPressed,
                displayMode: PaneDisplayMode.compact,
              ),
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
        autoSuggestBox: AutoSuggestBox(
          key: searchKey,
          focusNode: searchFocusNode,
          controller: searchController,
          unfocusedColor: Colors.transparent,
          items: originalItems.whereType<PaneItem>().map((item) {
            assert(item.title is Text);
            final text = (item.title as Text).data!;
            return AutoSuggestBoxItem(
              label: text,
              value: text,
              onSelected: () {
                item.onTap?.call();
                searchController.clear();
              },
            );
          }).toList(),
          trailingIcon: IgnorePointer(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(FluentIcons.search),
            ),
          ),
          placeholder: 'Search',
        ),
        autoSuggestBoxReplacement: const Icon(FluentIcons.search),
        footerItems: footerItems,
      ),
      onOpenSearch: () {
        searchFocusNode.requestFocus();
      },
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
            title: const Text('Confirm close'),
            content: const Text('Are you sure you want to close this window?'),
            actions: [
              FilledButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.destroy();
                },
              ),
              Button(
                child: const Text('No'),
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
}
