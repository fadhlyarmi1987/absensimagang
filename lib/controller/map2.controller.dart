import 'package:absensimagang/utils/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../route/page.dart';

class MapController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Storage storage = Storage();

  var name = ''.obs;
  var email = ''.obs;

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
      final checkInDocId = '$formattedDate-checkin';

      final absensiRef = firestore
          .collection('users')
          .doc(user.email)
          .collection('absensi')
          .doc(checkInDocId);

      final checkInDoc = await absensiRef.get();

      if (checkInDoc.exists) {
        showAlreadyCheckedInDialog();
        return;
      }

      await absensiRef.set({
        'office': officeName,
        'latitude': latitude,
        'longitude': longitude,
        'type': 'check-in',
        'timestamp': FieldValue.serverTimestamp(),
      });
      showSuccessAttendanceDialog(name, 'check-in');
    } catch (e) {
      Get.defaultDialog(
        title: 'Error',
        middleText: 'Gagal melakukan check-in: $e',
        textConfirm: 'OK',
        onConfirm: () => Get.back(),
      );
    }
  }

  Future<void> checkOut(
      String officeName, double latitude, double longitude) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'Pengguna tidak terdeteksi.');
        return;
      }

      final userDoc = await firestore.collection('users').doc(user.email).get();
      final name = userDoc.data()?['name'] ?? 'Pengguna';

      final now = DateTime.now();
      final formattedDate =
          '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
      final checkOutDocId = '$formattedDate-checkout';

      final absensiRef = firestore
          .collection('users')
          .doc(user.email)
          .collection('absensi')
          .doc(checkOutDocId);

      final checkOutDoc = await absensiRef.get();

      if (checkOutDoc.exists) {
        showAlreadyCheckedOutDialog();
        return;
      }

      await absensiRef.set({
        'office': officeName,
        'latitude': latitude,
        'longitude': longitude,
        'type': 'check-out',
        'timestamp': FieldValue.serverTimestamp(),
      });
      showSuccessAttendanceDialog(name, 'check-out');
    } catch (e) {
      Get.snackbar('Error', 'Gagal melakukan check-out: $e');
    }
  }

  void showSuccessAttendanceDialog(String name, String type) {
    final actionText = type.toLowerCase() == 'check-in' ? 'Masuk' : 'Pulang';

    Get.defaultDialog(
      title: 'Berhasil',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
          SizedBox(height: 12),
          Text(
            '$name Berhasil Absen $actionText',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.green[800],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Terima kasih sudah melakukan absensi tepat waktu.',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onConfirm: () {
        Get.back();
        Get.offAllNamed(Routes.dahsboard);
      },
    );
  }

  void showAlreadyCheckedInDialog() {
    Get.defaultDialog(
      title: 'Sudah Check-In',
      titleStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
      content: Column(
        children: [
          Icon(Icons.task_alt, color: Colors.green, size: 60),
          SizedBox(height: 15),
          Text(
            'Anda sudah melakukan check-in\nhari ini.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () => Get.back(),
      radius: 12,
    );
  }

  void showAlreadyCheckedOutDialog() {
    Get.defaultDialog(
      title: 'Sudah Check-Out',
      titleStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
      content: Column(
        children: [
          Icon(Icons.task_alt, color: Colors.blue, size: 60),
          SizedBox(height: 15),
          Text(
            'Anda sudah melakukan check-in\nhari ini.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () => Get.back(),
      radius: 12,
    );
  }

  void showOutOfRadiusModal(BuildContext context) {
    Get.defaultDialog(
      title: 'UUUPPPSSS...',
      titleStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
      content: Column(
        children: [
          Icon(Icons.location_off_rounded, color: Colors.red, size: 60),
          SizedBox(height: 15),
          Text(
            'Anda berada di luar radius yang\nditetapkan untuk absen.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () => Get.back(),
      radius: 12,
    );
  }
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
