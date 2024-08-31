import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';
import 'dart:convert';
import 'edit_user.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  User user = User.userEmpty();

  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  _navigateToEditUser() async {
    final editedUser = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditUser(user: user)),
    );

    if (editedUser != null) {
      setState(() {
        user = editedUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://cdn.tgdd.vn/Files/2020/08/26/1283932/cach-luoc-ga-thom-ngon-ga-dai-khong-bi-nut-da-mau-vang-dep-202401181559592219.jpeg'),
                  radius: 60,
                ),
                const SizedBox(height: 24),
                buildProfileRow(Icons.person, 'Tên đầy đủ', user.fullName),
                buildProfileRow(Icons.phone, 'Số điện thoại', user.phoneNumber),
                buildProfileRow(Icons.location_on, 'Địa chỉ',
                    'abc address, xyz city'), // Assuming address is part of the user model
                buildProfileRow(Icons.email, 'Email',
                    'ahadhashmideveloper@gmail.com'), // Assuming email is part of the user model
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _navigateToEditUser,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.black, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Chỉnh sửa thông tin',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontWeight: FontWeight.bold, // Text bold
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.edit,
                        color: Colors.white,
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

  Widget buildProfileRow(IconData icon, String title, String? content) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content ?? ''),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.orange),
      ),
    );
  }
}
