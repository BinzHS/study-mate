import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Viewnote extends StatefulWidget {
  final Map<String, dynamic> note; // Add the note parameter

  const Viewnote({super.key, required this.note}); // Pass note to the widget

  @override
  State<Viewnote> createState() => _ViewnoteState();
}

class _ViewnoteState extends State<Viewnote> {
  @override
  void initState() {
    super.initState();
    checkIfNoteIsFavorite();
  }

  Future<void> addToFavorites(String noteId) async {
    try {
      // Get the current user's email
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is logged in");
        return;
      }

      String userEmail = user.email!;

      // Query Firestore to find the user document by email
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userSnapshot.docs.isEmpty) {
        print("No user found with this email.");
        return;
      }

      // Get the document reference of the first (and ideally only) matched user
      DocumentReference userDocRef = userSnapshot.docs.first.reference;

      // Update the user's 'favNotes' field (add noteId if not already in the array)
      await userDocRef.update({
        'favNotes':
            FieldValue.arrayUnion([noteId]), // Adds noteId to favNotes array
      });

      print("Note added to favorites successfully!");
    } catch (e) {
      print("Error adding note to favorites: $e");
    }
  }

  Future<void> removeFromFavorites() async {
    try {
      // Get the current user's email
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is logged in");
        return; // No user logged in, return
      }

      String userEmail = user.email!;

      // Query Firestore to find the user document by email
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userSnapshot.docs.isEmpty) {
        print("No user found with this email.");
        return; // No user found, return
      }

      // Get the document reference of the first (and ideally only) matched user
      DocumentSnapshot userDoc = userSnapshot.docs.first;

      // Get the favNotes array from the user document
      List<dynamic> favNotes = userDoc['favNotes'] ?? [];
      String noteId = widget.note["id"]; // Replace with the actual note ID

      // Remove the noteId from the favNotes array if it exists
      if (favNotes.contains(noteId)) {
        favNotes.remove(noteId);

        // Update the user's document with the modified favNotes array
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id) // Using the document ID
            .update({'favNotes': favNotes});

        // Update the state to reflect the change
        setState(() {
          isFavorite = false;
        });

        print('Note removed from favorites');
      }
    } catch (e) {
      print("Error removing note from favorites: $e");
    }
  }

  bool isFavorite = false;

  Future<void> checkIfNoteIsFavorite() async {
    try {
      // Get the current user's email
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is logged in");
        return; // No user logged in, return
      }

      String userEmail = user.email!;

      // Query Firestore to find the user document by email
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userSnapshot.docs.isEmpty) {
        print("No user found with this email.");
        return; // No user found, return
      }

      // Get the document reference of the first (and ideally only) matched user
      DocumentSnapshot userDoc = userSnapshot.docs.first;

      // Get the favNotes array from the user document
      List<dynamic> favNotes = userDoc['favNotes'] ?? [];

      // Assume `noteId` is the ID of the note you want to check
      String noteId = widget.note["id"]; // Replace with the actual note ID

      // Check if the noteId is in the favNotes array
      setState(() {
        isFavorite =
            favNotes.contains(noteId); // Store the result in the variable
      });
    } catch (e) {
      print("Error checking if note is in favorites: $e");
    }
  }

  Future<String> getUserFullName(String email) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        // Get the first matching document
        DocumentSnapshot userDoc = userSnapshot.docs.first;
        String firstName = userDoc['fname'] ?? '';
        String lastName = userDoc['lname'] ?? '';
        return '$firstName $lastName'.trim();
      } else {
        return 'User not found';
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return 'Error fetching user data';
    }
  }

  @override
  Widget build(BuildContext context) {
    String addedById = widget.note['addedBy'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(fontFamily: 'Poppins'),
        ), // Title for the page
        backgroundColor:
            const Color.fromARGB(255, 255, 255, 255), // AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Padding around the content
        child:
            // Center the whole column vertically
            SingleChildScrollView(
          child: Column(
            // Center items horizontally
            children: [
              // Displaying the Title - Centered horizontally
              Text(
                widget.note['title'],
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
                textAlign: TextAlign.center, // Center the title horizontally
              ),
              const SizedBox(height: 10),

              // Displaying the Subject - Centered horizontally
              Text(
                widget.note['subject'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center, // Center the subject horizontally
              ),
              const SizedBox(height: 20),

              // Displaying the Content - Left aligned
              Align(
                alignment:
                    Alignment.centerLeft, // Align the content to the left
                child: Text(
                  widget.note['content'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                    height: 1.5, // Line height to make text more readable
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Displaying the Content - Left aligned
              Align(
                alignment:
                    Alignment.centerLeft, // Align the content to the left
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align items to the left
                  children: [
                    // Label for "Added by"
                    Text(
                      "Added by",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(
                        height: 4), // Small space between label and value
                    // Value for "Added by"
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FutureBuilder<String>(
                        future: getUserFullName(addedById),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return const Text(
                              'Error loading user data',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Poppins',
                                color: Colors.red,
                              ),
                            );
                          } else {
                            String fullName = snapshot.data ?? 'Unknown User';
                            return Text(
                              fullName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Poppins',
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              !isFavorite
                  ? ElevatedButton(
                      onPressed: () {
                        String noteid = widget.note["id"];
                        addToFavorites(noteid);
                        setState(() {
                          isFavorite = true; // Update the UI immediately
                        });
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
                                child: Text(
                                  "Add to Favourits",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 25,
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
                                Icons.star,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        removeFromFavorites();
                        checkIfNoteIsFavorite();
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
                                child: Text(
                                  "Remove from Favourits",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 25,
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
                                Icons.star,
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
                onPressed: () {},
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
                            "Download PDF",
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
                          Icons.download,
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
    );
  }
}
