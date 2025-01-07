import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  List<Map<String, dynamic>> sentRequests = [];
  Map<String, dynamic>? userData;
  bool isLoading = true;
  User? currentUser = FirebaseAuth.instance.currentUser;

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
      fetchUsers(),
      fetchSentRequests(),
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
      }
    }
  }

  Future<void> fetchUsers() async {
    setState(() => isLoading = true);

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
              (currentUserDoc.data() as Map<String, dynamic>?)?['friends'] ??
                  [];

          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('email', isNotEqualTo: currentUserEmail)
              .get();

          setState(() {
            users = querySnapshot.docs
                .where((doc) => !(friends.contains(doc['email'] ?? '')))
                .map((doc) {
              return {
                'id': doc.id,
                'fname': doc['fname'] ?? '',
                'lname': doc['lname'] ?? '',
                'email': doc['email'] ?? '',
              };
            }).toList();
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchSentRequests() async {
    try {
      if (currentUser != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('requests')
            .where('from', isEqualTo: currentUser!.email)
            .get();

        setState(() {
          sentRequests = querySnapshot.docs.map((doc) {
            return {'to': doc['to'] ?? '', 'id': doc.id};
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('Error fetching sent requests: $e');
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

  Future<void> sendFriendRequest(Map<String, dynamic> user) async {
    if (currentUser != null && user['email'] != null) {
      try {
        DocumentReference requestRef =
            await FirebaseFirestore.instance.collection('requests').add({
          'to': user['email'],
          'from': currentUser!.email,
          'name': '${userData?['fname']} ${userData?['lname']}',
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          sentRequests.add({'to': user['email'], 'id': requestRef.id});
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Friend request sent to ${user['fname']}'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send friend request'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _cancelRequest(Map<String, dynamic> user) async {
    try {
      String? requestToDelete;
      for (var request in sentRequests) {
        if (request['to'] == user['email']) {
          requestToDelete = request['id'];
          break;
        }
      }

      if (requestToDelete != null) {
        await FirebaseFirestore.instance
            .collection('requests')
            .doc(requestToDelete)
            .delete();

        setState(() {
          sentRequests
              .removeWhere((request) => request['id'] == requestToDelete);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Friend request cancelled'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to cancel request'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                  'Find Friends',
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
          hintText: 'Search for friends...',
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
        child: _buildUserList(),
      ),
    );
  }

  Widget _buildUserList() {
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
                  ? 'No matching people found'
                  : 'No people available',
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
      padding: const EdgeInsets.only(top: 8),
      itemCount: displayUsers.length,
      itemBuilder: (context, index) => _buildUserTile(displayUsers[index]),
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user) {
    final isSentRequest =
        sentRequests.any((request) => request['to'] == user['email']);
    final initials = (user['fname']?.substring(0, 1) ?? '') +
        (user['lname']?.substring(0, 1) ?? '');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1976D2),
          child: Text(
            initials,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          "${user['fname']} ${user['lname']}".trim(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          user['email'] ?? '',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: _buildActionButton(user, isSentRequest),
      ),
    );
  }

  Widget _buildActionButton(Map<String, dynamic> user, bool isSentRequest) {
    return ElevatedButton(
      onPressed: () => _handleUserAction(user, isSentRequest),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSentRequest ? Colors.grey[300] : const Color(0xFF1976D2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        isSentRequest ? 'Cancel' : 'Add Friend',
        style: GoogleFonts.poppins(
          color: isSentRequest ? Colors.black54 : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _handleUserAction(Map<String, dynamic> user, bool isSentRequest) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: isSentRequest ? 'Cancel Request?' : 'Add Friend?',
      desc: isSentRequest
          ? 'Are you sure you want to cancel the friend request?'
          : 'Are you sure you want to add this person as a friend?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        if (isSentRequest) {
          _cancelRequest(user);
        } else {
          sendFriendRequest(user);
        }
      },
    ).show();
  }

  @override
  void dispose() {
    _animationController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
