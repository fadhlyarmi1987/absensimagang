import 'package:absensimagang/views/dashboard/dashboard.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPageC2 extends GetView<DashboardController> {
  const DashboardPageC2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                Stack(
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
                      padding: const EdgeInsets.only(top: 40.0, left: 120.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: controller.logout , child: Text('keliuar')),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
