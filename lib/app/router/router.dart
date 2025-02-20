import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
import '../../presentation/controllers/change_mail/change_mail_controller.dart';
import '../../presentation/controllers/change_pass/change_pass_controller.dart';
import '../../presentation/controllers/input_keyword/input_keyword_controller.dart';
import '../../presentation/pages/change_pass/change_pass_view.dart';
import '../../presentation/pages/input_keyword/input_keyword_view.dart';
import '../../presentation/controllers/book_detail/book_detail_controller.dart';
import '../../presentation/controllers/windows/window_controller.dart';
import '../../presentation/controllers/windows/window_off_controller.dart';
import '../../presentation/pages/change_mail/change_mail_view.dart';
import '../../presentation/pages/windows/window_off_view.dart';
import '../../presentation/pages/windows/window_view.dart';
import '/app/services/authen_service.dart';
import '../../presentation/controllers/book_shelf/book_shelf_controller.dart';
import '../../presentation/controllers/notice/notice_controller.dart';
import '../../presentation/controllers/search/search_controller.dart';
import '../../presentation/pages/book_detail/book_detail.dart';
import '../../presentation/controllers/catalog/catalog_controller.dart';
import '../../presentation/pages/book_shelf/book_shelf_view.dart';
import '../../presentation/pages/catalog/catalog_view.dart';
import '../../presentation/pages/catalog_detail/catalog_detail_view.dart';
import '../../presentation/pages/notice/notice.dart';
import '../../presentation/pages/search/search_view.dart';
import '../../data/models/book_info.dart';
import '../../presentation/controllers/home/home_controller.dart';
import '../../presentation/pages/home/home_view.dart';
import '../../presentation/pages/login/login_view.dart';
import '../../presentation/views/dash_board.dart';
import '../../presentation/views/help.dart';
import '../../presentation/views/logout.dart';
import '../../presentation/views/policy.dart';
import '../../presentation/views/setting.dart';
import '../../presentation/views/slo.dart';
import '../../presentation/views/term.dart';

final rootNavigatorKey   = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state){

    final auth               = Get.put(AuthenService());
    final bool authenticated = auth.idx.value != 'null' ? true : false;
    
  
    if (authenticated && state.location == '/') {
      return '/home';
      
    }
    else if(!authenticated && state.location == '/'){
      return '/bookshelf';
    }
    else{
      return state.location;
    }
  },
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MyHomePage(
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
          builder: (context, state) => GetBuilder(
            init: CatalogController(),
            dispose: (state) {
              Get.delete<CatalogController>();
            },
            builder: (controller){
              return CatalogView();
            },
          ),
        ),
        /// Catalog Detail
        GoRoute(
          path: '/category-detail',
          name: 'category-detail',
          builder: (context, state){
            BookCate cateBook = state.extra as BookCate;
            return CatalogDetailView(
              cateBook: cateBook,
            );
          },
        ),
        /// search
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (context, state) => GetBuilder(
            init: SearchBookController(),
            dispose: (state) {
              Get.delete<SearchBookController>();
            },
            builder: (controller){
              return SearchView();
            },
          ),
          // builder: (context, state) => const SearchPage(),
        ),
        /// book shelf
        GoRoute(
          path: '/bookshelf',
          name: 'bookshelf',
          builder: (context, state){
            return GetBuilder<BookShelfController>(
              init: BookShelfController(),
              initState: (_) => BookShelfController.to.getListCategory(),
              // dispose: (state) { Get.delete<BookDetailController>();},
              builder: (s){  return BookShelf();},
            );
          },
        ),
        /// Book detail
        GoRoute(
          path: '/book-detail',
          name: 'book-detail',
          builder: (context, state){
            Book bookItem = state.extra as Book;
            return GetBuilder<BookDetailController>(
              init: BookDetailController(),
              initState: (_) => BookDetailController.to.getBookDetail(bookItem.bookId!),
              builder: (s){  return BookDetailPage( bookItem: bookItem, script: s.description);},
            );
          },
        ),
        /// Policy
        GoRoute(
          path: '/notice',
          name: 'notice',
          builder: (context, state){
            return GetBuilder<NoticeController>(
              init: NoticeController(),
              initState: (_) => NoticeController.to.getNotice(),
              builder: (s){  return NoticePage();},
            );
          },
          // builder: (context, state) => const NoticePage(),
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
        /// ChangePass
        GoRoute(
          path: '/change-pass',
          name: 'change-pass',
          builder: (context, state) {
            return GetBuilder<ChangePassController>(
              init: ChangePassController(),
              initState: (_) => ChangePassController.to.onInit(),
              builder: (s) {
                return const ChangePassView();
              },
            );
          },
        ),
        /// ChangeMail
        GoRoute(
          path: '/change-mail',
          name: 'change-mail',
          builder: (context, state) {
            return GetBuilder<ChangeMailController>(
              init: ChangeMailController(),
              initState: (_) => ChangeMailController.to.onInit(),
              builder: (s) {
                return const ChangeMailView();
              },
            );
          },
        ),
        /// InputKeyword
        GoRoute(
          path: '/input-keyword',
          name: 'input-keyword',
          builder: (context, state) {
            String txtMail = state.extra.toString();
            return GetBuilder<InputKeyWordController>(
              init: InputKeyWordController(),
              initState: (_) => BookDetailController.to.onInit(),
              builder: (s) {
                return InputKeyword(txtMail: txtMail);
                },
            );
          },
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
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => LoginView(),
        ),
        /// Setting
        GoRoute(
          path: '/setting',
          name: 'setting',
          builder: (context, state) => const SettingPage(),
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/windows',
      name: 'windows',
      builder: (context, state){
        final auth               = Get.put(AuthenService());
        Map<String, dynamic>? bookItem = state.extra as Map<String, dynamic>?;
        if (bookItem != null) {
          String url = bookItem['url'];

        }
        return GetBuilder<WindowController>(
          init: WindowController(),
          initState: (_) => WindowController.to.initPlatformState(bookItem!),
          dispose:(state) async => {
          },
          builder: (s){
            s.wController.executeScript('document.cookie = "PHPSESSID=${auth.session.value}"');
            return WindowView();
            },
        );
      },
     // builder: (context, state) => WindowView(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/windows-off',
      name: 'windows-off',
      builder: (context, state){
        Map<String, dynamic>? bookItem = state.extra as Map<String, dynamic>?;
        if (bookItem != null) {
          String name = bookItem['url'];
        }
        return GetBuilder<WindowOffController>(
          init: WindowOffController(),
          initState: (_) async {
            await WindowOffController.to.initPlatformState(bookItem!);
          },
          dispose:(state) async {
            if (await windowManager.isFullScreen()) {
              await windowManager.setFullScreen(false);
            }
          },
          builder: (s) {
            return WindowOffView();
          },
        );
      },
      // builder: (context, state) => WindowView(),
    ),
  ],
);
