import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project/home/ewallet.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[800]!, Colors.blue[400]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'logoHero',
                    child: Icon(
                      Icons.access_time_rounded,
                      size: 120,
                      color: Colors.white,
                    ),
                  ).animate()
                    .fadeIn(duration: Duration(milliseconds: 600))
                    .scale(delay: Duration(milliseconds: 300)),
                  SizedBox(height: 30),
                  _buildWelcomeText(),
                  SizedBox(height: 50),
                  _buildTextField('Username', Icons.person, false),
                  SizedBox(height: 20),
                  _buildTextField('Password', Icons.lock, true),
                  SizedBox(height: 30),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Animate(
      effects: [
        FadeEffect(delay: Duration(milliseconds: 300), duration: Duration(milliseconds: 500)),
        SlideEffect(begin: Offset(0, -0.1), end: Offset.zero, delay: Duration(milliseconds: 300), duration: Duration(milliseconds: 500)),
      ],
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Welcome to\nPaymentAPP',
              textAlign: TextAlign.center,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              speed: Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 1,
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, IconData icon, bool obscureText) {
    return Animate(
      effects: [
        FadeEffect(delay: Duration(milliseconds: 300), duration: Duration(milliseconds: 500)),
        MoveEffect(delay: Duration(milliseconds: 300), duration: Duration(milliseconds: 500), begin: Offset(-100, 0), end: Offset.zero),
      ],
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(icon, color: Colors.white70),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(delay: Duration(milliseconds: 500)),
        ScaleEffect(delay: Duration(milliseconds: 500)),
      ],
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Ewallet()), // Navigasi ke LoginPage
                            );
                          },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue[800],
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'LOGIN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}