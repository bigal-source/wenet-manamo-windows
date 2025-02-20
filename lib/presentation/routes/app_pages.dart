
import 'package:get/get.dart';
import '../controllers/home/home_binding.dart';
import '../controllers/static/static_binding.dart';
import '../pages/book/book.dart';
import '../pages/static/policy_page.dart';
import '../views/home.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const login         = Routes.login;
  static const board         = Routes.board;
  static const home          = Routes.home;

  static final routes = [

    // GetPage(
    //     name: _Paths.login,
    //     page: () => LoginView(),
    //     binding: LoginBinding(),
    //     children: const[]
    // ),
    // GetPage(
    //     name: _Paths.board,
    //     page: () => const BoardView(),
    //     binding: BoardBinding(),
    //     children: const[]
    // ),
    GetPage(
        name: _Paths.home,
        page: () => const HomePage(),
        binding: HomeBinding(),
        children: [
          GetPage(
              name: _Paths.book,
              page: () => const BookView(),
          ),
        ]
    ),
    GetPage(
        name: _Paths.policy,
        page: () => const PolicyPage(),
        binding: StaticBinding(),
        children: const[]
    ),
    // GetPage(
    //     name: _Paths.book,
    //     page: () => const BookView(),
    //     binding: BookBinding(),
    //     children: const[
    //
    //     ]
    // ),
    // GetPage(
    //     name: _Paths.policy,
    //     page: () =>  const PolicyView(),
    //     binding: StaticBinding(),
    //     children: const[]
    // ),
  ];
}