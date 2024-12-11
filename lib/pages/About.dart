import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About StudyMate',
          style: GoogleFonts.poppins(
            // Set the font size (adjust as needed)
            fontWeight: FontWeight.bold, // Adjust weight if needed
          ),
        ),
        backgroundColor: const Color(0xFF104D6C),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the back arrow color to white
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Image.asset(
              'assets/appbar_logo.png', // Ensure the logo is in your assets folder
              height: 70,
              width: 70,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Name
            Center(
              child: Text(
                'StudyMate',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF104D6C),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // App Logo
            Center(
              child: Image.asset(
                'assets/app_logo.png', // App logo (ensure it exists in your assets)
                height: 250,
                width: 250,
              ),
            ),

            const SizedBox(height: 24),

            // Mission Statement
            Text(
              'Our Mission:',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '• Empower students to excel academically.',
                  style: TextStyle(color: Color(0xFF104D6C), fontSize: 16),
                ),
                Text(
                  '• Provide efficient tools for managing studies.',
                  style: TextStyle(color: Color(0xFF104D6C), fontSize: 16),
                ),
                Text(
                  '• Simplify access to study resources.',
                  style: TextStyle(color: Color(0xFF104D6C), fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Brief Description
            Text(
              'About StudyMate:',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'StudyMate is your ultimate companion for academic success. It helps students '
              'manage tasks, track progress, and access a wealth of study resources with ease. '
              'Our mission is to make learning more accessible and efficient for everyone.',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: const Color(0xFF104D6C),
              ),
            ),

            const SizedBox(height: 24),

            // Developers Section
            Text(
              'Meet Our Developers:',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Developer 1
                Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/developer1.png', // Developer 1's image
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Binura \n Senavirathna',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF104D6C),
                        ),
                      ),
                    ),
                  ],
                ),

                // Developer 2
                Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/developer2.png', // Developer 2's image
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Chamod \n Senavirathna',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF104D6C),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
