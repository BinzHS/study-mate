import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymate/pages/AddNote.dart';
import 'package:studymate/pages/ViewNote.dart';

class FavNotes extends StatefulWidget {
  const FavNotes({super.key});

  @override
  State<FavNotes> createState() => _FavNotesState();
}

class _FavNotesState extends State<FavNotes> {
  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  List<Map<String, dynamic>> notes = [];
  List<Map<String, dynamic>> filteredNotes = [];
  TextEditingController searchController =
      TextEditingController(); // Controller for search input
  bool isLoading = true; // Variable to indicate if data is still loading

  Future<void> fetchNotes() async {
    setState(() {
      isLoading = true; // Set loading to true when fetching starts
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userEmail = user.email!; // Get the logged-in user's email

        // Fetch the user's document from the 'users' collection using email
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          // Get the first user document (in case there's only one document per email)
          DocumentSnapshot userDoc = userSnapshot.docs.first;

          // Get the 'favNotes' array from the user's document
          List<dynamic> favNotes = userDoc['favNotes'] ?? [];

          if (favNotes.isNotEmpty) {
            // Now, fetch notes that are in the 'favNotes' array
            QuerySnapshot notesSnapshot = await FirebaseFirestore.instance
                .collection('notes')
                .where(FieldPath.documentId,
                    whereIn:
                        favNotes) // Query for notes where the document ID is in the 'favNotes' array
                .get();

            setState(() {
              notes.clear();
              for (var doc in notesSnapshot.docs) {
                notes.add({
                  'id': doc.id,
                  'title': doc['title'],
                  'subject': doc['subject'],
                  'content': doc['content'],
                  'addedBy': doc['addedBy'],
                  'visibility': doc['visibility'],
                });
              }
              isLoading = false;
            });
          } else {
            // If the 'favNotes' array is empty, set isLoading to false and return
            setState(() {
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

  void filterNotes(String query) {
    List<Map<String, dynamic>> filtered = notes.where((note) {
      final title = note['title'].toLowerCase();
      final subject = note['subject'].toLowerCase();
      final content = note['content'].toLowerCase();
      final searchQuery = query.toLowerCase();

      // Check if the query matches the title, subject, or content
      return title.contains(searchQuery) ||
          subject.contains(searchQuery) ||
          content.contains(searchQuery);
    }).toList();

    setState(() {
      filteredNotes = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favourite Notes',
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) // Show loading indicator while loading
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                filterNotes(value);
                              },
                              decoration: InputDecoration(
                                labelText: 'Search Notes',
                                labelStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors
                                          .black), // Border color set to black
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors
                                          .black), // Black border when enabled
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.black,
                                      width:
                                          2), // Thicker black border on focus
                                ),
                              ),
                            ),
                          )),
                      if (searchController.text.isNotEmpty)
                        Expanded(
                          child: filteredNotes.isEmpty
                              ? const Center(
                                  child: Text("No Matching Notes"),
                                )
                              : buildNotesList(filteredNotes),
                        )
                      else
                        Expanded(
                          child: notes.isEmpty
                              ? const Center(
                                  child: Text("No Notes Available"),
                                )
                              : buildNotesList(notes),
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

  Widget buildNotesList(List<Map<String, dynamic>> notesList) {
    return ListView.builder(
      itemCount: notesList.length,
      itemBuilder: (context, index) {
        final note = notesList[index];
        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(note['title'],
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  )),
              Text(note['subject'],
                  style: GoogleFonts.poppins(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          leading: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 0, 0, 0),
            child: Text(note['title'][0],
                style: GoogleFonts.poppins(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                )),
          ),
          trailing: SizedBox(
            width: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  child: const Icon(Icons.open_in_new),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Viewnote(note: note),
                      ),
                    );
                    if (result == true) {
                      fetchNotes();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
