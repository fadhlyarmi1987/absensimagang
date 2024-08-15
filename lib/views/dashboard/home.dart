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
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

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
                  stops: [0.39, 0.39],
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 0.0,
                        right: screenWidth * 0.6, // Adjusted based on screen width
                      ),
                      child: Card(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(160),
                            bottomRight: Radius.circular(160),
                          ),
                        ),
                        child: SizedBox(
                          height: screenHeight * 0.06, // Responsive height
                          width: screenWidth * 0.4, // Responsive width
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
                              fontSize: screenHeight * 0.025, // Responsive font size
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
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.06, // Responsive font size
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.025, // Responsive font size
                                      color: const Color.fromARGB(255, 255, 255, 255),
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
              top: screenHeight * 0.01, // Responsive position
              right: screenWidth * 0.03, // Responsive position
              child: Obx(() {
                return Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(screenHeight * 0.01), // Responsive padding
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth * 0.4, // Adjusted based on screen width
                          child: Text(
                            'Hai,',
                            style: GoogleFonts.lobster(
                                fontSize: screenHeight * 0.02, // Responsive font size
                                color: Colors.white),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Container(
                          width: screenWidth * 0.4, // Adjusted based on screen width
                          child: Text(
                            '${controller.name.value}',
                            style: GoogleFonts.greatVibes(
                                fontSize: 20, // Responsive font size
                                color: Colors.white),
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
              top: screenHeight * 0.26, // Responsive position
              left: screenWidth * 0.1, // Responsive position
              right: screenWidth * 0.1, // Responsive position
              child: Container(
                height: isPortrait ? screenHeight * 0.2 : screenHeight * 0.25, // Adjusted height based on orientation
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
                            fontSize: screenHeight * 0.02, // Responsive font size
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015), // Responsive spacing
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '07:00 - 08:00',
                                    style: TextStyle(fontSize: screenHeight * 0.02),
                                  ),
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
                                    child: Text(
                                      'Check-In',
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.02, // Responsive font size
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '16:30 - 17:00',
                                    style: TextStyle(fontSize: screenHeight * 0.02),
                                  ),
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
                                    child: Text(
                                      'Check-Out',
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.02, // Responsive font size
                                        color: Colors.white,
                                      ),
                                    ),
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
              top: screenHeight * 0.5, // Responsive position
              left: screenWidth * 0.1, // Responsive position
              right: screenWidth * 0.1, // Responsive position
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    height: screenHeight * 0.35, // Adjusted height based on screen height
                    color: const Color.fromARGB(255, 247, 245, 245),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(screenHeight * 0.015), // Responsive padding
                          child: Text(
                            'Recent Attendance',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: screenHeight * 0.015, // Responsive font size
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
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                          fontSize: screenHeight * 0.02, // Responsive font size
                                        ),
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Check-In:', style: TextStyle(fontSize: screenHeight * 0.015)),
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment.centerRight,
                                                  child: Text(
                                                    '${attendance['checkIn']}',
                                                    style: TextStyle(fontSize: screenHeight * 0.015),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('Check-Out:', style: TextStyle(fontSize: screenHeight * 0.015)),
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment.centerRight,
                                                  child: Text(
                                                    '${attendance['checkOut']}',
                                                    style: TextStyle(fontSize: screenHeight * 0.015),
                                                  ),
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
