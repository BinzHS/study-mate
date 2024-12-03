import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymate/pages/Signin.dart';
import 'package:studymate/pages/Signup.dart';
import 'package:studymate/pages/About.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ContactManagementScreen(),
      ),
    );
  }
}

class ContactManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(''),
            fit: BoxFit.cover,
            alignment: Alignment(-0.21, 0),
            opacity: 0.7 //
            ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 125),
            Text(
              'Welcome To',
              style: GoogleFonts.poppins(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'StudyMate',
              style: GoogleFonts.poppins(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 250),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Signin()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "Sign In",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.login_rounded,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Signup()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.login_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const About()),
                );},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "About",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
