import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Friendrequests extends StatefulWidget {
  const Friendrequests({super.key});

  @override
  State<Friendrequests> createState() => _FriendrequestsState();
}

class _FriendrequestsState extends State<Friendrequests> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> requests = [];
  List<Map<String, dynamic>> filteredRequests = [];

  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchRecivedRequests();
  }

  Future<void> fetchRecivedRequests() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String currentUserEmail = currentUser.email!;

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('requests')
            .where('to', isEqualTo: currentUserEmail)
            .get();

        setState(() {
          requests = querySnapshot.docs.map((doc) {
            return {
              'to': doc['to'] ?? '',
              'id': doc.id,
              'from': doc['from'],
              'name': doc['name']
            };
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
      filteredRequests = requests.where((req) {
        final name = req["name"].toLowerCase().trim();
        final email = (req['from'] ?? '').toLowerCase();

        return name.contains(lowerQuery) || email.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Friend Requests',
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
                            labelText: 'Search Requests',
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
                            ? (filteredRequests.isEmpty
                                ? const Center(
                                    child: Text("No Matching Requests"),
                                  )
                                : buildContactList(filteredRequests))
                            : (requests.isEmpty
                                ? const Center(
                                    child: Text("No Friend Requests"))
                                : buildContactList(requests)),
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

Widget buildContactList(List<Map<String, dynamic>> requestList) {
  User? currentUser = FirebaseAuth.instance.currentUser;
  Future<void> acceptFriendRequest(String requestEmail) async {
    final currentUserEmail = currentUser?.email;
    if (currentUserEmail == null) {
      print("No user is signed in.");
      return;
    }

    try {
      // Reference to the users collection
      final usersCollection = FirebaseFirestore.instance.collection('users');

      // Fetch the current user's document
      final currentUserDoc = await usersCollection
          .where('email', isEqualTo: currentUserEmail)
          .get();
      if (currentUserDoc.docs.isEmpty) {
        print("Current user not found.");
        return;
      }
      final currentUserData = currentUserDoc.docs.first;

      // Fetch the requested user's document
      final requestedUserDoc =
          await usersCollection.where('email', isEqualTo: requestEmail).get();
      if (requestedUserDoc.docs.isEmpty) {
        print("Requested user not found.");
        return;
      }
      final requestedUserData = requestedUserDoc.docs.first;

      // Update the current user's friends array
      final currentUserFriends = List<String>.from(
          currentUserData.data().containsKey('friends')
              ? currentUserData['friends']
              : []);
      if (!currentUserFriends.contains(requestEmail)) {
        currentUserFriends.add(requestEmail);
        await usersCollection.doc(currentUserData.id).update({
          'friends': currentUserFriends,
        });
      }

      // Update the requested user's friends array
      final requestedUserFriends = List<String>.from(
          requestedUserData.data().containsKey('friends')
              ? requestedUserData['friends']
              : []);
      if (!requestedUserFriends.contains(currentUserEmail)) {
        requestedUserFriends.add(currentUserEmail);
        await usersCollection.doc(requestedUserData.id).update({
          'friends': requestedUserFriends,
        });
      }

      print("Friend request accepted and friends updated successfully.");
    } catch (e) {
      print("Error while accepting friend request: $e");
    }
  }

  return ListView.builder(
    itemCount: requestList.length,
    itemBuilder: (context, index) {
      final req = requestList[index];

      return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                req["name"].trim(),
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                req['from'] ?? '',
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
              (req['name']?.substring(0, 1) ?? ''),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          trailing: Column(
            children: [
              GestureDetector(
                child: const Icon(Icons.person_add_rounded),
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.question,
                    animType: AnimType.scale,
                    title: 'Acept Request?',
                    desc:
                        'Are you sure you want to Accept this Friend Request?',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      acceptFriendRequest(req['from']);
                      FirebaseFirestore.instance
                          .collection('requests')
                          .doc(req['id'])
                          .delete();
                    },
                  ).show();
                },
              ),
              GestureDetector(
                child: const Icon(Icons.cancel),
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.question,
                    animType: AnimType.scale,
                    title: 'Reject Request?',
                    desc:
                        'Are you sure you want to Delete this Friend Request?',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      await FirebaseFirestore.instance
                          .collection('requests')
                          .doc(req['id'])
                          .delete();
                    },
                  ).show();
                },
              ),
            ],
          ));
    },
  );
}
