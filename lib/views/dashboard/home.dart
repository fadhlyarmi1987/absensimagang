import 'package:absensimagang/utils/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../maps/maps.view.dart';
import 'dashboard.controller.dart';

class HomePage extends GetView<DashboardController> {
  const HomePage({super.key});

  Future<DateTime?> fetchServerTime() async {
  try {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.waktu}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DateTime.parse(data['server_time']);
    } else {
      print('Failed to load server time: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching server time: $e');
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
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
                      padding: const EdgeInsets.only(top: 0.0, right: 260.0),
                      child: Card(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(160),
                            bottomRight: Radius.circular(160),
                          ),
                        ),
                        child: SizedBox(
                          height: 45,
                          width: 150,
                          child: Image.asset("assets/Logo_Natusi.png"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Now',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          StreamBuilder<DateTime?>(
                            stream: Stream.periodic(const Duration(seconds: 1)).asyncMap((_) => fetchServerTime()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if (snapshot.hasError || !snapshot.hasData) {
                                return const Center(child: Text('Error fetching time'));
                              }

                              // Set your location
                              var location = tz.getLocation('Asia/Jakarta'); 
                              var utcTime = snapshot.data!;
                              var localTime = tz.TZDateTime.from(utcTime, location);

                              var formattedTime = DateFormat('HH:mm:ss').format(localTime);
                              var formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id').format(localTime);

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    formattedTime,
                                    style: const TextStyle(
                                      fontSize: 50,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Obx(() {
                return Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          child: Text(
                            'Hai,',
                            style: GoogleFonts.lobster(
                                fontSize: 15, color: Colors.white),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Container(
                          width: 150,
                          child: Text(
                            '${controller.name.value}',
                            style: GoogleFonts.lobster(
                                fontSize: 20, color: Colors.white),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
            Positioned(
              top: 210,
              left: 40,
              right: 40,
              child: Container(
                height: 150,
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
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
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  const Text('07:00 - 08:00'),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const MapPage(isCheckIn: true);
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'Check-In',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text('16:30 - 17:00'),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const MapPage(isCheckIn: false);
                                        },
                                      );
                                    },
                                    child: const Text('Check-Out',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              )
                            ],
                          ),
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
                    color: const Color.fromARGB(255, 247, 245, 245),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Recent Attendance',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Text('Check-In:'),
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
                                              const Text('Check-Out:'),
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                      '${attendance['checkOut']}'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
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
          ],
        ),
      ),
    );
  }
}
