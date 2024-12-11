import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditNote extends StatefulWidget {
  final Map<String, dynamic> note;

  const EditNote({super.key, required this.note});

  @override
  State<EditNote> createState() => _EditNoteState();
}

TextEditingController namecontroller = TextEditingController();
TextEditingController contentcontroller = TextEditingController();
TextEditingController subjectController = TextEditingController();
String _selectedVisibility = 'Public'; // Default selected option

class _EditNoteState extends State<EditNote> {
  @override
  void initState() {
    super.initState();
    namecontroller.text = widget.note['title'];
    contentcontroller.text = widget.note['content'];
    subjectController.text = widget.note['subject'];
    _selectedVisibility = widget.note['visibility'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Note',
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
         
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: "Title",
                      fillColor: Colors.white,
                      filled: true,
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
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: "Subject",
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: contentcontroller,
                    maxLines: 10,
                    minLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: "Edit Note Content",
                      fillColor: Colors.white,
                      filled: true,
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
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      String title = namecontroller.text.trim();
                      String subject = subjectController.text.trim();
                      String content = contentcontroller.text;
                      String visibility = _selectedVisibility;
                      User? user = FirebaseAuth.instance.currentUser;
                      String email = user!.email!;
                      if (title.isNotEmpty &&
                          subject.isNotEmpty &&
                          visibility.isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection('notes')
                            .doc(widget.note['id'])
                            .update({
                          'title': title,
                          'subject': subject,
                          'content': content,
                          'visibility': visibility,
                          'addedBy': email,
                        }).then((value) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.scale,
                            title: 'Success',
                            desc: 'Note Updated Successfully',
                            btnOkOnPress: () {
                              Navigator.pop(context);
                            },
                          ).show();
                        });
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.noHeader,
                          animType: AnimType.topSlide,
                          title: 'Error',
                          desc: 'Please fill all the fields',
                          btnOkOnPress: () {},
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
                                child: Text("Save Changes",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
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
                            Icons.save,
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
      ),
    );
  }
}
