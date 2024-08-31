import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

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
            'assets/images/on_boarding_2.png',
            width: 600,
            height: 300,
            fit: BoxFit.contain,
          ),
          const Text(
            "Giao hàng nhanh",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.amber, fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "Giao thức ăn nhanh đến nhà bạn, văn phòng\nhoặc mọi nơi",
            style: TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
