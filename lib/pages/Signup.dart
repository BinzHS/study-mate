import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studymate/pages/SignupWithEmail.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  Future<UserCredential> continueWithGoogle() async {
    print("Google sign-in initiated.");
    try {
      // Sign out from any previous Google session to force account selection
      await GoogleSignIn().signOut();

      // Trigger the Google authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // If the user cancels the sign-in flow, handle the situation gracefully
        print("Google sign-in was canceled by the user.");
        return Future.error("Google sign-in canceled");
      }

      // Obtain the Google authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential using the tokens
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in to Firebase with the credential and return the UserCredential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user; // Get the signed-in user

      print("User's email: ${user?.email}");

      return userCredential;
    } catch (e) {
      print("Error: $e");
      return Future.error(e); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 160.0, // Set the desired width
              height: 160.0, // Set the desired height
              child: Image.asset("assets/account.png"),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Signupwithemail()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9FB8C4),
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
                          "Sign Up With Email and Password",
                          style: GoogleFonts.poppins(
                            color:const Color(0xFF104D6C),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60.0, // Set the desired width
                      height: 60.0, // Set the desired height
                      child: Image.asset("assets/email.png"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                continueWithGoogle().then((value) {
                  print(value.user!.displayName);
                }).catchError((e) {
                  print(e);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9FB8C4),
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
                          "Continue with Google",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF104D6C),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60.0, // Set the desired width
                      height: 60.0, // Set the desired height
                      child: Image.asset("assets/google.png"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
