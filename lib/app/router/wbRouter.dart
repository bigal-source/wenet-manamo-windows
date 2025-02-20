import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../utils/constants/strings.dart';
import '../../data/models/book_info.dart';
import '../../presentation/controllers/home/home_controller.dart';
import '../../presentation/pages/home/home_view.dart';
import '../../presentation/pages/login/login_view.dart';
import '../../presentation/views/book_detail.dart';
import '../../presentation/views/book_shelf.dart';
import '../../presentation/views/catalog.dart';
import '../../presentation/views/help.dart';
import '../../presentation/views/logout.dart';
import '../../presentation/views/policy.dart';
import '../../presentation/views/search.dart';
import '../../presentation/views/setting.dart';
import '../../presentation/views/slo.dart';
import '../../presentation/views/term.dart';
import '../../presentation/views/wb_dash_board.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final wbRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state){
    var box             = GetStorage('info',dir);
    final bool loggedIn = box.read('idx').isNotEmpty;
    if (!loggedIn) {
      return '/';
    }
    else if(loggedIn && state.location == '/'){
      return '/home';
    }
    return state.location;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => LoginView(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return WbDashBoard(
          shellContext: _shellNavigatorKey.currentContext,
          state: state,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => GetBuilder(
            init: HomeController(),
            dispose: (state) {
              Get.delete<HomeController>();
            },
            builder: (controller){
              return HomeView();
            },
          ),
        ),
        /// Catalog
        GoRoute(
          path: '/category',
          name: 'category',
          builder: (context, state) => const CatalogPage(),
        ),
        /// search
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (context, state) => const SearchPage(),
        ),
        /// book shelf
        GoRoute(
          path: '/bookshelf',
          name: 'bookshelf',
          builder: (context, state) => const BookShelfPage(),
        ),
        /// Book detail
        GoRoute(
          path: '/book-detail',
          name: 'book-detail',
          builder: (context, state) {
            Book bookItem = state.extra as Book;
            return BookDetailView(
              bookItem: bookItem,
            );
          },
        ),
        /// Policy
        GoRoute(
          path: '/policy',
          name: 'policy',
          builder: (context, state) => const PolicyView(),
        ),
        /// SloView
        GoRoute(
          path: '/slo',
          name: 'slo',
          builder: (context, state) => const SloView(),
        ),
        /// TermView
        GoRoute(
          path: '/term',
          name: 'term',
          builder: (context, state) => const TermView(),
        ),
        /// HelpView
        GoRoute(
          path: '/help',
          name: 'help',
          builder: (context, state) => const HelpView(),
        ),
        /// Logout
        GoRoute(
          path: '/logout',
          name: 'logout',
          builder: (context, state) => const LogoutView(),
        ),
        /// Setting
        GoRoute(
          path: '/setting',
          name: 'setting',
          builder: (context, state) => const SettingPage(),
        ),
      ],
    ),
  ],
);
