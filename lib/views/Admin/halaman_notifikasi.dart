import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendNotificationPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  Future<void> sendNotificationToFirestore(String title, String message) async {
    try {
      await FirebaseFirestore.instance.collection('notif_admin').add({
        'title': title,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Sukses', 'Notifikasi berhasil dikirim ke Firestore!');
    } catch (e) {
      Get.snackbar('Gagal', 'Terjadi kesalahan: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kirim Notifikasi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Judul Notifikasi'),
            ),
            TextField(
              controller: messageController,
              decoration: InputDecoration(labelText: 'Pesan Notifikasi'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String title = titleController.text.trim();
                String message = messageController.text.trim();

                if (title.isNotEmpty && message.isNotEmpty) {
                  sendNotificationToFirestore(title, message);
                } else {
                  Get.snackbar('Gagal', 'Judul dan pesan tidak boleh kosong!');
                }
              },
              child: Text('Kirim Notifikasi'),
            ),
          ],
        ),
      ),
    );
  }
}
