import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymate/pages/MainFile.dart';

class Emailverification extends StatefulWidget {
  const Emailverification({super.key});

  @override
  State<Emailverification> createState() => _EmailverificationState();
}

class _EmailverificationState extends State<Emailverification> {
  User? user = FirebaseAuth.instance.currentUser;
  late Timer timer;

@override
void initState(){

  super.initState();
    sendEmailVerification();

    // Timer to periodically check for email verification status
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      FirebaseAuth.instance.currentUser
          ?.reload(); // Reload user to check for verification status

      if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
        // Stop the timer once the email is verified
        timer.cancel();

        // Navigate to the MainFile page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainFile()),
        );
      }
    });


}

Future<void> sendEmailVerification() async {
    try {
      await user!.sendEmailVerification();
      print("Email verification sent to ${user?.email}");
    } catch (e) {
      print("An error occurred: $e");
    }
  }


    @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }




  
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
           
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please verify your email address. A verification email has been sent to your email address ${user?.email}',
                    style: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      sendEmailVerification();
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.scale,
                        title: 'Email Sent',
                        desc:
                            'A verification email has been sent to your email address ${user?.email}',
                        btnOkOnPress: () {},
                      )..show();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: Center(
                                  child: Text("Resend Email",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      )))),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: const Icon(
                              Icons.arrow_forward,
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
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: Center(
                                  child: Text("Logout",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      )))),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
