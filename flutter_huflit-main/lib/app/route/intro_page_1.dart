import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/onb1.png',
            width: 500,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Hãy tìm kiếm món ăn\nmà bạn thích",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.amber, fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "Khám phá những món ăn ngon từ\ncác nhà hàng và giao hàng nhanh đến\nnhà bạn",
            style: TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
