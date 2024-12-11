import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymate/pages/Notes.dart';
import 'package:studymate/screen/MyNotes.dart';

class Addnote extends StatefulWidget {
  const Addnote({super.key});

  @override
  State<Addnote> createState() => _AddnoteState();
}

TextEditingController namecontroller = TextEditingController();
TextEditingController Contentcontroller = TextEditingController();
TextEditingController subjectController = TextEditingController();
String _selectedVisibility = 'Public'; // Default selected option

class _AddnoteState extends State<Addnote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add a Note',
          style: GoogleFonts.poppins(
            fontSize: 26, // Adjust size as needed
            fontWeight: FontWeight.bold, // Adjust weight as needed
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Suitable margins
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 10),
                  child: TextField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.7), // Label color
                        fontSize: 20.0, // Label font size
                        fontWeight: FontWeight.bold, // Label font weight
                      ),
                      hintText: "Title",
                      fillColor: Colors.white, // Background color
                      filled: true, // Enable the background color
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                  child: TextField(
                    controller: subjectController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.7), // Label color
                        fontSize: 20.0, // Label font size
                        fontWeight: FontWeight.bold, // Label font weight
                      ),
                      hintText: "Subject",
                      fillColor: Colors.white, // Background color
                      filled: true, // Enable the background color
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: Contentcontroller,
                    maxLines: 10, // Makes the TextField multiline
                    minLines: 5, // Initial height for the TextField
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.7), // Label color
                        fontSize: 20.0, // Label font size
                        fontWeight: FontWeight.bold, // Label font weight
                      ),
                      hintText: "Add Note Content",
                      fillColor: Colors.white, // Background color
                      filled: true, // Enable the background color
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Visibility",
                      style: GoogleFonts.poppins(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Public',
                        style: GoogleFonts.poppins(),
                      ),
                      leading: Radio<String>(
                        value: 'Public',
                        groupValue: _selectedVisibility,
                        onChanged: (value) {
                          setState(() {
                            _selectedVisibility = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Private',
                        style: GoogleFonts.poppins(),
                      ),
                      leading: Radio<String>(
                        value: 'Private',
                        groupValue: _selectedVisibility,
                        onChanged: (value) {
                          setState(() {
                            _selectedVisibility = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Friends Only',
                        style: GoogleFonts.poppins(),
                      ),
                      leading: Radio<String>(
                        value: 'Friends Only',
                        groupValue: _selectedVisibility,
                        onChanged: (value) {
                          setState(() {
                            _selectedVisibility = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    // Text(
                    //   'Selected: $_selectedVisibility',
                    //   style: GoogleFonts.poppins(
                    //     fontSize: 16.0,
                    //     fontStyle: FontStyle.italic,
                    //   ),
                    // ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    print("Pressed");
                    // Your existing functionality here
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
                                child: Text("Upload PDF",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF104D6C),
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
                            Icons.picture_as_pdf,
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
                    try {
                      String title = namecontroller.text.trim();
                      String subject = subjectController.text.trim();
                      String content = Contentcontroller.text;
                      String visibility = _selectedVisibility;
                      User? user = FirebaseAuth.instance.currentUser;
                      print(user);
                      String uid = user!.uid;
                      String email = user.email!;
                      if (title.isNotEmpty &&
                          subject.isNotEmpty &&
                          visibility.isNotEmpty) {
                        FirebaseFirestore.instance.collection('notes').add({
                          'title': title,
                          'subject': subject,
                          'content': content,
                          'visibility': visibility,
                          'addedBy': email,
                        }).then((value) {
                          namecontroller.clear();
                          subjectController.clear();
                          Contentcontroller.clear();

                          AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.scale,
                              title: 'Success',
                              desc: 'Note Added Successfully',
                              btnOkOnPress: () {
                                namecontroller.clear();
                                subjectController.clear();
                                Contentcontroller.clear();
                              }).show();
                        });
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.noHeader,
                          animType: AnimType.topSlide,
                          title: 'Error',
                          desc: 'Please fill all the fields',
                          btnOkOnPress: () {
                            namecontroller.clear();
                            subjectController.clear();
                            Contentcontroller.clear();
                          },
                          customHeader: const Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 80,
                          ),
                        ).show();
                      }
                    } catch (e) {
                      print(e);
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
                                child: Text("Add Note",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF104D6C),
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
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
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
                                child: Text("Back",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF104D6C),
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
                            Icons.arrow_back_ios_new_outlined,
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
      ),
    );
  }
}
