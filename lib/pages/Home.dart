import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymate/pages/About.dart';
import 'package:studymate/pages/Signin.dart';
import 'package:studymate/pages/Signup.dart';
import 'package:studymate/pages/About.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF90CAF9),
              Color(0xFF64B5F6),
              Color(0xFF42A5F5),
              Color(0xFF2196F3),
            ],
          ),
        ),
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: ContactManagementScreen(),
        ),
      ),
    );
  }
}

class ContactManagementScreen extends StatelessWidget {
  const ContactManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Text(
                'Welcome To',
                style: GoogleFonts.poppins(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'StudyMate',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 30),
              Image.asset(
                'assets/app_logo.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 50),
              _buildButton(
                context: context,
                text: "Sign In",
                icon: Icons.login_rounded,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Signin()),
                ),
              ),
              const SizedBox(height: 16),
              _buildButton(
                context: context,
                text: "Sign Up",
                icon: Icons.person_add_rounded,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Signup()),
                ),
              ),
              const SizedBox(height: 16),
              _buildButton(
                context: context,
                text: "About",
                icon: Icons.info_rounded,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const About()),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1976D2),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 12),
            Icon(icon, size: 24),
          ],
        ),
      ),
    );
  }
}
