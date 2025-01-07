import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewNote extends StatefulWidget {
  final Map<String, dynamic> note;
  const ViewNote({super.key, required this.note});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfNoteIsFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF90CAF9),
            Color(0xFF64B5F6),
            Color(0xFF42A5F5),
            Color(0xFF2196F3),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
          ),
          onPressed: () => _toggleFavorite(),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildContent(),
            const SizedBox(height: 24),
            _buildAuthorInfo(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.note['title'],
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1976D2),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.note['subject'],
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Text(
      widget.note['content'],
      style: GoogleFonts.poppins(
        fontSize: 16,
        height: 1.6,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildAuthorInfo() {
    return FutureBuilder<String>(
      future: getUserFullName(widget.note['addedBy']),
      builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.person, color: Color(0xFF1976D2)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Added by',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    snapshot.data ?? 'Loading...',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          title: isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
          icon: Icons.favorite,
          onPressed: _toggleFavorite,
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          title: 'Download PDF',
          icon: Icons.download,
          onPressed: () {
            // PDF download functionality
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1976D2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: Colors.white),
        ],
      ),
    );
  }

  void _toggleFavorite() {
    if (isFavorite) {
      removeFromFavorites();
    } else {
      addToFavorites(widget.note['id']);
    }
  }

  Future<void> addToFavorites(String noteId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String userEmail = user.email!;
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userSnapshot.docs.isEmpty) return;

      DocumentReference userDocRef = userSnapshot.docs.first.reference;
      await userDocRef.update({
        'favNotes': FieldValue.arrayUnion([noteId]),
      });

      setState(() {
        isFavorite = true;
      });
    } catch (e) {
      debugPrint("Error adding note to favorites: $e");
    }
  }

  Future<void> removeFromFavorites() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String userEmail = user.email!;
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userSnapshot.docs.isEmpty) return;

      DocumentSnapshot userDoc = userSnapshot.docs.first;
      List<dynamic> favNotes = userDoc['favNotes'] ?? [];
      String noteId = widget.note["id"];

      if (favNotes.contains(noteId)) {
        favNotes.remove(noteId);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .update({'favNotes': favNotes});

        setState(() {
          isFavorite = false;
        });
      }
    } catch (e) {
      debugPrint("Error removing note from favorites: $e");
    }
  }

  Future<void> checkIfNoteIsFavorite() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String userEmail = user.email!;
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userSnapshot.docs.isEmpty) return;

      DocumentSnapshot userDoc = userSnapshot.docs.first;
      List<dynamic> favNotes = userDoc['favNotes'] ?? [];
      String noteId = widget.note["id"];

      setState(() {
        isFavorite = favNotes.contains(noteId);
      });
    } catch (e) {
      debugPrint("Error checking if note is in favorites: $e");
    }
  }

  Future<String> getUserFullName(String email) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;
        String firstName = userDoc['fname'] ?? '';
        String lastName = userDoc['lname'] ?? '';
        return '$firstName $lastName'.trim();
      }
      return 'Unknown User';
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      return 'Error fetching user data';
    }
  }
}
