import 'package:absensimagang/views/dashboard/gantipassword.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:absensimagang/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../controller/dashboard.controller.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final DashboardController controller = Get.find<DashboardController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final Storage storage = Storage();
  late String userId;
  final a = Get.arguments;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = controller.name.value;
    _emailController.text = controller.email.value;
    userId = storage.getId().toString();
    print(a);
  }

  Future<void> _updateProfile() async {
    try {
      final String? currentEmail = storage.getEmail();
      final String newName = _nameController.text.trim();
      final String newEmail = _emailController.text.trim();
      final String oldPassword = _oldPasswordController.text.trim();
      final String newPassword = _newPasswordController.text.trim();

      // Cek apakah ada perubahan pada nama
      if (newName == controller.name.value) {
        Get.snackbar(
          'Gagal Update',
          'Tidak tidak ada perubahan yang dilakukan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
        );
        return; // Tidak melanjutkan update jika nama tidak berubah
      }

      // Update nama dan email terlebih dahulu
      await _updateFirestoreProfile(currentEmail, newName, newEmail);

      // Update password jika ada input
      if (newPassword.isNotEmpty) {
        await _changePassword(oldPassword, newPassword);
      }

      // Update controller dan GetStorage
      controller.name.value = newName;
      controller.email.value = newEmail;

      Get.snackbar(
        'Berhasil',
        'Perubahan berhasil disimpan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    }
  }

  Future<void> _updateFirestoreProfile(
      String? currentEmail, String newName, String newEmail) async {
    if (currentEmail == null) throw Exception('Email pengguna tidak ditemukan');

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: currentEmail)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception('User tidak ditemukan di Firestore');
    }

    final docId = snapshot.docs.first.id;

    await FirebaseFirestore.instance.collection('users').doc(docId).update({
      'name': newName,
      'email': newEmail,
    });
  }

  Future<void> _changePassword(String oldPassword, String newPassword) async {
    if (oldPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Password lama harus diisi untuk mengganti password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
      throw Exception('Password lama kosong');
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User tidak ditemukan di Firebase Auth');

    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: oldPassword,
    );

    try {
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      print('Password berhasil diubah');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Password lama salah atau gagal mengubah password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
      throw Exception('Gagal mengubah password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1000,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 244, 1, 1),
              Color.fromARGB(255, 216, 253, 255)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔙 AppBar Custom
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Edit Profil',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                /// 🧑 Nama
                _buildTextField(
                  controller: _nameController,
                  label: 'Nama',
                ),
                const SizedBox(height: 20),

                /// 📧 Email
                _buildTextField(
                  controller: _emailController,
                  label: '',
                  enabled: false,
                ),
                const SizedBox(height: 32),

                /// 💾 Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _updateProfile,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                /// 🔒 Tombol Ganti Password
                SizedBox(height: 20),

                // 👉 TOMBOL UBAH PASSWORD
                GestureDetector(
                  onTap: () {
                    Get.to(() =>
                        ChangePasswordPage()); // Pastikan halaman ini kamu buat
                  },
                  child: Text(
                    'Ingin mengubah password?',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  bool enabled = true,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      if (label.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      TextField(
        controller: controller,
        enabled: enabled,
        style: TextStyle(color: enabled ? Colors.black : Colors.grey),
        decoration: InputDecoration(
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade300,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    ],
  );
}

}
