import 'package:absensimagang/views/Admin/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../route/page.dart';
import '../controller/auth.controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }

    Future.delayed(Duration(milliseconds: 3000), () {
      bool isLogin = Get.find<AuthController>().isLogin;
      String userType = Get.find<AuthController>().userType.value;

      if (isLogin) {
        // Jika sudah login, arahkan ke halaman berdasarkan user_type
        if (userType == 'karyawan') {
          Get.offNamed(Routes.dahsboard); 
        } else if (userType == 'admin') {
          Get.to(AdminDashboard());
        }
      } else {
        // Jika belum login, arahkan ke halaman login
        Get.offNamed(Routes.init);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Logo_Natusi.png', height: 150),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
