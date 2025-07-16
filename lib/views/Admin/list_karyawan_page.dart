import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'AbsensiCalendarPage.dart';

class ListKaryawanPage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Fungsi untuk mereset field izin menjadi 4 pada setiap pengguna
  void confirmResetIzin(BuildContext context) {
  Get.defaultDialog(
    title: 'Konfirmasi',
    middleText: 'Apakah Anda ingin mereset kuota cuti seluruh karyawan?',
    textCancel: 'Batal',
    textConfirm: 'Reset',
    confirmTextColor: Colors.white,
    onConfirm: () {
      Get.back(); // Tutup dialog
      resetIzin(context); // Jalankan reset
    },
  );
}

Future<void> resetIzin(BuildContext context) async {
  try {
    final usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('user_type', isNotEqualTo: 'admin')
        .get();

    for (var doc in usersSnapshot.docs) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(doc.id);

      // Update field 'izin' menjadi 4
      await userRef.update({'izin': 4});
    }

    // Tampilkan snackbar sukses
    Get.snackbar(
      'Berhasil',
      'Kuota cuti seluruh karyawan berhasil direset ke 4.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  } catch (e) {
    // Tampilkan snackbar error
    Get.snackbar(
      'Gagal',
      'Terjadi kesalahan saat mereset kuota cuti: $e',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}


  // Fungsi untuk menghitung absensi per bulan
  Future<String> getAttendanceCount(
      String userId, DateTime selectedMonth) async {
    final startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final endOfMonth =
        DateTime(selectedMonth.year, selectedMonth.month + 1, 0, 23, 59, 59);

    final attendanceSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('absensi')
        .get();

    final Map<String, int> typeCounts = {
      'check-in': 0,
      'izin': 0,
    };

    for (var doc in attendanceSnapshot.docs) {
      final data = doc.data();
      final timestamp = data['timestamp'] ?? data['tanggal'];
      final type = data['type'];

      if (timestamp is Timestamp && type is String) {
        final date = timestamp.toDate();
        if (date.isAfter(startOfMonth.subtract(const Duration(seconds: 1))) &&
            date.isBefore(endOfMonth.add(const Duration(seconds: 1)))) {
          // Hitung berdasarkan type tanpa if-else
          typeCounts[type] = (typeCounts[type] ?? 0) + 1;
        }
      }
    }

    return 'Sudah masuk: ${typeCounts['check-in']} kali\nSudah libur: ${typeCounts['izin']} kali';
  }

  // Fungsi untuk mengambil data type absensi per karyawan
  Future<String> getAbsenceType(String userId) async {
    try {
      final attendanceSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('absensi')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (attendanceSnapshot.docs.isNotEmpty) {
        final data = attendanceSnapshot.docs.first.data();
        final absenceType = data['type'] ?? 'Unknown';
        return absenceType;
      } else {
        return 'Tidak ada data absensi';
      }
    } catch (e) {
      return 'Gagal mengambil data type';
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Karyawan"),
        backgroundColor: Colors.red.shade700,
        actions: [
          // Button untuk reset field izin
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () =>
                confirmResetIzin(context), // Pastikan context dipassing ke fungsi
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 193, 193, 193),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('user_type', isNotEqualTo: 'admin')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(
                  child: Text("Terjadi kesalahan saat memuat data"));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Tidak ada data karyawan"));
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>?;
                final userId = docs[index].id;

                final nama = data?['name'] ?? 'Tidak ada nama';
                final email = data?['email'] ?? 'Tidak ada email';
                final izin = data?['izin'] ?? 0;

                final selectedMonth = DateTime.now();

                return FutureBuilder<String>(
                  future: getAttendanceCount(userId, selectedMonth),
                  builder: (context, countSnapshot) {
                    if (countSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return _buildLoadingTile(nama);
                    }

                    return FutureBuilder<String>(
                      future: getAbsenceType(userId),
                      builder: (context, typeSnapshot) {
                        if (typeSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildLoadingTile(nama);
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person, color: Colors.white),
                              backgroundColor: Colors.red,
                            ),
                            title: Text(nama),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(email),
                                Text('Sisa Izin: $izin'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Konfirmasi'),
                                    content: const Text(
                                        'Apakah Anda yakin ingin menghapus akun ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Batal'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Hapus'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await deleteUser(userId, context);
                                }
                              },
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Detail Karyawan"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Nama: $nama"),
                                      Text("Email: $email"),
                                      Text("Sisa Izin: $izin"),
                                      const SizedBox(height: 8),
                                      Text(countSnapshot.data ??
                                          'Tidak ada data absensi'),
                                      const SizedBox(height: 16),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Tutup dialog terlebih dahulu
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  AbsenceCalendarPage(
                                                userId: userId,
                                                userName: nama,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.calendar_today),
                                        label: const Text(
                                            "Lihat Kalender Absensi"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade700,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Tutup"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> deleteUser(String userId, BuildContext context) async {
    try {
      await firestore.collection('users').doc(userId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Akun berhasil dihapus')),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Gagal Menghapus'),
          content: Text('Terjadi kesalahan saat menghapus akun:\n$e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

Widget _buildLoadingTile(String nama) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.person, color: Colors.white),
        backgroundColor: Colors.red,
      ),
      title: Text(nama),
      subtitle: const Text('Loading...'),
    ),
  );
}
