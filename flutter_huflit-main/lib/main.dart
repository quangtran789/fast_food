import 'package:app_api/app/page/auth/auth.dart';
import 'package:app_api/app/route/onboard.dart';
import 'package:flutter/material.dart';
import 'package:app_api/app/page/auth/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Onboarding(),
      // initialRoute: "/",
      // onGenerateRoute: AppRoute.onGenerateRoute,  -> su dung auto route (pushName)
    );
  }
}
