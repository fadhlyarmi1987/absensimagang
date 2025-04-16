// import 'package:firebase_messaging/firebase_messaging.dart';

// class FCMService {
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;

//   Future<void> initializeFCM() async {
//     // Minta izin notifikasi
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }

//     // Ambil token perangkat untuk pengiriman notifikasi
//     String? token = await _messaging.getToken();
//     print("FCM Token: $token");

//     // Listener untuk pesan foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         print('Message Title: ${message.notification!.title}');
//         print('Message Body: ${message.notification!.body}');
//       }
//     });

//     // Listener untuk pesan ketika aplikasi dibuka dari background
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('Message clicked!');
//     });

//     // Listener untuk pesan ketika aplikasi dibuka dari terminated state
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }

//   Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     print("Handling a background message: ${message.notification?.title}");
//     // Logic untuk background
//   }
// }
