import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymate/pages/ViewNote.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({super.key});

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  List<Map<String, dynamic>> notes = [];
  List<Map<String, dynamic>> filteredNotes = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    setState(() => isLoading = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String currentUserEmail = user.email!;
        QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: currentUserEmail)
            .get();

        if (userQuerySnapshot.docs.isNotEmpty) {
          Map<String, dynamic>? userData =
              userQuerySnapshot.docs.first.data() as Map<String, dynamic>?;
          List<dynamic> friends = userData?['friends'] ?? [];

          QuerySnapshot notesQuerySnapshot = await FirebaseFirestore.instance
              .collection('notes')
              .where('visibility', whereIn: ['Public', 'Friends Only']).get();

          setState(() {
            notes = notesQuerySnapshot.docs
                .map((doc) => {
                      'id': doc.id,
                      'title': doc['title'],
                      'subject': doc['subject'],
                      'content': doc['content'],
                      'addedBy': doc['addedBy'],
                      'visibility': doc['visibility'],
                    })
                .where((note) =>
                    note['visibility'] == 'Public' ||
                    (note['visibility'] == 'Friends Only' &&
                        friends.contains(note['addedBy'])))
                .toList();
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      showErrorDialog('Error loading notes. Please try again.');
    }
  }

  void filterNotes(String query) {
    setState(() {
      filteredNotes = notes.where((note) {
        final searchLower = query.toLowerCase();
        return note['title'].toLowerCase().contains(searchLower) ||
            note['subject'].toLowerCase().contains(searchLower) ||
            note['content'].toLowerCase().contains(searchLower);
      }).toList();
    });
  }

  void showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: 'Error',
      desc: message,
      btnOkColor: const Color(0xFF1976D2),
      btnOkOnPress: () {},
    ).show();
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
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'Study Notes',
        style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.black),
          onPressed: fetchNotes,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 20),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black))
                : _buildNotesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        controller: searchController,
        onChanged: filterNotes,
        style: GoogleFonts.poppins(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Search notes...',
          hintStyle: GoogleFonts.poppins(color: Colors.black54),
          prefixIcon: const Icon(Icons.search, color: Colors.black54),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    final displayNotes =
        searchController.text.isNotEmpty ? filteredNotes : notes;

    if (displayNotes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_alt_outlined,
                size: 80, color: Colors.black.withOpacity(0.7)),
            const SizedBox(height: 16),
            Text(
              searchController.text.isNotEmpty
                  ? 'No matching notes found'
                  : 'No notes available',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: displayNotes.length,
      itemBuilder: (context, index) => _buildNoteCard(displayNotes[index]),
    );
  }

  Widget _buildNoteCard(Map<String, dynamic> note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Hero(
          tag: 'note_avatar_${note['id']}',
          child: CircleAvatar(
            backgroundColor: const Color(0xFF1976D2),
            child: Text(
              note['title'][0].toUpperCase(),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          note['title'],
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              note['subject'],
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  note['visibility'] == 'Public'
                      ? Icons.public
                      : Icons.group_outlined,
                  size: 16,
                  color: Colors.black54,
                ),
                const SizedBox(width: 4),
                Text(
                  note['visibility'],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
          onPressed: () => _viewNote(note),
        ),
        onTap: () => _viewNote(note),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: fetchNotes,
      backgroundColor: Colors.white,
      child: const Icon(Icons.refresh, color: Color(0xFF1976D2)),
    );
  }

  void _viewNote(Map<String, dynamic> note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewNote(note: note),
      ),
    ).then((result) {
      if (result == true) fetchNotes();
    });
  }
}
