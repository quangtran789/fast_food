import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87, // Replace with your desired background color
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/on_boarding_3.png',
            width: 600,
            height: 300,
            fit: BoxFit.contain,
          ),
          const Text(
            "Theo dõi trực tiếp",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.amber, fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "Theo dõi thời gian thực thực phẩm của bạn trên app\nmột khi bạn đã đặt hàng",
            style: TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
