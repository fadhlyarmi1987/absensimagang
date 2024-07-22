import 'package:absensimagang/views/dashboard/dashboard.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 14, 142, 197),
                  Colors.white,
                ],
                stops: [0.35, 0.35],
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, right: 305.0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(160),
                          bottomRight: Radius.circular(160),
                        ),
                      ),
                      child: SizedBox(
                        height: 45,
                        width: 100,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Now',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.normal,
                            fontSize: 25,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          '10.45',
                          style: GoogleFonts.khula(
                            fontSize: 70,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          'Kamis, 18 Juli 2024',
                          style: GoogleFonts.khula(
                              fontSize: 20, color: Colors.white, height: 1.2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 210,
            left: 40,
            right: 40,
            child: Container(
              height: 150,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Keterangan Jam Absensi',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                '07.30-08.00',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Cek-In'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          Column(
                            children: [
                              Text(
                                '17.00-18.00',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Cek-Out'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 380,
            left: 40,
            right: 40,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  height: 300,
                  color: Color.fromARGB(255, 233, 227, 227),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Recent Attendance',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Obx(() {
                          return ListView.builder(
                            itemCount: controller.listhadir.length,
                            itemBuilder: (context, index) {
                              var attendance = controller.listhadir[index];
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      attendance['date']!,
                                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text('Cek-In:'),
                                            Expanded(
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                    '${attendance['checkIn']}'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('Cek-Out:'),
                                            Expanded(
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                    '${attendance['checkOut']}'),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                ],
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 700, // Sesuaikan posisi top sesuai kebutuhan
            left: 150,
            right: 150,
            child: ElevatedButton(
              onPressed: controller.logout,
              child: Text('Keluar'),
            ),
          ),
        ]),
      ),
    );
  }
}
