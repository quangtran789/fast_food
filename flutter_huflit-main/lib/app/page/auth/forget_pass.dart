import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/page/auth/login.dart';
import '../../data/sharepre.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController accountIDController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  Future<void> forgotPassword() async {
    try {
      String response = await APIRepository().forgotPassword(
        accountIDController.text,
        idNumberController.text,
        newPasswordController.text,
      );

      print('API Response: $response'); // Debugging

      if (response == "ok") {
        var user = await APIRepository().current(response);
        saveUser(user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reset password: $response')),
        );
      }
    } catch (e) {
      if (e.toString().contains('401')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thay đổi thành công')),
        );
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Stack(
              children: [
                // Frosted glass effect using BackdropFilter
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5), // Background color
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
                              color: Colors.white, width: 2), // White border
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Image.asset(
                                'assets/images/pngwing.com (1).png', // Asset image
                                height: 180,
                                width: 180,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Nhập thông tin để đặt lại mật khẩu',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              textField(accountIDController, "ID tài khoản",
                                  Icons.person),
                              const SizedBox(height: 16),
                              textField(idNumberController, "Số ID",
                                  Icons.confirmation_number),
                              const SizedBox(height: 16),
                              textField(newPasswordController, "Mật khẩu mới",
                                  Icons.lock,
                                  obscureText: true),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: forgotPassword,
                                child: Text('Xác nhận'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
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
          ),
        ),
      ),
    );
  }

  Widget textField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.white),
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}
