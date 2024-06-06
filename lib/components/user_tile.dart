import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String userID;
  final void Function()? onTap;
  const UserTile({
    super.key,
    required this.text,
    required this.userID,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final authService = Provider.of<AuthService>(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //icon
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey,
              ),
              padding: const EdgeInsets.all(5),
              child: const Icon(
                size: 40,
                Icons.person,
                color: Colors.white,
              ),
            ),

            const SizedBox(
              width: 20,
            ),

            //user name and last message
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 0.7,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    // Hiển thị tin nhắn cuối
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: chatService.getMessages(
                            userID, authService.getCurrentUser()!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // Get the last message from the snapshot
                            if (snapshot.data!.docs.isNotEmpty) {
                              final lastMessage =
                                  snapshot.data!.docs.last.data() as Map;
                              return Text(
                                lastMessage['message'], // Display the message
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                  overflow:
                                      TextOverflow.ellipsis, // Add ellipsis
                                ),
                              );
                            } else {
                              return const Text(''); // No messages yet
                            }
                          } else {
                            return const Text(''); // Loading...
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Timestamp (moved to the right)
            StreamBuilder<QuerySnapshot>(
              stream: chatService.getMessages(
                  userID, authService.getCurrentUser()!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Get the last message from the snapshot
                  if (snapshot.data!.docs.isNotEmpty) {
                    final lastMessage = snapshot.data!.docs.last.data() as Map;
                    return Text(
                      _formatTimestamp(lastMessage['timestamp']),
                      style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.primary),
                    );
                  } else {
                    return const Text(''); // No messages yet
                  }
                } else {
                  return const Text(''); // Loading...
                }
              },
            ),
          ],
        ),
      ),
    );
  }

// hiển thị thời gian

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
