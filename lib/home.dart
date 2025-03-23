import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 155, 175, 192),
      body: Center(
        child: Text(
          dotenv.env['GREETING'] ?? 'Hello, World!',
          style: TextStyle(color: Colors.white, fontSize: 84),
        ),
      ),
    );
  }
}