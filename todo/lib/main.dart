import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/home/splash_screen.dart';
import 'home/HomePage.dart';
import 'dart:io';


void main() async{
  // initialise the hive
 await Hive.initFlutter();
 // open a box
 var box = await Hive.openBox('mybox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      // theme: ThemeData(primarySwatch: ColorConstants.primary),
    );
  }
}
