import 'package:flutter/material.dart';
import 'package:sharebook/blog/loginUI/login.dart';
import 'dart:io';

import 'package:sharebook/home.dart';

class PostHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'ShareBook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}