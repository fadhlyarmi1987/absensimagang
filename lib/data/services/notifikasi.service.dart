import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('notif_admin') 
          .orderBy('timestamp', descending: true) 
          .limit(15) 
          .get();

      return snapshot.docs.map((doc) {
        return {
          'judul': doc['message'] ?? 'Tanpa Judul', 
          'isi': doc['title'] ?? 'Tidak ada isi', 
          'created_at': (doc['timestamp'] as Timestamp).toDate().toIso8601String(),
        };
      }).toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }
}
