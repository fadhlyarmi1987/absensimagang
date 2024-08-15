import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../route/page.dart';
import '../views/auth/auth.controller.dart';
import '../views/dashboard/home.dart'; 

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
      if (isLogin) {
        Get.offNamed(Routes.dahsboard);
      } else {
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
