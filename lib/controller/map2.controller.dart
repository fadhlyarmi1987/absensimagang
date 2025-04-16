import 'package:absensimagang/utils/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // Fungsi untuk Check-In
  Future<void> checkIn(
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

      // Simpan data ke subkoleksi `absensi` di dokumen pengguna berdasarkan email
      await firestore
          .collection('users') // Koleksi pengguna
          .doc(user.email) // Dokumen pengguna berdasarkan email
          .collection('absensi') // Subkoleksi absensi
          .add({
        'office': officeName,
        'latitude': latitude,
        'longitude': longitude,
        'type': 'check-in',
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Berhasil',
        '$name Berhasil Absen Masuk',
      );
      Get.offAllNamed(Routes.dahsboard);
    } catch (e) {
      Get.snackbar('Error', 'Gagal melakukan check-in: $e');
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

      Get.snackbar(
        'Berhasil',
        '$name Berhasil Absen Pulang',
      );
      Get.offAllNamed(Routes.dahsboard);
    } catch (e) {
      Get.snackbar('Error', 'Gagal melakukan check-out: $e');
    }
  }
}
