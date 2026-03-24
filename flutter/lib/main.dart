import 'package:flutter/material.dart';
import 'pages/splash_screen.dart'; // Ajusta la ruta si es necesario

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(), // ← Ahora el splash decide
      debugShowCheckedModeBanner: false,
    );
  }
}