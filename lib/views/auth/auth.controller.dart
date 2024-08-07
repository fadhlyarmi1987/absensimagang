import 'package:absensimagang/data/services/auth.service.dart';
import 'package:absensimagang/route/page.dart';
import 'package:dio/dio.dart';
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

  bool isLogin = false;

  @override
  void onInit() {
    super.onInit();
    isLogin = _storage.isLogin();
    if (isLogin) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        Get.toNamed(Routes.dahsboard);
      });
    }
  }

  // -- review code -- //
  //check login
  bool checkLogin() {
    List<String> errors = [];

    if (controllerEmail.text.isEmpty) {
      errors.add('Email harus diisi');
    } else if (!controllerEmail.text.contains('@')) {
      errors.add('Email harus mengandung simbol @');
    }

    if (controllerPassword.text.isEmpty) {
      errors.add('Password harus diisi');
    } else if (controllerPassword.text.length < 8) {
      errors.add('Password harus lebih dari 8 karakter');
    }

    if (errors.isNotEmpty) {
      showSnackbar('Kesalahan', errors.join('\n'), Colors.red, Colors.white,
          const Duration(seconds: 2), SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  //request login Rest-API
  Future<void> loginApi() async {
    if (!checkLogin()) return;
    Map<String, dynamic> result = await _authService.login({
      "username": controllerEmail.text,
      "password": controllerPassword.text,
      "name": controllerNama.text,
    });

    if (result['success']) {
      String name = result['name'] ?? 'Pengguna';
      showSnackbar('Login Berhasil', 'Selamat datang, $name!', Colors.green,
          Colors.white, const Duration(seconds: 2), SnackPosition.BOTTOM);
      _storage.login(); 
      _storage.name(name);
      Get.offAllNamed(Routes.dahsboard);
    } else {
      showSnackbar('Login Gagal', 'Silakan coba lagi!', Colors.red,
          Colors.white, const Duration(seconds: 2), SnackPosition.BOTTOM);
    }
  }

  //check register
  bool checkRegister() {
    List<String> errors = [];

    if (controllerNama.text.isEmpty) {
      errors.add('Nama harus diisi');
    }

    if (controllerEmail.text.isEmpty) {
      errors.add('Email harus diisi');
    } else if (!controllerEmail.text.contains('@')) {
      errors.add('Email harus mengandung simbol @');
    }

    if (controllerPassword.text.isEmpty) {
      errors.add('Password harus diisi');
    } else if (controllerPassword.text.length < 8) {
      errors.add('Password harus lebih dari 8 karakter');
    }

    if (controllerPassword.text != controllerCPassword.text) {
      errors.add('Password dan konfirmasi password tidak cocok');
    }

    if (isKaryawan.value == isMagang.value) {
      errors.add('Anda belum memilih Karyawan atau Magang');
    }

    if (errors.isNotEmpty) {
      showSnackbar('Kesalahan', errors.join('\n'), Colors.red, Colors.white,
          const Duration(seconds: 2), SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  //request register Rest-API
  Future<void> registerApi() async {
    if (!checkRegister()) return;
    bool result = await _authService.register({
      "name": controllerNama.text,
      "email": controllerEmail.text,
      "password": controllerPassword.text,
      "password_confirmation": controllerCPassword.text,
      "user_type": isKaryawan.value ? 'Karyawan' : 'Magang',
    });

    if (result) {
      showSnackbar(
          'Registrasi Berhasil',
          'Akun berhasil dibuat. Silakan login!',
          Colors.green,
          Colors.white,
          const Duration(seconds: 2),
          SnackPosition.BOTTOM);
      Get.offAllNamed(Routes.init);
    }
  }

  // function show snackbar
  void showSnackbar(
    String title,
    String message,
    Color colorBackground,
    Color textColor,
    Duration duration,
    SnackPosition position,
  ) {
    Get.snackbar(
      title,
      message,
      backgroundColor: colorBackground,
      colorText: textColor,
      duration: duration,
      snackPosition: position,
    );
  }
}
