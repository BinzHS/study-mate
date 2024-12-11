import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymate/pages/Friends.dart';
import 'package:studymate/pages/Lessons.dart';
import 'package:studymate/pages/Notes.dart';
import 'package:studymate/pages/Profile.dart';
import 'package:studymate/pages/Signin.dart';
import 'package:studymate/screens/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Dashboard(), // Your Dashboard widget
    );
  }
}

TextEditingController fnamec = TextEditingController();
TextEditingController lnamec = TextEditingController();
bool userDetails = false;

bool loading = true; // Loading state
User? user = FirebaseAuth.instance.currentUser;

Map<String, dynamic>? userData; // Variable to store user details

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final user = FirebaseAuth.instance.currentUser;
  Future<void> fetchUserDetails() async {
    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user!.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = querySnapshot.docs.first;
          setState(() {
            userData = userDoc.data()
                as Map<String, dynamic>?; // Store user data in userData variabe
          });
        }
        setState(() {
          userDetails = querySnapshot.docs.isNotEmpty;
          loading = false; // Stop loading indicator
        });
      } catch (e) {
        setState(() {
          loading = false; // Stop loading indicator in case of an error
        });
        print('Error fetching user details: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                // Sign out the user
                await FirebaseAuth.instance.signOut();

                // Navigate back to the home or login screen
                // Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
          ],
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : userDetails
                ? SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                            SizedBox(height: 20),
                            // Text(
                            //   '${userData!['fname']} ${userData!['lname']} !',
                            //   style: GoogleFonts.poppins(
                            //     fontSize: 40,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.black,
                            //   ),
                            //   textAlign: TextAlign.center,
                            // ),
                            // SizedBox(
                            //   height: 20,
                            // ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF9FB8C4),
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
                                        child: Text(
                                          "Go to Lessons",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF104D6C),
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
                                        Icons.menu_book_outlined,
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
                                  MaterialPageRoute(
                                      builder: (context) => Notes()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF9FB8C4),
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
                                        child: Text(
                                          "Manage Notes",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF104D6C),
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
                                        Icons.notes,
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
                                  MaterialPageRoute(
                                      builder: (context) => Friends()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF9FB8C4),
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
                                        child: Text(
                                          "Manage Friends",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF104D6C),
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
                                        Icons.supervised_user_circle_sharp,
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Profile()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF9FB8C4),
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
                                        child: Text(
                                          "Profile",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF104D6C),
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
                                        Icons.account_circle,
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
                    ),
                  )
                : Center(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            TextField(
                              controller: fnamec,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                hintText: "First Name",
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: lnamec,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                hintText: "Last Name",
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  await addDetails();
                                } catch (e) {
                                  print('Error saving details: $e');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF9FB8C4),
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
                                            child: Text("Save Data",
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      const Color(0xFF104D6C),
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
                                backgroundColor: Color(0xFF9FB8C4),
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
                                              color: const Color(0xFF104D6C),
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                    ),
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
                  ));
  }

  Future<void> addDetails() async {
    await FirebaseFirestore.instance.collection("users").add({
      "email": user!.email,
      "fname": fnamec.text,
      "lname": lnamec.text,
    }).then((value) {
      fnamec.clear();
      lnamec.clear();
      setState(() {
        userDetails = true;
      });
    });
  }
}
