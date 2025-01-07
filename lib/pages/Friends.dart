import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/screen/AllUsers.dart';
import 'package:studymate/screen/FriendRequests.dart';
import 'package:studymate/screen/MyFriends.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF1976D2),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF2196F3),
        ),
      ),
      home: const Friends(),
    );
  }
}

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final user = FirebaseAuth.instance.currentUser;
  int currentIndex = 1;

  final screens = [
    const AllUsers(),
    const MyFriends(),
    const FriendRequests(),
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
                icon: Icon(Icons.search),
                activeIcon: Icon(Icons.search, size: 32),
                label: "Find Friends",
                backgroundColor: Color(0xFF1976D2),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                activeIcon: Icon(Icons.person, size: 32),
                label: "My Friends",
                backgroundColor: Color(0xFF1976D2),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notification_add),
                activeIcon: Icon(Icons.notification_add, size: 32),
                label: "Requests",
                backgroundColor: Color(0xFF1976D2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
