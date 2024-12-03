import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController emailc = TextEditingController();
  TextEditingController fnamec = TextEditingController();
  TextEditingController lnamec = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData; // Variable to store user details

  bool isEditing = false;
  bool isLoading = true;

  Future<void> updateUserDetails() async {
    if (user != null) {
      try {
        // Check if the new email is already registered

        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.scale,
          title: 'Confirm',
          desc: 'Are you sure you want to update your profile?',
          btnCancelOnPress: () {},
          btnOkOnPress: () async {
            // Email is not registered, proceed to update user details
            QuerySnapshot currentUserSnapshot = await FirebaseFirestore.instance
                .collection('users')
                .where('email',
                    isEqualTo: user!.email) // Fetch the current user's document
                .get();

            if (currentUserSnapshot.docs.isNotEmpty) {
              final docId =
                  currentUserSnapshot.docs.first.id; // Get the document ID

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(docId)
                  .update({
                'fname': fnamec.text,
                'lname': lnamec.text,
                'email': emailc.text
              });

              print('User details updated successfully');
              setState(() {
                isEditing = false; // Exit editing mode after saving
                userData = {
                  'fname': fnamec.text,
                  'lname': lnamec.text,
                  'email': emailc.text
                }; // Update the local userData with the new values
              });
            } else {
              print('Error: No user found for the current email.');
            }
          },
        ).show();
      } catch (e) {
        print('Error updating user details: $e');
        // Optionally, show a dialog or snackbar with the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> fetchUserDetails() async {
    if (user != null) {
      try {
        // Fetch user document from Firestore where the document ID matches the user's UID
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user!.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = querySnapshot.docs.first;

          setState(() {
            userData = userDoc.data() as Map<String,
                dynamic>?; // Store user data in userData variable
            if (userData != null) {
              emailc.text = userData!['email'] ?? '';
              fnamec.text = userData!['fname'] ?? '';
              lnamec.text = userData!['lname'] ?? '';
            }
            isLoading = false; // Stop loading once data is fetched
          });
        } else {
          print('User document does not exist');
          setState(() {
            isLoading = false; // Stop loading if user document is not found
          });
        }
      } catch (e) {
        print('Error fetching user details: $e');
        setState(() {
          isLoading = false; // Stop loading on error
        });
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
      extendBody: true,
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while data is being fetched
          : Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/b.jpg'),
                  fit: BoxFit.cover,
                  alignment: Alignment(-0.21, 0),
                  opacity: 0.7,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isEditing) ...[
                      const SizedBox(height: 20),
                      TextField(
                        controller: fnamec,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),

                          hintStyle: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.7), // Label color
                            fontSize: 20.0, // Label font size
                            fontWeight: FontWeight.bold, // Label font weight
                          ),
                          hintText: "First Name",
                          fillColor: Colors.white, // Background color
                          filled: true, // Enable the background color
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
                            color: Colors.black.withOpacity(0.7), // Label color
                            fontSize: 20.0, // Label font size
                            fontWeight: FontWeight.bold, // Label font weight
                          ),
                          hintText: "Last name",
                          fillColor: Colors.white, // Background color
                          filled: true, // Enable the background color
                        ),
                      ),
                    ] else if (userData != null) ...[
                      Text('Email: ${userData!['email']}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 20),
                      Text('First Name: ${userData!['fname']}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 20),
                      Text('Last Name: ${userData!['lname']}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ] else ...[
                      const Text('No user data available.'),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (isEditing) {
                          updateUserDetails();
                        } else {
                          if (userData != null) {
                            emailc.text = userData!['email'] ?? '';
                            fnamec.text = userData!['fname'] ?? '';
                            lnamec.text = userData!['lname'] ?? '';
                          }
                          setState(() {
                            isEditing = !isEditing; // Toggle editing mode
                          });
                        }
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
                                  child: isEditing
                                      ? Text("Update",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ))
                                      : Text("Update Profile",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ))),
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
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
    );
  }
}
