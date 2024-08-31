import 'dart:ui';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/data/sharepre.dart';
import 'package:app_api/app/page/auth/forget_pass.dart';
import 'package:app_api/app/page/register.dart';
import 'package:app_api/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:app_api/app/config/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  bool rememberCredentials = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  void autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedAccount = prefs.getString('savedAccount');
    String? savedPassword = prefs.getString('savedPassword');
    if (savedAccount != null && savedPassword != null) {
      accountController.text = savedAccount;
      passwordController.text = savedPassword;
      setState(() {
        rememberCredentials = true;
        showPassword = true; // Hiển thị mật khẩu vì đã lưu mật khẩu
      });
    }
  }

  void saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberCredentials) {
      await prefs.setString('savedAccount', accountController.text);
      await prefs.setString('savedPassword', passwordController.text);
    } else {
      await prefs.remove('savedAccount');
      await prefs.remove('savedPassword');
    }
  }

  Future<void> login() async {
    try {
      String token = await APIRepository()
          .login(accountController.text, passwordController.text);
      var user = await APIRepository().current(token);
      saveUser(user);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Mainpage()));
    } catch (e) {
      _showErrorDialog("Login failed", e.toString());
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Đăng nhập thất bại',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Tài khoản hoặc mật khẩu không chính xác!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg12.webp'),
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
                    fit: BoxFit.cover,
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
                                    TextFormField(
                                      controller: accountController,
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.white),
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                        labelText: "Tài khoản",
                                        labelStyle: const TextStyle(
                                            fontSize: 17, color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: passwordController,
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.white),
                                      obscureText: !showPassword,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                        ),
                                        labelText: "Mật khẩu",
                                        labelStyle: const TextStyle(
                                            fontSize: 17, color: Colors.white),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            showPassword
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              showPassword = !showPassword;
                                            });
                                          },
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Theme(
                                          data: ThemeData(
                                            unselectedWidgetColor: Colors
                                                .white, // Color for the unselected state of the checkbox
                                            checkboxTheme: CheckboxThemeData(
                                              fillColor: MaterialStateProperty
                                                  .all(Colors
                                                      .white), // Color for the checkbox when selected
                                              checkColor: MaterialStateProperty
                                                  .all(Colors
                                                      .black), // Color for the check mark
                                            ),
                                          ),
                                          child: Checkbox(
                                            value: rememberCredentials,
                                            onChanged: (value) {
                                              setState(() {
                                                rememberCredentials = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          'Lưu tài khoản',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors
                                                .white, // Color for the text
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: login,
                                        child: const Text("Đăng nhập"),
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Register(),
                                          ),
                                        );
                                      },
                                      child: const Text("Tạo tài khoản"),
                                    ),
                                    const SizedBox(height: 5),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ForgotPassword()),
                                        );
                                      },
                                      child: const Text("Quên mật khẩu"),
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
                  const Text(
                    "Hoặc kết nối với",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Add your social media logic here
                        },
                        icon: const Icon(
                          Icons.facebook,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Add your social media logic here
                        },
                        icon: const Icon(
                          Icons.bathtub,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Add your social media logic here
                        },
                        icon: const Icon(
                          Icons.alarm,
                          color: Colors.white,
                          size: 30,
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
}
