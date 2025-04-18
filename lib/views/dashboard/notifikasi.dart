import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/services/notifikasi.service.dart';
import 'dart:math';

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

  Future<void> _refreshNotifications() async {
    setState(() {
      _notifications = NotificationService().fetchNotifications();
    });
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
              padding: const EdgeInsets.only(top: 25),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(90, 255, 255, 255),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 7),
                        )
                      ]),
                  width: screenWidth * 0.9, 
                  height: screenHeight * 0.8,
                  child: RefreshIndicator(
                    onRefresh: _refreshNotifications,
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _notifications,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('Tidak Ada Notifikasi'));
                        } else {
                          final itemCount = min(snapshot.data!.length, 15);
                          return ListView.builder(
                            itemCount: itemCount,
                            itemBuilder: (context, index) {
                              final notification = snapshot.data![index];
                              final judul = notification['judul']; // Ambil judul dari message
                              final isi = notification['isi']; // Ambil isi dari title
                              final createdAt = notification['created_at'];
                              final formattedDate =
                                  DateFormat('dd MMM yyyy : HH:mm')
                                      .format(DateTime.parse(createdAt));

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          judul,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          isi,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            formattedDate,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[600],
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
