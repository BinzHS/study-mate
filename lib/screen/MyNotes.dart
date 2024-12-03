import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymate/pages/AddNote.dart';
import 'package:studymate/pages/EditNote.dart';

class MyNotes extends StatefulWidget {
  const MyNotes({super.key});

  @override
  State<MyNotes> createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  List<Map<String, dynamic>> notes = [];
  List<Map<String, dynamic>> filteredNotes = [];
  TextEditingController searchController =
      TextEditingController(); // Controller for search input
  bool isLoading = true; // Variable to indicate if data is still loading

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    setState(() {
      isLoading = true; // Set loading to true when fetching starts
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.email!;

        FirebaseFirestore.instance
            .collection('notes')
            .where('addedBy', isEqualTo: uid)
            .get()
            .then((QuerySnapshot querySnapshot) {
          setState(() {
            notes.clear();
            for (var doc in querySnapshot.docs) {
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
        });
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
          'My Notes',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
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
              if (isLoading) // Show loading indicator while loading
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Addnote()),
                            );
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
                                      "Add Note",
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
                                    Icons.add,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
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
                  child: const Icon(Icons.edit),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditNote(note: note),
                      ),
                    );
                    if (result == true) {
                      fetchNotes();
                    }
                  },
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  child: const Icon(Icons.delete),
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.scale,
                      title: 'Delete Contact',
                      desc: 'Are you sure you want to delete this contact?',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        FirebaseFirestore.instance
                            .collection('notes')
                            .doc(note['id'])
                            .delete()
                            .then((value) {
                          fetchNotes();
                        });
                      },
                    ).show();
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
