import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Addnote extends StatefulWidget {
  const Addnote({super.key});

  @override
  State<Addnote> createState() => _AddnoteState();
}

class _AddnoteState extends State<Addnote> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  String _selectedVisibility = 'Public';

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
      title: Text(
        'Add Note',
        style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInputField(
            controller: titleController,
            hint: "Title",
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: subjectController,
            hint: "Subject",
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: contentController,
            hint: "Note Content",
            maxLines: 8,
          ),
          const SizedBox(height: 24),
          _buildVisibilitySection(),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.poppins(fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildVisibilitySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Visibility",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildVisibilityOption('Public', Icons.public),
          _buildVisibilityOption('Private', Icons.lock),
          _buildVisibilityOption('Friends Only', Icons.group),
        ],
      ),
    );
  }

  Widget _buildVisibilityOption(String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1976D2)),
      title: Text(
        value,
        style: GoogleFonts.poppins(),
      ),
      trailing: Radio<String>(
        value: value,
        groupValue: _selectedVisibility,
        onChanged: (newValue) =>
            setState(() => _selectedVisibility = newValue!),
        activeColor: const Color(0xFF1976D2),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildButton(
          label: "Upload PDF",
          icon: Icons.picture_as_pdf,
          onPressed: () {
            // PDF upload functionality
          },
        ),
        const SizedBox(height: 16),
        _buildButton(
          label: "Add Note",
          icon: Icons.check,
          onPressed: _saveNote,
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1976D2),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: const Color(0xFF1976D2)),
        ],
      ),
    );
  }

  void _saveNote() async {
    try {
      final title = titleController.text.trim();
      final subject = subjectController.text.trim();
      final content = contentController.text.trim();
      final user = FirebaseAuth.instance.currentUser;

      if (title.isEmpty || subject.isEmpty || content.isEmpty) {
        _showErrorDialog('Please fill all fields');
        return;
      }

      if (user == null) {
        _showErrorDialog('User not authenticated');
        return;
      }

      await FirebaseFirestore.instance.collection('notes').add({
        'title': title,
        'subject': subject,
        'content': content,
        'visibility': _selectedVisibility,
        'addedBy': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _showSuccessDialog();
      _clearFields();
    } catch (e) {
      _showErrorDialog('Error saving note: $e');
    }
  }

  void _showSuccessDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'Success',
      desc: 'Note Added Successfully',
      btnOkColor: const Color(0xFF1976D2),
      btnOkOnPress: () => Navigator.pop(context),
    ).show();
  }

  void _showErrorDialog(String message) {
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

  void _clearFields() {
    titleController.clear();
    subjectController.clear();
    contentController.clear();
  }
}
