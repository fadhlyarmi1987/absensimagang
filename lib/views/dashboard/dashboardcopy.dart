import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPageC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0085C3), 
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  Image.asset('assets/Logo_Natusi.png', height: 60), // Ganti dengan path logo Anda
                  SizedBox(height: 20),
                  Text('Now', style: GoogleFonts.roboto(color: Colors.white, fontSize: 20)),
                  Text('10.45', style: GoogleFonts.roboto(color: Colors.white, fontSize: 60)),
                  Text('Kamis, 18 Juli 2024', style: GoogleFonts.roboto(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
           
            Container(
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Text('Keterangan Jam Absensi', style: GoogleFonts.roboto(fontSize: 18)),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text('07.30-08.00', style: GoogleFonts.roboto(fontSize: 18)),
                                Text('Cek-In', style: GoogleFonts.roboto(color: Colors.green, fontSize: 18)),
                              ],
                            ),
                            SizedBox(width: 20),
                            Column(
                              children: [
                                Text('17.00-18.00', style: GoogleFonts.roboto(fontSize: 18)),
                                Text('Cek-Out', style: GoogleFonts.roboto(color: Colors.red, fontSize: 18)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.login, color: Colors.white),
                              label: Text('Cek-In', style: GoogleFonts.roboto(color: Colors.white)),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton.icon(
                              icon: Icon(Icons.logout, color: Colors.white),
                              label: Text('Cek-Out', style: GoogleFonts.roboto(color: Colors.white)),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Recent Attendance', style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            _buildAttendanceItem('Kamis, 18 Juli 2024', '07.45', '17.10'),
                            _buildAttendanceItem('Rabu, 17 Juli 2024', '07.45', '17.10'),
                            _buildAttendanceItem('Selasa, 16 Juli 2024', '07.45', '17.10'),
                            _buildAttendanceItem('Senin, 15 Juli 2024', '07.45', '17.10'),
                            _buildAttendanceItem('Jumat, 14 Juli 2024', '07.45', '17.10'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Add your onTap logic here
        },
      ),
    );
  }

  Widget _buildAttendanceItem(String date, String checkIn, String checkOut) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date, style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
        SizedBox(height: 5),
        Text('Cek-In: $checkIn', style: GoogleFonts.roboto(fontSize: 14)),
        Text('Cek-Out: $checkOut', style: GoogleFonts.roboto(fontSize: 14)),
        Divider(color: Colors.grey),
      ],
    );
  }
}
