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
  int _currentIzin = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentIzin();
  }

  void showTopSnackBar(String message, Color backgroundColor) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  Future<void> _getCurrentIzin() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .get();
        final izin = userDoc.data()?['izin'] ?? 0;
        setState(() {
          _currentIzin = izin;
        });
      }
    } catch (e) {
      showTopSnackBar('Gagal memuat data izin: $e', Colors.red[800]!);
    }
  }

  void _ajukanIzin() async {
    final keterangan = _keteranganController.text.trim();

    if (keterangan.isEmpty) {
      showTopSnackBar('Keterangan tidak boleh kosong', Colors.orange[800]!);
      return;
    }

    // Tolak jika hanya angka saja
    if (RegExp(r'^\d+$').hasMatch(keterangan)) {
      showTopSnackBar(
          'Keterangan tidak boleh hanya angka', Colors.orange[800]!);
      return;
    }

    // Minimal harus mengandung huruf
    if (!RegExp(r'[a-zA-Z]').hasMatch(keterangan)) {
      showTopSnackBar('Keterangan harus mengandung huruf', Colors.orange[800]!);
      return;
    }

    try {
      await _firestoreService.ajukanIzin(keterangan);
      await _getCurrentIzin();
      _keteranganController.clear();
    } catch (e) {
      showTopSnackBar('Tidak bisa izin lagi, Izin Anda 0', Colors.red[800]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
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

          // Konten scroll + refresh
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _getCurrentIzin,
              child: Container(
                height: 800,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(111, 255, 255, 255),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 7),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Ajukan Izin',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Sisa Izin: $_currentIzin',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Keterangan Izin',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _keteranganController,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Tuliskan keterangan izin Anda...',
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _ajukanIzin,
                                  child: const Text('Ajukan Izin'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
