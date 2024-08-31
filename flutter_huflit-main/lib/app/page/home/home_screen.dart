// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/data/sqlite.dart';
import 'package:app_api/app/model/cart.dart';
import 'package:app_api/app/model/product.dart';
import 'package:app_api/app/page/home/productdata_home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBuilder extends StatefulWidget {
  const HomeBuilder({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeBuilder> createState() => _HomeBuilderState();
}

class _HomeBuilderState extends State<HomeBuilder> {
  Future<List<ProductModel>> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getProductAdmin(
        prefs.getString('accountID').toString(),
        prefs.getString('token').toString());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      
      body: Center(child: ProductBuilder1()),
    );
  }
}
  