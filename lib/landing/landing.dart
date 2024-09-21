import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project/auth/Login.dart';
import 'package:project/auth/daftar.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[900]!, Colors.blue[600]!, Colors.blue[400]!],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Animate(
                  effects: [
                    FadeEffect(duration: 2.seconds),
                    MoveEffect(begin: Offset(-50, -50), end: Offset.zero, duration: 2.seconds),
                  ],
                  child: Image.network(
                    'https://www.transparenttextures.com/patterns/cubes.png',
                    repeat: ImageRepeat.repeat,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.access_time_rounded,
                          size: 100,
                          color: Colors.white,
                        ).animate()
                          .fadeIn(duration: 600.ms)
                          .scale(delay: 300.ms)
                          .shimmer(duration: 1.seconds, delay: 1.seconds),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Payment',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.3),
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ).animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.2, end: 0, curve: Curves.easeOut)
                        .shimmer(duration: 1.seconds, delay: 1.2.seconds),
                      SizedBox(height: 10),
                      Text(
                        'Sistem Payment Modern',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.8),
                          letterSpacing: 1.2,
                        ),
                      ).animate()
                        .fadeIn(delay: 300.ms)
                        .slideY(begin: 0.2, end: 0, curve: Curves.easeOut)
                        .shimmer(duration: 1.seconds, delay: 1.4.seconds),
                      SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blue[800],
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          'MASUK',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ).animate()
                        .fadeIn(delay: 600.ms)
                        .slideY(begin: 0.2, end: 0, curve: Curves.easeOut)
                        .shimmer(duration: 1.seconds, delay: 1.6.seconds),
                      SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Daftar()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white, width: 2),
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'DAFTAR',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ).animate()
                        .fadeIn(delay: 900.ms)
                        .slideY(begin: 0.2, end: 0, curve: Curves.easeOut)
                        .shimmer(duration: 1.seconds, delay: 1.8.seconds),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}