import 'package:flutter/material.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditUser extends StatefulWidget {
  final User user;

  const EditUser({super.key, required this.user});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  late User _user;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  _saveUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('user', jsonEncode(_user.toJson()));
      Navigator.pop(context, _user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh Sửa Người Dùng'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('NumberID', _user.idNumber,
                          (value) => _user.idNumber = value),
                      _buildTextField('Họ và tên', _user.fullName,
                          (value) => _user.fullName = value),
                      _buildTextField('Số điện thoại', _user.phoneNumber,
                          (value) => _user.phoneNumber = value),
                      _buildTextField('Giới tính', _user.gender,
                          (value) => _user.gender = value),
                      _buildTextField('Ngày sinh', _user.birthDay,
                          (value) => _user.birthDay = value),
                      _buildTextField('Năm học', _user.schoolYear,
                          (value) => _user.schoolYear = value),
                      _buildTextField('Mã trường', _user.schoolKey,
                          (value) => _user.schoolKey = value),
                      _buildTextField('Ngày tạo', _user.dateCreated,
                          (value) => _user.dateCreated = value),
                      const SizedBox(height: 20), // Space before the button
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // Space between form and button
            ElevatedButton(
              onPressed: _saveUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Background color
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
              child: const Text(
                'Lưu',
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontWeight: FontWeight.bold, // Text weight
                  fontSize: 16, // Text size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String? initialValue, FormFieldSetter<String> onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.orange),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        ),
        onSaved: onSaved,
      ),
    );
  }
}
