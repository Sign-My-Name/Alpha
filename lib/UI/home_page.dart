import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeee4fc),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 180, // Set the desired height for the logo
              width: 360, // Set the desired width for the logo
            ),
          ],
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // First routing button
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/identify');
              },
              child: SizedBox(
                height: 140,
                width: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('assets/five.png'),
                    const FractionalTranslation(
                      translation: Offset(0.0, 1),
                      child: Text(
                        'Identify',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 50),
            SizedBox(
              height: 400,
              width: 300,
              child: Image.asset('assets/boy.png'),
            ),
            const SizedBox(width: 50),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/identify');
              },
              child: SizedBox(
                height: 140,
                width: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('assets/five.png'),
                    const FractionalTranslation(
                      translation: Offset(0.0, 1),
                      child: Text(
                        'Identify',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
