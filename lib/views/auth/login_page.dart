import 'package:absensimagang/route/page.dart';
import 'package:absensimagang/views/auth/auth.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_page.dart';

class LoginPage extends GetView<AuthController> {
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Color.fromARGB(255, 14, 142, 197),
      body:  SafeArea(
        child: Center(
        
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Image.asset('assets/Logo_Natusi.png', height: 80),
                ),
                SizedBox(height: 20),
                Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                CustomTextField(
                  label: 'Email/Username',
                  controller: controller.controllerEmail,
                ),
                CustomTextField(
                  label: 'Password',
                  obscureText: true,
                  controller: controller.controllerPassword,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => controller.login(),
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 4, 181, 18),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'KIRIM',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Belum punya akun?\nKlik icon disamping untuk mendaftar',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward, color: Colors.white),
                        onPressed: () {
                          Get.offAllNamed(Routes.register);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    required this.label,
    this.obscureText = false,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 7),
          )
        ], borderRadius: BorderRadius.circular(30)),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: label,
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
        ),
      ),
    );
  }
}
