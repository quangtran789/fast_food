import 'package:app_api/app/components/button.dart';
import 'package:app_api/app/components/colors.dart';
import 'package:app_api/app/page/auth/login.dart';
import 'package:app_api/app/page/register.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Xác thực",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                const Text(
                  "Xác thực để truy cập thông tin ảo của bạn",
                  style: TextStyle(color: Colors.blue),
                ),

                Expanded(
                  child: Image.asset(
                    "assets/images/startup.jpg",
                  ),
                ),

                Button(
                    label: "Đăng nhập",
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    }),
                Button(
                    label: "Đăng ký",
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()));
                    }), // Hình ảnh được khai báo ở đây
              ],
            ),
          ),
        ),
      ),
    );
  }
}
