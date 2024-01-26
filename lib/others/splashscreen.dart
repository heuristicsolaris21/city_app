import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/cityapplogo.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20), // Adjust the spacing as needed
            Image.asset(
              'assets/Hourglass.gif', // Update this path to your GIF file
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}

