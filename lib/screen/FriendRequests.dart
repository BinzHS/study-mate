import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendRequests extends StatefulWidget {
  const FriendRequests({super.key});

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> requests = [];
  List<Map<String, dynamic>> filteredRequests = [];
  bool isLoading = true;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fetchReceivedRequests();
  }

  Future<void> fetchReceivedRequests() async {
    try {
      if (currentUser != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('requests')
            .where('to', isEqualTo: currentUser!.email)
            .get();

        setState(() {
          requests = querySnapshot.docs.map((doc) {
            return {
              'to': doc['to'] ?? '',
              'id': doc.id,
              'from': doc['from'],
              'name': doc['name']
            };
          }).toList();
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error fetching requests');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void filterUsers(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredRequests = requests.where((req) {
        final name = req["name"].toLowerCase().trim();
        final email = (req['from'] ?? '').toLowerCase();
        return name.contains(lowerQuery) || email.contains(lowerQuery);
      }).toList();
    });
  }

  Future<void> acceptFriendRequest(Map<String, dynamic> request) async {
    try {
      await _updateFriendsList(request['from']);
      await _deleteRequest(request['id']);
      setState(() {
        requests.removeWhere((req) => req['id'] == request['id']);
        filteredRequests.removeWhere((req) => req['id'] == request['id']);
      });
      _showSuccessSnackBar('Friend request accepted');
    } catch (e) {
      _showErrorSnackBar('Error accepting request');
    }
  }

  Future<void> _updateFriendsList(String friendEmail) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    
    // Update current user's friends list
    final currentUserDoc = await usersCollection
        .where('email', isEqualTo: currentUser!.email)
        .get();
    if (currentUserDoc.docs.isNotEmpty) {
      List<String> currentUserFriends = List<String>.from(
          currentUserDoc.docs.first['friends'] ?? []);
      if (!currentUserFriends.contains(friendEmail)) {
        currentUserFriends.add(friendEmail);
        await currentUserDoc.docs.first.reference.update({
          'friends': currentUserFriends,
        });
      }
    }

    // Update friend's friends list
    final friendDoc = await usersCollection
        .where('email', isEqualTo: friendEmail)
        .get();
    if (friendDoc.docs.isNotEmpty) {
      List<String> friendFriends = List<String>.from(
          friendDoc.docs.first['friends'] ?? []);
      if (!friendFriends.contains(currentUser!.email)) {
        friendFriends.add(currentUser!.email!);
        await friendDoc.docs.first.reference.update({
          'friends': friendFriends,
        });
      }
    }
  }

  Future<void> _deleteRequest(String requestId) async {
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(requestId)
        .delete();
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
                  'Friend Requests',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
          hintText: 'Search requests...',
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
        child: _buildRequestsList(),
      ),
    );
  }

  Widget _buildRequestsList() {
    final displayRequests = searchController.text.isNotEmpty ? filteredRequests : requests;

    if (displayRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_disabled, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              searchController.text.isNotEmpty
                  ? 'No matching requests found'
                  : 'No friend requests',
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
      itemCount: displayRequests.length,
      itemBuilder: (context, index) => _buildRequestTile(displayRequests[index]),
    );
  }

  Widget _buildRequestTile(Map<String, dynamic> request) {
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
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFF1976D2),
          child: Text(
            request['name']?.substring(0, 1) ?? '',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(
          request['name'].trim(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          request['from'] ?? '',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: () => _showAcceptDialog(request),
            ),
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: () => _showRejectDialog(request),
            ),
          ],
        ),
      ),
    );
  }

  void _showAcceptDialog(Map<String, dynamic> request) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: 'Accept Request?',
      desc: 'Do you want to accept this friend request?',
      btnCancelOnPress: () {},
      btnOkOnPress: () => acceptFriendRequest(request),
    ).show();
  }

  void _showRejectDialog(Map<String, dynamic> request) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'Reject Request?',
      desc: 'Do you want to reject this friend request?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await _deleteRequest(request['id']);
        setState(() {
          requests.removeWhere((req) => req['id'] == request['id']);
          filteredRequests.removeWhere((req) => req['id'] == request['id']);
        });
        _showSuccessSnackBar('Friend request rejected');
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
