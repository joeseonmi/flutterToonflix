import 'package:flutter/material.dart';
import 'package:toonflix2/screens/home_screen.dart';

void main() {
  runApp(const Toonflix());
}

class Toonflix extends StatelessWidget {
  const Toonflix({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
