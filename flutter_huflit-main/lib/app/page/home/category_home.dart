import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../model/category.dart';
import '../../config/const.dart';
import '../home/home_screen.dart';

Widget itemCateView(Category itemcate, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const HomeBuilder()));
    },
  );
}
