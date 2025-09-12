import 'package:flutter/material.dart';
import 'splash.dart';
import 'homepage.dart';
import 'search.dart';
import 'profile.dart';
import 'order.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Marketplace App',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const SplashPage(),
    );
  }
}
