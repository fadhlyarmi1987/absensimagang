import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListKaryawanPage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Fungsi untuk mereset field izin menjadi 4 pada setiap pengguna
  Future<void> resetIzin(BuildContext context) async {
    try {
      final usersSnapshot = await firestore
          .collection('users')
          .where('user_type', isNotEqualTo: 'admin')
          .get();

      for (var doc in usersSnapshot.docs) {
        final userRef = firestore.collection('users').doc(doc.id);

        // Update field 'izin' menjadi 4
        await userRef.update({'izin': 4});
      }

      // Tampilkan snackbar setelah berhasil mereset
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Field izin berhasil direset ke 4')),
      );
    } catch (e) {
      // Tangani error jika ada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mereset field izin: $e')),
      );
    }
  }

  // Fungsi untuk menghitung absensi per bulan
  Future<String> getAttendanceCount(
      String userId, DateTime selectedMonth) async {
    final startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final endOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);

    print("Start of month: $startOfMonth");
    print("End of month: $endOfMonth");

    // Query untuk mengambil absensi berdasarkan rentang waktu bulan
    final attendanceSnapshot = await firestore
        .collection('attendance')
        .where('user_id', isEqualTo: userId)
        .where('timestamp', isGreaterThanOrEqualTo: startOfMonth)
        .where('timestamp', isLessThanOrEqualTo: endOfMonth)
        .get();

    print("Attendance snapshot count: ${attendanceSnapshot.docs.length}");

    int presenceCount = 0;
    int holidayCount = 0;

    // Hitung absensi dan libur
    for (var doc in attendanceSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      print("Data Absensi: $data");

      final checkInTime = data['check_in'] != null
          ? (data['check_in'] as Timestamp).toDate()
          : null;
      final checkOutTime = data['check_out'] != null
          ? (data['check_out'] as Timestamp).toDate()
          : null;

      print("Check-in: $checkInTime, Check-out: $checkOutTime");

      if (checkInTime != null && checkOutTime != null) {
        presenceCount++;
      } else {
        holidayCount++;
      }
    }

    // Tampilkan hasilnya
    return 'Sudah masuk: $presenceCount kali\nSudah libur: $holidayCount kali';
  }

  // Fungsi untuk mengambil data type absensi per karyawan
  Future<String> getAbsenceType(String userId) async {
    try {
      final attendanceSnapshot = await firestore
          .collection('attendance')
          .where('user_id', isEqualTo: userId)
          .get();

      if (attendanceSnapshot.docs.isNotEmpty) {
        final firstDoc = attendanceSnapshot.docs.first;
        final data = firstDoc.data() as Map<String, dynamic>;
        final absenceType =
            data['type'] ?? 'Unknown'; // Menampilkan 'type' dari absensi
        return absenceType;
      } else {
        return 'Tidak ada data absensi';
      }
    } catch (e) {
      return 'Gagal mengambil data type';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Karyawan"),
        backgroundColor: Colors.red.shade700,
        actions: [
          // Button untuk reset field izin
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () =>
                resetIzin(context), // Pastikan context dipassing ke fungsi
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Tambahkan filter di query untuk mengecualikan user_type: "admin"
        stream: firestore
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

          // Mengambil data dari Firestore
          final List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>?;

              // Pastikan data tidak null
              final String nama = data?['name'] ?? 'Tidak ada nama';
              final String email = data?['email'] ?? 'Tidak ada email';
              final String userId = docs[index].id;
              final int izin = data?['izin'] ?? 0;

              // Ambil tanggal bulan ini
              final DateTime now = DateTime.now();
              final DateTime selectedMonth = DateTime(now.year, now.month);

              return FutureBuilder<String>(
                future: getAttendanceCount(userId, selectedMonth),
                builder: (context, countSnapshot) {
                  if (countSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person, color: Colors.white),
                          backgroundColor: Colors.red,
                        ),
                        title: Text(nama),
                        subtitle: Text('Loading...'),
                      ),
                    );
                  }

                  return FutureBuilder<String>(
                    future: getAbsenceType(userId),
                    builder: (context, typeSnapshot) {
                      if (typeSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.person, color: Colors.white),
                              backgroundColor: Colors.red,
                            ),
                            title: Text(nama),
                            subtitle: Text('Loading...'),
                          ),
                        );
                      }

                      // Menampilkan riwayat absensi atau libur dalam modal
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: CircleAvatar(
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
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Konfirmasi'),
                                  content: Text(
                                      'Apakah Anda yakin ingin menghapus akun ini?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text('Batal'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text('Hapus'),
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
                                title: Text("Detail Karyawan"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Nama: $nama"),
                                    Text("Email: $email"),
                                    Text("Sisa Izin: $izin"),
                                    SizedBox(height: 8),
                                    Text(countSnapshot.data ??
                                        'Tidak ada data absensi'),
                                    SizedBox(height: 8),
                                    Text(
                                        'Tipe Absensi: ${typeSnapshot.data ?? 'Tidak ada data absensi'}'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Tutup"),
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
