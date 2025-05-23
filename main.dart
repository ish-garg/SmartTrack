import 'package:flutter/material.dart';
import 'home_page.dart'; // Import the Home Page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      title: 'Smart Track',
      theme: ThemeData(
        primarySwatch: Colors.purple, // Set app theme color
      ),
      home: const HomePage(), // Set HomePage as the initial screen
    );
  }
}
