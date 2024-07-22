import 'package:absensimagang/route/page.dart';
import 'package:absensimagang/views/dashboard/dashboardcopy.dart';
import 'package:absensimagang/views/dashboard/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../utils/storage.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}

class AuthController extends GetxController {
  final Storage _storage = Storage();

  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerCPassword = TextEditingController();

  final String staticEmail = "sam@gmail.com";
  final String staticPassword = "admin123";

  bool isLogin = false;

  @override
  void onInit() {
    super.onInit();
    isLogin = _storage.isLogin();
    if (isLogin) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        print('object');
        Get.toNamed(Routes.dahsboard);
      });
    }
  }

  void login() {
    List<String> errors = [];

    // exception email
    if (controllerEmail.text.isEmpty) {
      errors.add('Email harus diisi');
    } else if (!controllerEmail.text.contains('@')) {
      errors.add('Email harus mengandung @');
    } else if (controllerEmail.text != staticEmail) {
      errors.add('email salah');
    }

    // exception password
    if (controllerPassword.text.isEmpty) {
      errors.add('Password harus diisi');
    } else if (controllerPassword.text.length < 8) {
      errors.add('Password harus lebih dari 8 karakter');
    } else if (controllerPassword.text != staticPassword) {
      errors.add('password salah');
    }

    if (errors.isEmpty) {
      if (controllerEmail.text == staticEmail &&
          controllerPassword.text == staticPassword) {
        print('Email: ${controllerEmail.text}');
        print('Password: ${controllerPassword.text}');
        Get.snackbar(
          'Login Berhasil',
          'Selamat datang!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
        );
        _storage.login();
        Get.toNamed(Routes.dahsboard);
      }
    } else {
      Get.snackbar(
        'Kesalahan',
        errors.join('\n'),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void register() {
    if (controllerNama.text.isNotEmpty) {
      print('nama: ${controllerNama.text}');
    }
    if (controllerEmail.text.isNotEmpty) {
      print('email: ${controllerEmail.text}');
    }
    if (controllerPassword.text.isNotEmpty) {
      print('password ${controllerPassword.text}');
    }
  }
}
