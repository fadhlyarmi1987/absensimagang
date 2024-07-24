import 'package:absensimagang/views/auth/auth.controller.dart';
import 'package:absensimagang/views/auth/login_page.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';

import '../views/auth/register_page.dart';
import '../views/dashboard/dashboard.controller.dart';
import '../views/dashboard/dashboard.dart';
part 'routes.dart';

List <GetPage> pages=[
  GetPage(
    name: Routes.init, 
    page: () => LoginPage(),
    binding: AuthBinding(),
    transition: Transition.cupertinoDialog,
    transitionDuration: const Duration(milliseconds: 800),
  ),
  GetPage(
    name: Routes.register, 
    page: () => RegisterPage(),
    binding: AuthBinding(),
    transition: Transition.cupertinoDialog,
    transitionDuration: Duration(milliseconds: 800),
  ),
  GetPage(
    name: Routes.dahsboard, 
    page: () => DashboardPage(),
    binding: DashboardBinding(),
    transition: Transition.cupertino,
    transitionDuration: Duration(milliseconds: 800),
  ),
];