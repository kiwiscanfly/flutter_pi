import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String greeting = dotenv.env['GREETING'] ?? 'Hello, World!';

  void changeGreeting() {
    setState(() {
      greeting = 'That tickles!!!';
    });

    // Change back to the original greeting after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        greeting = dotenv.env['GREETING'] ?? 'Hello, World!';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 155, 175, 192),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              greeting,
              style: const TextStyle(color: Colors.white, fontSize: 84),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: changeGreeting,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              ),
              child: const Text(
                'Push Me!', 
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}