import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Allusers extends StatefulWidget {
  const Allusers({super.key});

  @override
  State<Allusers> createState() => _AllusersState();
}

class _AllusersState extends State<Allusers> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  List<Map<String, dynamic>> sentRequests = [];

  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchSentRequests();
    fetchUserDetails();
  }

  User? currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData; // Variable to store user details

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

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserEmail = currentUser.email!;

        // Fetch the current user's document by matching the email field
        QuerySnapshot currentUserQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: currentUserEmail)
            .get();

        // Ensure the user document exists
        if (currentUserQuery.docs.isNotEmpty) {
          DocumentSnapshot currentUserDoc = currentUserQuery.docs.first;

          // Default to an empty list if friends array doesn't exist
          List<dynamic> friends =
              (currentUserDoc.data() as Map<String, dynamic>?)?['friends'] ??
                  [];

          // Fetch users who are not in the friends array and are not the current user
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('email', isNotEqualTo: currentUserEmail)
              .get();

          setState(() {
            users = querySnapshot.docs
                .where((doc) => !(friends.contains(doc['email'] ?? '')))
                .map((doc) {
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
      print('Error fetching users: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchSentRequests() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserEmail = currentUser.email!;

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('requests')
            .where('from', isEqualTo: currentUserEmail)
            .get();

        setState(() {
          sentRequests = querySnapshot.docs.map((doc) {
            return {'to': doc['to'] ?? '', 'id': doc.id};
          }).toList();
          isLoading = false;
        });
      } else {
        print("No user is logged in.");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching sent requests: $e');
      setState(() {
        isLoading = false;
      });
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

  void sendFriendRequest(Map<String, dynamic> user) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && user['email'] != null) {
      try {
        DocumentReference requestRef =
            await FirebaseFirestore.instance.collection('requests').add({
          'to': user['email'],
          'from': currentUser.email,
          'name': userData?['fname'] + ' ' + userData?['lname'],
          'timestamp': FieldValue.serverTimestamp(),
        });

        print("Friend request sent to ${user['email']}.");

        // Update sentRequests and refresh UI
        setState(() {
          sentRequests.add({'to': user['email'], 'id': requestRef.id});
        });
      } catch (e) {
        print("Error sending friend request: $e");
      }
    } else {
      print("Error: Current user or target email is null.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find Friends',
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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
         
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
                            labelText: 'Search For Friends',
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
                                    child: Text("No Matching Poples Found"),
                                  )
                                : buildContactList(filteredUsers))
                            : (users.isEmpty
                                ? const Center(child: Text("No People Yet"))
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
        bool isSentRequest = sentRequests.any((request) {
          return request['to'] == user['email'];
        });
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
          trailing: !isSentRequest
              ? GestureDetector(
                  child: const Icon(Icons.person_add_rounded),
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.scale,
                      title: 'Add Friend?',
                      desc:
                          'Are you sure you want to add this person as a friend?',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        sendFriendRequest(user);
                      },
                    ).show();
                  },
                )
              : GestureDetector(
                  child: const Icon(Icons.cancel),
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.scale,
                      title: 'Cancel Request?',
                      desc:
                          'Are you sure you want to cancel the Friend Request?',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        try {
                          String? requestToDelete;

                          for (var request in sentRequests) {
                            if (request['to'] == user["email"]) {
                              requestToDelete = request["id"];
                              break;
                            }
                          }

                          if (requestToDelete != null) {
                            await FirebaseFirestore.instance
                                .collection('requests')
                                .doc(requestToDelete)
                                .delete();

                            print(
                                "Request with ID $requestToDelete deleted successfully.");

                            setState(() {
                              sentRequests.removeWhere((request) =>
                                  request["id"] == requestToDelete);
                            });
                          } else {
                            print(
                                "No matching request found for user email: ${user["email"]}");
                          }
                        } catch (e) {
                          print("Error deleting request: $e");
                        }
                      },
                    ).show();
                  },
                ),
        );
      },
    );
  }
}
