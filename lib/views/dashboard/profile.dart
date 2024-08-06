import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard.controller.dart';

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
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -1),
                  stops: [0.3, 0.7],
                  radius: 1.5,
                  colors: [Color.fromARGB(255, 193, 188, 188), const Color.fromARGB(255, 14, 142, 197)],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -170),
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  elevation: 8.0,
                  child: Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, 170),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
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
                            child: Center(
                              child: Text('Nama'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          child: Card(
                            color: Colors.white,
                            child: Center(
                              child: Text('Email'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 140),
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          child: Card(
                            color: Colors.white,
                            child: Center(
                              child: Text('Password'),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color.fromARGB(255, 249, 249, 249),
                                backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 1.0,
                              ),
                              onPressed: () {
                                controller.logout();
                              },
                              child: Center(
                                child: Text('Keluar'),
                              ),
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
