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
                        right: screenWidth * 0.6,
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
                          height: screenHeight * 0.06,
                          width: screenWidth * 0.4,
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
                              fontSize: screenHeight * 0.025,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          StreamBuilder(
                          stream: Stream.periodic(Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            var now = DateTime.now();
                            var formattedTime =
                                DateFormat('HH:mm:ss').format(now);
                            var formattedDate =
                                DateFormat('EEEE, dd MMMM yyyy', 'id')
                                    .format(now);

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formattedTime,
                                  style: TextStyle(
                                      fontSize: 50,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                                  const SizedBox(height: 1),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.025,
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
              top: screenHeight * 0.01,
              right: screenWidth * 0.03,
              child: Obx(() {
                return Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(screenHeight * 0.01),
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth * 0.4,
                          child: Text(
                            'Hai,',
                            style: GoogleFonts.lobster(
                                fontSize: screenHeight * 0.02,
                                color: Colors.white),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Container(
                          width: screenWidth * 0.4,
                          child: Text(
                            '${controller.name.value}',
                            style: GoogleFonts.greatVibes(
                                fontSize: 22,
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
              top: screenHeight * 0.26,
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              child: Container(
                height: isPortrait ? screenHeight * 0.2 : screenHeight * 0.25,
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
                            fontSize: screenHeight * 0.02,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
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
                                        fontSize: screenHeight * 0.02,
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
                                        fontSize: screenHeight * 0.02,
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
              top: screenHeight * 0.5,
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Stack(
                    children: [
                      Container(
                        height: screenHeight * 0.35,
                        color: const Color.fromARGB(255, 247, 245, 245),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(screenHeight * 0.015),
                              child: Text(
                                'History Absen',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenHeight * 0.015,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Obx(() {
                                return ListView.builder(
                                  itemCount: controller.listhadir.length,  // Update here
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
                                              fontSize: screenHeight * 0.02,
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
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: Icon(Icons.refresh, color: Colors.blue),
                          onPressed: _refreshData,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _refreshData() {
    controller.fetchAttendance();
  }
}
