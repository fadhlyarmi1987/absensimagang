import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/services/notifikasi.service.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  late Future<List<Map<String, dynamic>>> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = NotificationService().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -1),
                  stops: [0.3, 0.7],
                  radius: 1.5,
                  colors: [
                    const Color.fromARGB(255, 193, 188, 188),
                    const Color.fromARGB(255, 14, 142, 197)
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, 50),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _notifications,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Tidak Ada Notifikasi Sama'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final notification = snapshot.data![index];
                          final pengumuman = notification['pengumuman'];
                          final createdAt = notification['created_at'];
                          final formattedDate = DateFormat('dd MMM yyyy, HH:mm')
                              .format(DateTime.parse(createdAt));

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    Align(//jnkjnj
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        pengumuman,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      
                                      width: 300,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          formattedDate,
                                          style: TextStyle(
                                            fontSize: 10, // Ukuran teks waktu sedikit lebih besar untuk visibilitas
                                            color: Color.fromARGB(255, 93, 91, 91),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
