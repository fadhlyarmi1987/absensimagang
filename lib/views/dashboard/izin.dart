import 'package:absensimagang/controller/izincontroller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IzinPage extends StatefulWidget {
  const IzinPage({super.key});

  @override
  State<IzinPage> createState() => _IzinPageState();
}

class _IzinPageState extends State<IzinPage> {
  final _keteranganController = TextEditingController();
  final _firestoreService = IzinController();
  int _currentIzin = 0; // Untuk menyimpan nilai izin yang tersedia

  @override
  void initState() {
    super.initState();
    _getCurrentIzin(); // Ambil nilai izin saat halaman dimuat
  }

  // Fungsi untuk mengambil nilai izin pengguna dari Firestore
  Future<void> _getCurrentIzin() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.email).get();
        final izin = userDoc.data()?['izin'] ?? 0; // Ambil nilai izin
        setState(() {
          _currentIzin = izin; // Set nilai izin ke state
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat data izin: $e'),
        ),
      );
    }
  }

  // Fungsi untuk mengajukan izin
  void _ajukanIzin() async {
    final keterangan = _keteranganController.text;
    if (keterangan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Keterangan tidak boleh kosong'),
        ),
      );
    } else {
      try {
        // Kirim data izin ke Firestore
        await _firestoreService.ajukanIzin(keterangan);
        // Ambil nilai izin terbaru setelah pengajuan
        await _getCurrentIzin();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Izin berhasil diajukan'),
          ),
        );
        _keteranganController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 235, 6, 6),
                    Colors.white,
                  ],
                  stops: [0.06, 0.54],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(111, 255, 255, 255),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 0, 0, 0)
                            .withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 7),
                      )
                    ],
                  ),
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.6, // Adjusted height
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ajukan Izin',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text('Sisa Izin: $_currentIzin'), // Menampilkan nilai izin
                        SizedBox(height: 8),
                        Text('Keterangan Izin'),
                        SizedBox(height: 8),
                        TextField(
                          controller: _keteranganController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Tuliskan keterangan izin Anda...',
                          ),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            onPressed: _ajukanIzin,
                            child: Text('Ajukan Izin'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
