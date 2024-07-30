import 'package:absensimagang/views/auth/auth.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../route/page.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends GetView<AuthController> {
  RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 14, 142, 197),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Image.asset('assets/Logo_Natusi.png', height: 80)),
              SizedBox(height: 20),
              Text('REGISTER',
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold))),
              SizedBox(height: 20),
              CustomTextField(
                  label: 'Nama', controller: controller.controllerNama),
              CustomTextField(
                  label: 'Email/Username',
                  controller: controller.controllerEmail),
              CustomTextField(
                  label: 'Password',
                  obscureText: true,
                  controller: controller.controllerPassword),
              CustomTextField(
                  label: 'Confirm Password',
                  obscureText: true,
                  controller: controller.controllerCPassword),


              Obx(() => CheckboxListTile(
                    title: Text('Saya Karyawan',
                        style: TextStyle(color: Colors.white)),
                    value: controller.isKaryawan.value,
                    onChanged: (value) {
                      controller.isKaryawan.value = value!;
                      if (value) controller.isMagang.value = false;
                    },
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                  )),
              Obx(() => CheckboxListTile(
                    title: Text('Saya Magang',
                        style: TextStyle(color: Colors.white)),
                    value: controller.isMagang.value,
                    onChanged: (value) {
                      controller.isMagang.value = value!;
                      if (value) controller.isKaryawan.value = false;
                    },
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                  )),

              SizedBox(height: 20),
              GestureDetector(
                onTap: () => controller.register(),
                child: Container(
                  width: 140,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
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
                        'Daftar',
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
                      'Sudah punya akun?\nKlik icon disamping untuk login',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.start,
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward, color: Colors.white),
                      onPressed: () {
                        //Navigator.pop(context);
                        Get.toNamed(Routes.init);
                      },
                    ),
                  ],
                ),
              ),
            ],
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
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ], borderRadius: BorderRadius.circular(40)),
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
