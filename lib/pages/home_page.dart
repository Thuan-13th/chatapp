import 'package:chatapp/components/my_drawer.dart';
import 'package:chatapp/components/user_tile.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).colorScheme.primary,
        title: _buildCurrentUserName(),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          _searchField(context),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  // Hiển thị tên người dùng hiện tại
  Widget _buildCurrentUserName() {
    return StreamBuilder<DocumentSnapshot>(
      stream: _authService.getCurrentUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error loading user data");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading user data...");
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text("User not found");
        }
        var userData = snapshot.data!.data() as Map<String, dynamic>;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                'Welcome, ${userData['username']}!',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Search bar
  Widget _searchField(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(15.0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search for users...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  // xây dựng danh sách người dùng ngoại trừ người dùng đã đăng nhập hiện tại
  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error!");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        var filteredUsers = snapshot.data!.where((userData) {
          var username = userData['username'] as String;
          return username.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        return ListView(
          children: filteredUsers
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // xây dựng ô danh sách cá nhân cho người dùng
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["username"],
        userID: userData["uid"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserName: userData["username"] ?? '',
                receiverEmail: userData["email"] ?? '',
                receiverID: userData["uid"] ?? '',
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
