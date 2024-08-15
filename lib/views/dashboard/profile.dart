import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard.controller.dart';
import 'edit.profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -1),
                  stops: [0.3, 0.7],
                  radius: 1.5,
                  colors: [
                    Color(0xFFC1BCBC),
                    Color(0xFF0E8EC5),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -170),
              child: Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, 170),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            child: Center(
                              child: Text(
                                controller.name.value,
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.grey[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            child: Center(
                              child: Text(
                                controller.email.value,
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Container(
                          height: 50,
                          width: 340,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF7FDB17),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5.0,
                            ),
                            onPressed: () {
                              Get.to(() => EditProfilePage(),
                                  arguments: controller.storage.getId());
                            },
                            child: const Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 340,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFFFF0000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5.0,
                          ),
                          onPressed: () {
                            controller.logout();
                          },
                          child: const Text(
                            'Keluar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
}
