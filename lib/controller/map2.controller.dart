import 'package:absensimagang/utils/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../route/page.dart';

class Map2Controller extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final Storage storage = Storage();
  var name = ''.obs;
  var email = ''.obs;

  // Listener untuk memperbarui data pengguna saat ada perubahan
  @override
  void onInit() {
    super.onInit();
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        email.value = user.email ?? '';
        name.value = user.displayName ?? 'Pengguna';
      }
    });
  }

  Future<void> checkIn(
      String officeName, double latitude, double longitude) async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        Get.defaultDialog(
          title: 'Error',
          middleText: 'Pengguna tidak terdeteksi.',
          textConfirm: 'OK',
          onConfirm: () => Get.back(),
        );
        return;
      }

      final userDoc = await firestore.collection('users').doc(user.email).get();
      final name = userDoc.data()?['name'] ?? 'Pengguna';

      final now = DateTime.now();
      final formattedDate =
          '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';

      await firestore
          .collection('users')
          .doc(user.email)
          .collection('absensi')
          .add({
        'office': officeName,
        'latitude': latitude,
        'longitude': longitude,
        'type': 'check-in',
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.defaultDialog(
        title: 'Berhasil',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              '$name Berhasil Absen Masuk',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        textConfirm: 'OK',
        confirmTextColor: Colors.white,
        buttonColor: Colors.green,
        onConfirm: () {
          Get.back(); // Tutup dialog
          Get.offAllNamed(Routes.dahsboard); // Pindah ke dashboard
        },
      );
    } catch (e) {
      Get.defaultDialog(
        title: 'Error',
        middleText: 'Gagal melakukan check-in: $e',
        textConfirm: 'OK',
        onConfirm: () => Get.back(),
      );
    }
  }

  // Fungsi untuk Check-Out
  Future<void> checkOut(
      String officeName, double latitude, double longitude) async {
    try {
      // Ambil userId dari pengguna yang sedang login
      final user = auth.currentUser;

      if (user == null) {
        Get.snackbar('Error', 'Pengguna tidak terdeteksi.');
        return;
      }

      // Ambil nama pengguna dari Firestore berdasarkan email pengguna
      final userDoc = await firestore.collection('users').doc(user.email).get();
      final name = userDoc.data()?['name'] ?? 'Pengguna';

      // Format tanggal, bulan, dan tahun
      final now = DateTime.now();
      final formattedDate =
          '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';

      // Menambahkan data ke subkoleksi `absensi` menggunakan add() agar menambah dokumen baru
      await firestore
          .collection('users') // Koleksi pengguna
          .doc(user.email) // Dokumen pengguna berdasarkan email
          .collection('absensi') // Subkoleksi absensi
          .add({
        'office': officeName,
        'latitude': latitude,
        'longitude': longitude,
        'type': 'check-out', // Menyimpan data check-out
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.defaultDialog(
        title: 'Berhasil',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              '$name Berhasil Absen Pulang',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        textConfirm: 'OK',
        confirmTextColor: Colors.white,
        buttonColor: Colors.green,
        onConfirm: () {
          Get.back(); // Tutup dialog
          Get.offAllNamed(Routes.dahsboard); // Pindah ke dashboard
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal melakukan check-out: $e');
    }
  }

  void showOutOfRadiusModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ganti dengan animasi atau ikon statis
              FadeInXMark(), // atau bisa ganti: Icon(Icons.cancel, color: Colors.red, size: 50),
              SizedBox(height: 10),
              Text(
                'UUUPPPSSS...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Anda berada di luar radius yang ditentukan.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
            ],
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );}
}


class AnimatedCheckmark extends StatefulWidget {
  @override
  _AnimatedCheckmarkState createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: _animation.value,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            if (_animation.value == 1)
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
          ],
        );
      },
    );
  }
}

class FadeInXMark extends StatefulWidget {
  @override
  _FadeInXMarkState createState() => _FadeInXMarkState();
}

class _FadeInXMarkState extends State<FadeInXMark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Icon(
        Icons.cancel,
        color: Colors.red,
        size: 50,
      ),
    );
  }
}
