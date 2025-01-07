import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyFriends extends StatefulWidget {
  const MyFriends({super.key});

  @override
  State<MyFriends> createState() => _MyFriendsState();
}

class _MyFriendsState extends State<MyFriends>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool isLoading = true;
  User? currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      fetchFriends(),
      fetchUserDetails(),
    ]);
  }

  Future<void> fetchUserDetails() async {
    if (currentUser != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: currentUser!.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            userData = querySnapshot.docs.first.data() as Map<String, dynamic>?;
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } catch (e) {
        setState(() => isLoading = false);
        _showErrorSnackBar('Error fetching user details');
      }
    }
  }

  Future<void> fetchFriends() async {
    try {
      if (currentUser != null) {
        String currentUserEmail = currentUser!.email!;
        QuerySnapshot currentUserQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: currentUserEmail)
            .get();

        if (currentUserQuery.docs.isNotEmpty) {
          DocumentSnapshot currentUserDoc = currentUserQuery.docs.first;
          List<dynamic> friends =
              (currentUserDoc.data() as Map<String, dynamic>)['friends'] ?? [];

          if (friends.isNotEmpty) {
            QuerySnapshot friendsQuery = await FirebaseFirestore.instance
                .collection('users')
                .where('email', whereIn: friends)
                .get();

            setState(() {
              users = friendsQuery.docs.map((doc) {
                return {
                  'id': doc.id,
                  'fname': doc['fname'] ?? '',
                  'lname': doc['lname'] ?? '',
                  'email': doc['email'] ?? '',
                };
              }).toList();
            });
          }
        }
      }
    } catch (e) {
      _showErrorSnackBar('Error fetching friends');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void filterUsers(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredUsers = users.where((user) {
        final fullName =
            "${user['fname']} ${user['lname']}".toLowerCase().trim();
        final email = (user['email'] ?? '').toLowerCase();
        return fullName.contains(lowerQuery) || email.contains(lowerQuery);
      }).toList();
    });
  }

  Future<void> removeFriend(Map<String, dynamic> user) async {
    try {
      String currentUserEmail = currentUser!.email!;

      // Remove from current user's friends list
      var currentUserQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUserEmail)
          .get();

      if (currentUserQuery.docs.isNotEmpty) {
        DocumentSnapshot currentUserDoc = currentUserQuery.docs.first;
        List<dynamic> currentUserFriends =
            (currentUserDoc.data() as Map<String, dynamic>)['friends'] ?? [];
        currentUserFriends.remove(user['email']);
        await currentUserDoc.reference.update({'friends': currentUserFriends});
      }

      // Remove from friend's friends list
      var friendQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user['email'])
          .get();

      if (friendQuery.docs.isNotEmpty) {
        DocumentSnapshot friendDoc = friendQuery.docs.first;
        List<dynamic> friendFriends =
            (friendDoc.data() as Map<String, dynamic>)['friends'] ?? [];
        friendFriends.remove(currentUserEmail);
        await friendDoc.reference.update({'friends': friendFriends});
      }

      setState(() {
        users.removeWhere((u) => u['email'] == user['email']);
        filteredUsers.removeWhere((u) => u['email'] == user['email']);
      });

      _showSuccessSnackBar('Friend removed successfully');
    } catch (e) {
      _showErrorSnackBar('Error removing friend');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: const Color(0xFF1976D2),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF64B5F6),
        ),
      ),
      child: Scaffold(
        body: Container(
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
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  'My Friends',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  userData?['fname']?.substring(0, 1).toUpperCase() ?? 'U',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF1976D2),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: filterUsers,
        decoration: InputDecoration(
          hintText: 'Search friends...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF1976D2)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: _buildFriendsList(),
      ),
    );
  }

  Widget _buildFriendsList() {
    final displayUsers =
        searchController.text.isNotEmpty ? filteredUsers : users;

    if (displayUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              searchController.text.isNotEmpty
                  ? 'No matching friends found'
                  : 'No friends yet',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: displayUsers.length,
      itemBuilder: (context, index) => _buildFriendTile(displayUsers[index]),
    );
  }

  Widget _buildFriendTile(Map<String, dynamic> user) {
    final initials = (user['fname']?.substring(0, 1) ?? '') +
        (user['lname']?.substring(0, 1) ?? '');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Hero(
          tag: user['email'] ?? '',
          child: CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFF1976D2),
            child: Text(
              initials,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        title: Text(
          "${user['fname']} ${user['lname']}".trim(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          user['email'] ?? '',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.person_remove_rounded, color: Colors.red),
          onPressed: () => _showRemoveFriendDialog(user),
        ),
      ),
    );
  }

  void _showRemoveFriendDialog(Map<String, dynamic> user) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'Remove Friend',
      desc:
          'Are you sure you want to remove ${user['fname']} from your friends list?',
      btnCancelOnPress: () {},
      btnOkOnPress: () => removeFriend(user),
    ).show();
  }

  @override
  void dispose() {
    _animationController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
