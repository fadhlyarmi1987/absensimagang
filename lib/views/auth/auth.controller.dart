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

  final String staticEmail = "sam@gmail.com";
  final String staticPassword = "admin123";

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

  // Metode baru untuk registrasi
  void register() async {
    List<String> errors = [];

    // Validasi input
    if (controllerNama.text.isEmpty) {
      errors.add('Nama harus diisi');
    }

    if (controllerEmail.text.isEmpty) {
      errors.add('Email harus diisi');
    } else if (!controllerEmail.text.contains('@')) {
      errors.add('Email harus mengandung @');
    }

    if (controllerPassword.text.isEmpty) {
      errors.add('Password harus diisi');
    } else if (controllerPassword.text.length < 8) {
      errors.add('Password harus lebih dari 8 karakter');
    }

    if (controllerPassword.text != controllerCPassword.text) {
      errors.add('Password dan konfirmasi password tidak cocok');
    }

    if (errors.isEmpty) {
      try {
        final response = await Dio().post(
          'http://192.168.1.20:8000/api/register',
          data: {
            'name': controllerNama.text,
            'email': controllerEmail.text,
            'password': controllerPassword.text,
            'password_confirmation': controllerCPassword.text,
            'user_type': isKaryawan.value ? 'Karyawan' : 'Magang',
          },
        );

        if (response.statusCode == 200) {
          Get.snackbar(
            'Registrasi Berhasil',
            'Akun berhasil dibuat. Silakan login.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.offNamed(Routes.init); // Redirect ke halaman login
        } else {
          Get.snackbar(
            'Registrasi Gagal',
            'Terjadi kesalahan. Silakan coba lagi.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } on DioError catch (e) {
        // Handle DioError
        Get.snackbar(
          'Registrasi Gagal',
          'Terjadi kesalahan: ${e.message}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        // Handle other errors
        Get.snackbar(
          'Registrasi Gagal',
          'Terjadi kesalahan: ${e.toString()}',
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
      showSnackbar('Kesalahan', errors.join('\n'), Colors.red, Colors.white, const Duration(seconds: 2), SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  //request login Rest-API
  Future<void> loginApi() async {
    if (!checkLogin()) return;
    bool result = await _authService.login({
      "username": controllerEmail.text,
      "password": controllerPassword.text,
    });

    if (result) {
      //_storage.login();
      showSnackbar('Login Berhasil', 'Selamat datang!', Colors.green, Colors.white, const Duration(seconds: 2), SnackPosition.BOTTOM);
      Get.offAllNamed(Routes.dahsboard);
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

    if (isKaryawan.isFalse || isMagang.isFalse) {
      errors.add('Anda belum memilih Karyawan atau Magang');
    }

    if (errors.isNotEmpty) {
      showSnackbar('Kesalahan', errors.join('\n'), Colors.red, Colors.white, const Duration(seconds: 2), SnackPosition.BOTTOM);
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
      showSnackbar('Registrasi Berhasil', 'Akun berhasil dibuat. Silakan login!', Colors.green, Colors.white, const Duration(seconds: 2), SnackPosition.BOTTOM);
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
