import 'package:absensimagang/controller/izincontroller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

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

  void showDialogMessage(
    BuildContext context,
    String title,
    String message, {
    Color backgroundColor = Colors.red,
    IconData icon = Icons.close_rounded,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 60),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
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
      showDialogMessage(context, 'Gagal memuat data izin: $e', '');
    }
  }

  void _ajukanIzin() async {
    final keterangan = _keteranganController.text.trim();

    if (keterangan.isEmpty) {
      showDialogMessage(context, 'Peringatan', 'Keterangan tidak boleh kosong');
      return;
    }

    if (!RegExp(r'[a-zA-Z]').hasMatch(keterangan)) {
      showDialogMessage(
          context, 'Peringatan', 'Keterangan harus mengandung huruf');
      return;
    }

    await _firestoreService.ajukanIzin(
      keterangan,
      onSuccess: () {
        showDialogMessage(
          context,
          'BERHASIL!',
          'Izin berhasil diajukan',
          backgroundColor: Colors.green,
          icon: Icons.check_circle_outline_rounded,
        );
        _getCurrentIzin();
        _keteranganController.clear();
      },
      onError: (error) {
        showDialogMessage(
          context,
          'Gagal',
          error,
          backgroundColor: Colors.red,
          icon: Icons.close_rounded,
        );
      },
    );
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
                                onTap: () {
                                  final selection =
                                      _keteranganController.selection;
                                  _keteranganController.selection =
                                      TextSelection.collapsed(
                                    offset: selection.extentOffset,
                                  );
                                },
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
