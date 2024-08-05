import '../modal/maps_modal.dart';
import 'dashboard.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends GetView<DashboardController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                        color: Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
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
                                        color: Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                  SizedBox(height: 1),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: const Color.fromARGB(255, 255, 255, 255)),
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
              top: 210,
              left: 40,
              right: 40,
              child: Container(
                height: 150,
                child: Card(
                  color: Color.fromARGB(255, 255, 255, 255),
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
                        Padding(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text('07:00 - 08:00'),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return MapPage();
                                        },
                                      );
                                    },
                                    child: Text(
                                      'Check-In',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('16:30 - 17:00'),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () {},
                                    child: Text('Check-Out',
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
                    color: Color.fromARGB(255, 247, 245, 245),
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
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Check-In:'),
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
                                              Text('Check-Out:'),
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
          ],
        ),
      ),
    );
  }
}
