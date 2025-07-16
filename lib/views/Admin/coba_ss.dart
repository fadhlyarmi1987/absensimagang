// import 'package:flutter/material.dart';
// import 'package:no_screenshot/no_screenshot.dart';

// class SecurePage extends StatefulWidget {
//   const SecurePage({Key? key}) : super(key: key);

//   @override
//   State<SecurePage> createState() => _SecurePageState();
// }

// class _SecurePageState extends State<SecurePage> {
//   final _secure = NoScreenshot.instance;

//   @override
//   void initState() {
//     super.initState();
//     _secure.secure(); // Aktifkan proteksi screenshot
//   }

//   @override
//   void dispose() {
//     _secure.unsecure(); // Nonaktifkan saat halaman ditutup
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text(
//           'Halaman ini tidak dapat di-screenshot atau direkam layar.',
//           style: TextStyle(fontSize: 18),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
