import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../utils/storage.dart';

class IzinController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  final Storage storage = Storage();
  var name = ''.obs;
  var email = ''.obs;
  
  // Fungsi untuk mengajukan izin
  Future<void> ajukanIzin(
  String keterangan, {
  required VoidCallback onSuccess,
  required Function(String error) onError,
}) async {
  try {
    final userId = user?.uid;
    if (userId == null) {
      onError('Pengguna tidak terautentikasi');
      return;
    }

    final userDoc = await firestore.collection('users').doc(user?.email).get();
    final name = userDoc.data()?['name'] ?? 'Pengguna';
    final uid = user?.email;
    final now = DateTime.now();
    final formattedDate =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';

    final izinData = {
      'keterangan': keterangan,
      'timestamp': Timestamp.now(),
      'type': 'izin',
    };

    await firestore.runTransaction((transaction) async {
      final userRef = firestore.collection('users').doc(uid);
      final userSnapshot = await transaction.get(userRef);

      if (!userSnapshot.exists) {
        onError('Pengguna tidak ditemukan');
        return;
      }

      int currentIzin = userSnapshot.data()?['izin'] ?? 0;

      if (currentIzin > 0) {
        currentIzin -= 1;

        await transaction.set(
          userRef.collection('absensi').doc('izin $formattedDate'),
          izinData,
        );

        await transaction.update(userRef, {'izin': currentIzin});

        onSuccess(); // ✅ Callback jika berhasil
      } else {
        onError('Tidak cukup izin'); // ❌ Callback jika gagal
      }
    });
  } catch (e) {
    onError('Terjadi kesalahan: $e'); // ❌ Callback jika error
  }
}

}
