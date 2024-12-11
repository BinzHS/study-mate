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
      if (currentUser != null) {
        String currentUserEmail = currentUser!.email!;

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
            setState(() {
              users = [];
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserDetails() async {
    if (currentUser != null) {
      try {
        // Fetch user document from Firestore
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: currentUser!.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = querySnapshot.docs.first;

          setState(() {
            userData = userDoc.data() as Map<String, dynamic>?;
            isLoading = false; // Stop loading once data is fetched
          });
        } else {
          setState(() {
            isLoading = false; // Stop loading if user document is not found
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false;
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

  Future<void> removeFriend(Map<String, dynamic> user) async {
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

    try {
      // Remove from the current user's friends list
      var currentUserQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUserEmail)
          .get();

      if (currentUserQuery.docs.isNotEmpty) {
        DocumentSnapshot currentUserDoc = currentUserQuery.docs.first;
        List<dynamic> currentUserFriends =
            (currentUserDoc.data() as Map<String, dynamic>)['friends'] ?? [];
        currentUserFriends.remove(user['email']);

        await currentUserDoc.reference.update({
          'friends': currentUserFriends,
        });
      }

      // Remove from the friend's friends list
      var friendQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user['email'])
          .get();

      if (friendQuery.docs.isNotEmpty) {
        DocumentSnapshot friendDoc = friendQuery.docs.first;
        List<dynamic> friendFriends =
            (friendDoc.data() as Map<String, dynamic>)['friends'] ?? [];
        friendFriends.remove(currentUserEmail);

        await friendDoc.reference.update({
          'friends': friendFriends,
        });
      }

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Friend Removed',
        desc:
            'You have successfully removed ${user['fname']} ${user['lname']} as a friend.',
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          fetchFriends(); // Refresh the friend list
        },
      ).show();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Error',
        desc: 'An error occurred while removing the friend. Please try again.',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Friends',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF104D6C),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Image.asset(
              'assets/appbar_logo.png',
              height: 70,
              width: 70,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Expanded(
                  child: Column(
                    children: [
                      TextField(
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
                        ),
                      ),
                      Expanded(
                        child: searchController.text.isNotEmpty
                            ? (filteredUsers.isEmpty
                                ? const Center(
                                    child: Text("No Matching Friends"))
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
            onTap: () => removeFriend(user),
          ),
        );
      },
    );
  }
}
