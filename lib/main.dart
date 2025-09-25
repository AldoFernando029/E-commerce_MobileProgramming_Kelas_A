import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'order/order_provider.dart';
import 'pay/kuypay.dart'; // ✅ KuyPay ditambahkan
import 'pages/splash.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => KuyPay()), // ✅ KuyPay Provider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BelanjaKuy",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashPage(),
    );
  }
}
