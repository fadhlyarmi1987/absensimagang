import 'package:absensimagang/route/page.dart';
import 'package:absensimagang/controller/auth.controller.dart';
import 'package:absensimagang/views/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController controller = Get.put(AuthController());
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    // Ambil data yang disimpan sebelumnya (jika ada)
    controller.controllerEmaillog.text = storage.read('saved_email') ?? '';
    controller.controllerPasswordlog.text =
        storage.read('saved_password') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/background_auth.jpg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(160, 255, 255, 255),
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
                      key: Key('emailField'), 
                      label: 'Email/Username',
                      controller: controller.controllerEmaillog,
                    ),
                     Obx(() => CustomTextField(
                    key:  Key('password'),
                        label: 'Password',
                        obscureText: !controller.isPasswordVisiblelogin.value,
                        controller: controller.controllerPasswordlog,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisiblelogin.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            controller.isPasswordVisiblelogin.value =
                                !controller.isPasswordVisiblelogin.value;
                          },
                        ),
                      )),
                    SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        controller.loginWithFirebase();
                      },
                      key: Key('login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, 
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(100), 
                        ),
                        elevation: 5, 
                        minimumSize: Size(100, 50), // Ukuran tombol
                        shadowColor: Colors.black.withOpacity(0.3),
                      ),
                      child: Text(
                        'KIRIM',
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
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
                            icon:
                                Icon(Icons.arrow_forward, color: Colors.white),
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
        ],
      ),
    );
  }
}
