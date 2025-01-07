import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/screen/AllNotes.dart';
import 'package:studymate/screen/FavNotes.dart';
import 'package:studymate/screen/MyNotes.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF1976D2),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF2196F3),
        ),
      ),
      home: const Notes(),
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
  int currentIndex = 1;

  final screens = [
    const AllNotes(),
    const FavNotes(),
    const MyNotes(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE3F2FD),
            Color(0xFFBBDEFB),
            Color(0xFF90CAF9),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: screens[currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            onTap: (value) => setState(() => currentIndex = value),
            iconSize: 28,
            selectedFontSize: 16,
            unselectedFontSize: 14,
            currentIndex: currentIndex,
            backgroundColor: const Color(0xFF1976D2),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            elevation: 8,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_sharp),
                activeIcon: Icon(Icons.menu_book_sharp, size: 32),
                label: "All Notes",
                backgroundColor: Color(0xFF1976D2),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                activeIcon: Icon(Icons.star, size: 32),
                label: "Favourites",
                backgroundColor: Color(0xFF1976D2),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                activeIcon: Icon(Icons.book, size: 32),
                label: "My Notes",
                backgroundColor: Color(0xFF1976D2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
