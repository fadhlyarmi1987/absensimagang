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
  Future<void> ajukanIzin(String keterangan) async {
    try {
      // Ambil UID pengguna yang sedang login
      final userId = user?.uid;
      if (userId == null) {
        throw Exception('Pengguna tidak terautentikasi');
      }

      final userDoc = await firestore.collection('users').doc(user?.email).get();
      final name = userDoc.data()?['name'] ?? 'Pengguna';
      final uid = user?.email;
      final now = DateTime.now();
      final formattedDate = '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
      
      // Simpan data izin pada subkoleksi 'absensi' dengan nama dokumen 'izin'
      final izinData = {
        'keterangan': keterangan,
        'tanggal': Timestamp.now(), // Waktu pengajuan izin
      };

      // Mulai transaksi untuk memastikan data diperbarui dengan aman
      await firestore.runTransaction((transaction) async {
        final userRef = firestore.collection('users').doc(uid);
        final userSnapshot = await transaction.get(userRef);

        if (!userSnapshot.exists) {
          throw Exception('Pengguna tidak ditemukan');
        }

        // Ambil nilai izin saat ini
        int currentIzin = userSnapshot.data()?['izin'] ?? 0;

        // Periksa jika izin masih tersedia
        if (currentIzin > 0) {
          // Kurangi nilai izin sebanyak 1
          currentIzin -= 1;

          // Simpan data izin pada subkoleksi 'absensi'
          await transaction.set(
            userRef.collection('absensi').doc('izin $formattedDate'),
            izinData,
          );

          // Perbarui field 'izin' pada dokumen pengguna
          await transaction.update(userRef, {'izin': currentIzin});
          
          print('Izin berhasil diajukan');
          Get.snackbar('$name', 'Berhasil Izin $keterangan');
        } else {
          throw Exception('Tidak cukup izin');
        }
      });
    } catch (e) {
    }
  }
}
