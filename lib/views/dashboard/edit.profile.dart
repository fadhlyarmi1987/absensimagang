import 'package:absensimagang/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'dashboard.controller.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final DashboardController controller = Get.find<DashboardController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final Storage storage = Storage();
  late String userId;
  

  
    final a = Get.arguments;

  @override
  void initState() {
    super.initState();
    _nameController.text = controller.name.value;
    _emailController.text = controller.email.value;
    userId = storage.getId().toString(); 
    print(a);
  }

  Future<void> _updateProfile() async {
    try {
      final response = await Dio().put('http://192.168.2.70:8000/api/users/$userId', 
        data: {
          'id' : storage.getId(),
          'name': _nameController.text,
          'email': _emailController.text,
        },
      );

      if (response.statusCode == 200) {
        // Update local controller values
        controller.name.value = _nameController.text;
        controller.email.value = _emailController.text;
        Get.snackbar('Success', 'Profile updated successfully');
        Navigator.pop(context);
      } else {
        Get.snackbar('Error', 'Failed to update profile');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred');
    }
  }

    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

