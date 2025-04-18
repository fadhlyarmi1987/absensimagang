import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../route/page.dart';
import '../utils/storage.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Storage _storage = Storage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerCPassword = TextEditingController();

  var isKaryawan = false.obs;
  var isMagang = false.obs;
  var userType = ''.obs; // Untuk menyimpan user_type

  RxBool isPasswordVisible = false.obs;
  RxBool isCPasswordVisible = false.obs;

  bool isLogin = false;

  @override
  void onInit() {
    super.onInit();
    isLogin = _storage.isLogin();
    if (isLogin) {
      // Menunggu untuk memastikan status login, lalu periksa user_type
      _checkUserType();
    }
  }

  // Fungsi untuk memeriksa user_type setelah login
  void _checkUserType() async {
    try {
      // Dapatkan data pengguna dari Firestore
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.email).get();

        if (userDoc.exists) {
          String userType = userDoc[
              'user_type']; // Asumsikan field 'user_type' ada di Firestore
          this.userType.value = userType;

          // Alihkan berdasarkan user_type
          if (userType == 'karyawan') {
            Get.offAllNamed(
                Routes.dahsboard); // Menuju ke halaman DashboardPage
          } else if (userType == 'admin') {
            Get.offAllNamed(Routes.adminpage); // Menuju ke halaman AdminPage
          } else {
            showSnackbar('Kesalahan', 'Tipe pengguna tidak dikenal', Colors.red,
                Colors.white, const Duration(seconds: 2), SnackPosition.BOTTOM);
          }
        } else {
          showSnackbar(
              'Kesalahan',
              'Pengguna tidak ditemukan di database',
              Colors.red,
              Colors.white,
              const Duration(seconds: 2),
              SnackPosition.BOTTOM);
        }
      }
    } catch (e) {
      showSnackbar('Kesalahan', 'Gagal memeriksa user type: $e', Colors.red,
          Colors.white, const Duration(seconds: 2), SnackPosition.BOTTOM);
    }
  }

  // Validasi login
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

  // Login menggunakan Firebase
  Future<void> loginWithFirebase() async {
    if (!checkLogin()) return;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: controllerEmail.text.trim(),
        password: controllerPassword.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        String email = user.email ?? 'unknown';

        // Ambil data pengguna dari Firestore untuk mendapatkan user_type
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(controllerEmail.text)
            .get();
        if (userDoc.exists) {
          String userType = userDoc[
              'user_type']; // Asumsikan field 'user_type' ada di Firestore

          // Tampilkan snackbar sukses
          showSnackbar(
              'Login Berhasil',
              'Selamat datang, $email!',
              Colors.green,
              Colors.white,
              const Duration(seconds: 2),
              SnackPosition.BOTTOM);

          _storage.login();

          // Alihkan berdasarkan user_type
          if (userType == 'karyawan') {
            Get.offAllNamed(
                Routes.dahsboard); // Menuju ke halaman DashboardPage
          } else if (userType == 'admin') {
            Get.offAllNamed(Routes.init); // Menuju ke halaman AdminPage
          } else {
            showSnackbar('Kesalahan', 'Tipe pengguna tidak dikenal', Colors.red,
                Colors.white, const Duration(seconds: 2), SnackPosition.BOTTOM);
          }
        } else {
          showSnackbar(
              'Kesalahan',
              'Pengguna tidak ditemukan di database',
              Colors.red,
              Colors.white,
              const Duration(seconds: 2),
              SnackPosition.BOTTOM);
        }
      }
    } catch (e) {
      showSnackbar('Login Gagal', 'Password / Email salah', Colors.red,
          Colors.white, const Duration(seconds: 2), SnackPosition.BOTTOM);
    }
  }

  // Validasi registrasi
  bool checkRegister() {
    List<String> errors = [];

    if (controllerNama.text.isEmpty) {
      errors.add('Nama harus diisi');
    } else if (controllerNama.text.trim().length < 2) {
      errors.add('Nama minimal harus terdiri dari 2 huruf');
    } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(controllerNama.text.trim())) {
      errors.add('Nama hanya boleh huruf dan spasi');
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
    if (controllerCPassword.text.isEmpty) {
      errors.add('confirm passworde tidak boleh kosong');
    } else if (controllerPassword.text != controllerCPassword.text) {
      errors.add('Password dan konfirmasi password tidak cocok');
    }
    

    if (errors.isNotEmpty) {
      showSnackbar('Kesalahan', errors.join('\n'), Colors.red, Colors.white,
          const Duration(seconds: 2), SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  Future<void> registerWithFirebase() async {
    if (!checkRegister()) return;

    try {
      // Registrasi dengan Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: controllerEmail.text.trim(),
        password: controllerPassword.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Simpan data pengguna ke Firestore
        await _firestore.collection('users').doc(controllerEmail.text).set({
          'name': controllerNama.text.trim(),
          'email': controllerEmail.text.trim(),
          'created_at': DateTime.now().toIso8601String(),
          'user_type': 'karyawan',
          'izin': 4,
          'uid': user.uid,
        });

        // Tampilkan snackbar sukses
        showSnackbar(
          'Registrasi Berhasil',
          'Akun berhasil dibuat. Selamat datang, ${controllerNama.text}!',
          Colors.green,
          Colors.white,
          const Duration(seconds: 2),
          SnackPosition.BOTTOM,
        );

        // Pindah ke halaman login atau dashboard
        Get.offAllNamed(Routes.init);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Registrasi gagal';

      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email sudah terdaftar. Silakan gunakan email lain.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Format email tidak valid.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password terlalu lemah. Gunakan minimal 6 karakter.';
      }

      showSnackbar(
        'Registrasi Gagal',
        errorMessage,
        Colors.red,
        Colors.white,
        const Duration(seconds: 2),
        SnackPosition.BOTTOM,
      );
    } catch (e) {
      // Tangani error lainnya (tidak dari FirebaseAuth)
      showSnackbar(
        'Registrasi Gagal',
        'Terjadi kesalahan. Silakan coba lagi.',
        Colors.red,
        Colors.white,
        const Duration(seconds: 2),
        SnackPosition.BOTTOM,
      );
      print('gagal register: $e');
    }
  }

  // Fungsi snackbar
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
