import 'dart:ui';
import 'package:app_api/app/config/const.dart';
import 'package:flutter/material.dart';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/register.dart';
import 'package:app_api/app/page/auth/login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _gender = 0;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _numberIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _schoolKeyController = TextEditingController();
  final TextEditingController _schoolYearController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _imageURL = TextEditingController();
  String gendername = 'None';
  String temp = '';

  Future<String> register() async {
    return await APIRepository().register(Signup(
      accountID: _accountController.text,
      birthDay: _birthDayController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      fullName: _fullNameController.text,
      phoneNumber: _phoneNumberController.text,
      schoolKey: _schoolKeyController.text,
      schoolYear: _schoolYearController.text,
      gender: getGender(),
      imageUrl: _imageURL.text,
      numberID: _numberIDController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg12.webp'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Image.asset(
                    urlLogo, // Replace with your logo
                    height: 165,
                    width: 310,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      // Frosted glass effect using BackdropFilter
                      Container(
                        decoration: BoxDecoration(
                          color:
                              Colors.black.withOpacity(0.5), // Background color
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withOpacity(0.1), // Transparency level
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Colors.white,
                                    width: 2), // White border
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    textField(_accountController, "Tài khoản",
                                        Icons.person),
                                    textField(_passwordController, "Mật khẩu",
                                        Icons.password),
                                    textField(
                                      _confirmPasswordController,
                                      "Xác nhận mật khẩu",
                                      Icons.password,
                                    ),
                                    textField(_fullNameController, "Tên đầy đủ",
                                        Icons.text_fields_outlined),
                                    textField(_numberIDController, "Mã ID",
                                        Icons.key),
                                    textField(_phoneNumberController,
                                        "Số điện thoại", Icons.phone),
                                    textField(_birthDayController,
                                        "Ngày sinh nhật", Icons.date_range),
                                    textField(_schoolYearController, "Năm học",
                                        Icons.school),
                                    textField(_schoolKeyController, "Khóa học",
                                        Icons.school),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "Giới tính của bạn là gì?",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            title: const Text("Nam",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            leading: Transform.translate(
                                              offset: const Offset(16, 0),
                                              child: Radio(
                                                value: 1,
                                                groupValue: _gender,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _gender = value!;
                                                  });
                                                },
                                                activeColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            title: const Text("Nữ",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            leading: Transform.translate(
                                              offset: const Offset(16, 0),
                                              child: Radio(
                                                value: 2,
                                                groupValue: _gender,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _gender = value!;
                                                  });
                                                },
                                                activeColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            title: const Text("Khác",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            leading: Transform.translate(
                                              offset: const Offset(16, 0),
                                              child: Radio(
                                                value: 3,
                                                groupValue: _gender,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _gender = value!;
                                                  });
                                                },
                                                activeColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _imageURL,
                                      decoration: const InputDecoration(
                                        labelText: "Tải hình ảnh",
                                        icon: Icon(Icons.image,
                                            color: Colors.white),
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(),
                                      ),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          String response = await register();
                                          if (response == "ok") {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ),
                                            );
                                          } else {
                                            print(response);
                                          }
                                        },
                                        child: const Text("Đăng ký"),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Quay lại đăng nhập"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getGender() {
    if (_gender == 1) {
      return "Nam";
    } else if (_gender == 2) {
      return "Nữ";
    }
    return "Khác";
  }

  Widget textField(
      TextEditingController controller, String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: label.contains('Password'),
        onChanged: (value) {
          setState(() {
            temp = value;
          });
        },
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(icon, color: Colors.white),
          labelStyle: const TextStyle(color: Colors.white),
          border: const OutlineInputBorder(),
          errorText: controller.text.trim().isEmpty ? 'Please enter' : null,
          focusedErrorBorder: controller.text.isEmpty
              ? const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red))
              : null,
          errorBorder: controller.text.isEmpty
              ? const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red))
              : null,
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
