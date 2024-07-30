import 'package:absensimagang/data/services/auth.service.dart';
import 'package:absensimagang/route/page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/storage.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final Storage _storage = Storage();

  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerCPassword = TextEditingController();
  var isKaryawan = false.obs;
  var isMagang = false.obs;

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

  void login() async {
    List<String> errors = [];

    // exception email
    if (controllerEmail.text.isEmpty) {
      errors.add('Email harus diisi');
    } else if (!controllerEmail.text.contains('@')) {
      errors.add('Email harus mengandung @');
    }

    // exception password
    if (controllerPassword.text.isEmpty) {
      errors.add('Password harus diisi');
    } else if (controllerPassword.text.length < 8) {
      errors.add('Password harus lebih dari 8 karakter');
    }

    if (errors.isEmpty) {
      
        print('Email: ${controllerEmail.text}');
        print('Password: ${controllerPassword.text}');

        bool result = await _authService.login({
          'username': controllerEmail.text,
          'password': controllerPassword.text,
        });

        if (result) {
          Get.snackbar(
            'Login Berhasil',
            'Selamat datang!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
          );
          //_storage.login();
          Get.toNamed(Routes.dahsboard);
        } else {
          Get.snackbar(
            'Login Gagal',
            'Cek kembali email / password anda',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
          );
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

  void register() async {
    if (controllerNama.text.isEmpty) {
      print('nama: ${controllerNama.text}');
    } else if (controllerEmail.text.isEmpty) {
      print('email: ${controllerEmail.text}');
    } else if (controllerPassword.text.isEmpty) {
      print('password ${controllerPassword.text}');
    } else if (controllerCPassword.text.isEmpty) {
      print('password ${controllerPassword.text}');
    } else if (controllerPassword.text!=controllerCPassword.text){
      print('Confirmasi password salah');
    }else {
      bool result = await _authService.register({
        "nama": controllerNama.text,
        "email": controllerEmail.text,
        "password": controllerPassword.text,
        "c_password": controllerCPassword.text,
        "user_value": isKaryawan
      });

      if (isKaryawan.value) {
    } else if (isMagang.value) {
    } else {
    }

      if (result){
        print('sukses');
      }else{
        print('gagal');
      }
    }
  }
}
