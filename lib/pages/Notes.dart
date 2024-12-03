import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/screen/AllNotes.dart';
import 'package:studymate/screen/FavNotes.dart';
import 'package:studymate/screen/MyNotes.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Notes(),
    );
  }
}

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  int currentIndex = 1;
  final screens = [
    const AllNotes(),
    const FavNotes(),
    const MyNotes(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => setState(() {
            currentIndex = value; // Update the selected screen
          }),
          iconSize: 30,
          selectedFontSize: 20,
          currentIndex: currentIndex,
          backgroundColor: Colors.grey.withOpacity(0.3),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_sharp),
              label: "All Notes",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: "Favourites",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: "My Notes",
            ),
          ],
        ));
  }
}
