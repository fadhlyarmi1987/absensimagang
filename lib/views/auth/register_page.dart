import 'package:absensimagang/controller/auth.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../route/page.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends GetView<AuthController> {
  RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/background_auth.jpg', fit: BoxFit.cover),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(160, 255, 255, 255),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Image.asset('assets/Logo_Natusi.png', height: 80)),
                  SizedBox(height: 20),
                  Text('REGISTER',
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold))),
                  SizedBox(height: 0),
                  CustomTextField(
                      label: 'Nama', controller: controller.controllerNama),
                  CustomTextField(
                      label: 'Email/Username',
                      controller: controller.controllerEmail),
                  Obx(() => CustomTextField(
                        label: 'Password',
                        obscureText: !controller.isPasswordVisible.value,
                        controller: controller.controllerPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            controller.isPasswordVisible.value =
                                !controller.isPasswordVisible.value;
                          },
                        ),
                      )),
                  Obx(() => CustomTextField(
                        label: 'Confirm Password',
                        obscureText: !controller.isCPasswordVisible.value,
                        controller: controller.controllerCPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isCPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            controller.isCPasswordVisible.value =
                                !controller.isCPasswordVisible.value;
                          },
                        ),
                      )),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      //controller.register();
                      controller.registerWithFirebase();
                    },
                    child: Container(
                      width: 140,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(0.3),
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
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;
  final Widget? suffixIcon;

  const CustomTextField({
    Key? key,
    required this.label,
    this.obscureText = false,
    required this.controller,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(40),
        ),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: label,
            fillColor: Colors.white,
            filled: true,
            suffixIcon: suffixIcon,
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
