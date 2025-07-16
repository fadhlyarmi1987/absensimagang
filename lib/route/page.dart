import 'package:absensimagang/screens/splash_screen.dart';
import 'package:absensimagang/views/Admin/admin_dashboard.dart';
//import 'package:absensimagang/views/Admin/admin_dashboard.dart';
import 'package:absensimagang/controller/auth.controller.dart';
import 'package:absensimagang/views/Admin/list_karyawan_page.dart';
import 'package:absensimagang/views/auth/login_page.dart';
import 'package:absensimagang/views/dashboard/izin.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import '../views/auth/register_page.dart';
import '../controller/dashboard.controller.dart';
import '../views/dashboard/dashboard.dart';
part 'routes.dart';

List <GetPage> pages=[
  GetPage(
    name: Routes.splash,
    page: () => SplashScreen(),
    // transition: Transition.fade,
    // transitionDuration: Duration(milliseconds: 800),
  ),
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
  GetPage(
    name: Routes.adminpage, 
    page: () => AdminDashboard(),
    //binding: DashboardBinding(),
    // transition: Transition.cupertino,
    // transitionDuration: Duration(milliseconds: 800),
  ),
  GetPage(
    name: Routes.listkaryawan, 
    page: () => ListKaryawanPage(),
    //binding: DashboardBinding(),
    // transition: Transition.cupertino,
    // transitionDuration: Duration(milliseconds: 800),
  ),
  GetPage(
    name: Routes.izin, 
    page: () => IzinPage(),
    //binding: DashboardBinding(),
    // transition: Transition.cupertino,
    // transitionDuration: Duration(milliseconds: 800),
  ),
];