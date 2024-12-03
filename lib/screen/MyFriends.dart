import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Myfriends extends StatefulWidget {
  const Myfriends({super.key});

  @override
  State<Myfriends> createState() => _MyfriendsState();
}

class _MyfriendsState extends State<Myfriends> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFriends();

    fetchUserDetails();
  }

  User? currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData; // Variable to store user details

  Future<void> fetchFriends() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserEmail = currentUser.email!;

        // Fetch the current user's document by email
        QuerySnapshot currentUserQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: currentUserEmail)
            .get();

        // Ensure the user document exists
        if (currentUserQuery.docs.isNotEmpty) {
          DocumentSnapshot currentUserDoc = currentUserQuery.docs.first;

          // Retrieve the friends array, default to an empty list if not available
          List<dynamic> friends =
              (currentUserDoc.data() as Map<String, dynamic>)['friends'] ?? [];

          if (friends.isNotEmpty) {
            // Fetch users whose email is in the friends array
            QuerySnapshot friendsQuery = await FirebaseFirestore.instance
                .collection('users')
                .where('email', whereIn: friends)
                .get();

            setState(() {
              users = friendsQuery.docs.map((doc) {
                return {
                  'id': doc.id,
                  'fname': doc['fname'] ?? '',
                  'lname': doc['lname'] ?? '',
                  'email': doc['email'] ?? '',
                };
              }).toList();
              isLoading = false;
            });
          } else {
            print("No friends found in the current user's friends array.");
            setState(() {
              users = [];
              isLoading = false;
            });
          }
        } else {
          print("Current user document not found.");
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("No user is logged in.");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching friends: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserDetails() async {
    if (currentUser != null) {
      try {
        // Fetch user document from Firestore where the document ID matches the user's UID
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: currentUser!.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = querySnapshot.docs.first;

          setState(() {
            userData = userDoc.data() as Map<String,
                dynamic>?; // Store user data in userData variable

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

  void filterUsers(String query) {
    final lowerQuery = query.toLowerCase();

    setState(() {
      filteredUsers = users.where((user) {
        final fullName =
            "${user['fname']} ${user['lname']}".toLowerCase().trim();
        final email = (user['email'] ?? '').toLowerCase();

        return fullName.contains(lowerQuery) || email.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Friends',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Centers the title text
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
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
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: TextField(
                          controller: searchController,
                          onChanged: filterUsers,
                          decoration: InputDecoration(
                            labelText: 'Search Friends',
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: searchController.text.isNotEmpty
                            ? (filteredUsers.isEmpty
                                ? const Center(
                                    child: Text("No Matching Friends"),
                                  )
                                : buildContactList(filteredUsers))
                            : (users.isEmpty
                                ? const Center(child: Text("No Friends Yet"))
                                : buildContactList(users)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildContactList(List<Map<String, dynamic>> userList) {
  return ListView.builder(
    itemCount: userList.length,
    itemBuilder: (context, index) {
      final user = userList[index];

      return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${user['fname']} ${user['lname']}".trim(),
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user['email'] ?? '',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.black,
            child: Text(
              (user['fname']?.substring(0, 1) ?? '') +
                  (user['lname']?.substring(0, 1) ?? ''),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          trailing: GestureDetector(
            child: const Icon(Icons.highlight_remove_sharp),
            onTap: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.question,
                animType: AnimType.scale,
                title: 'Remove Friend?',
                desc:
                    'Are you sure you want to remove this person as a friend?',
                btnCancelOnPress: () {},
                btnOkOnPress: () {
// Get the current user's email
                  String currentUserEmail =
                      FirebaseAuth.instance.currentUser!.email!;

                  // Get the current user's document
                  FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isEqualTo: currentUserEmail)
                      .get()
                      .then((querySnapshot) {
                    if (querySnapshot.docs.isNotEmpty) {
                      DocumentSnapshot currentUserDoc =
                          querySnapshot.docs.first;

                      // Get the current user's friends array
                      List<dynamic> friends = (currentUserDoc.data()
                              as Map<String, dynamic>)['friends'] ??
                          [];

                      // Remove the friend's email from the friends array
                      friends.remove(user['email']);

                      // Update the current user's friends array
                      currentUserDoc.reference
                          .update({'friends': friends}).then((value) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.bottomSlide,
                          title: 'Friend Removed',
                          desc:
                              'You have successfully removed ${user['fname']} ${user['lname']} as a friend.',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {},
                        ).show();
                      }).catchError((error) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.bottomSlide,
                          title: 'Error',
                          desc:
                              'An error occurred while removing the friend. Please try again.',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {},
                        ).show();
                      });
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.bottomSlide,
                        title: 'Error',
                        desc:
                            'An error occurred while removing the friend. Please try again.',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                    }
                  }).catchError((error) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.bottomSlide,
                      title: 'Error',
                      desc:
                          'An error occurred while removing the friend. Please try again.',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    ).show();
                  });
                },
              ).show();
            },
          ));
    },
  );
}
