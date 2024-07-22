import 'package:absensimagang/route/page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'views/auth/login_page.dart';
import 'views/auth/register_page.dart';
import 'package:get/get.dart';

void main () async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Natusi Login/Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      
      initialRoute: '/Login',
      getPages: pages,
    );
  }
}
