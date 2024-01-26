import 'package:city_app/others/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authenticateduser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child('chat')
          .orderByChild('timestamp')
          .onValue,
      builder: (ctx, AsyncSnapshot<DatabaseEvent> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapshot.hasData || chatSnapshot.data!.snapshot.value == null) {
          return const Center(
            child: Text('No messages Found'),
          );
        }
        if (chatSnapshot.hasError) {
          return const Center(
            child: Text('Something went Wrong'),
          );
        }
        final loadedMessages = Map<String, dynamic>.from(chatSnapshot.data!.snapshot.value as Map).values.toList()..sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemBuilder: (ctx, index) {
            final ChatMessage = loadedMessages[index];
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1]
                : null;
            final currentMessageUserId = ChatMessage['userId'];
            final nextmessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = nextmessageUserId == currentMessageUserId;
            if (nextUserIsSame) {
              return MessageBubble.next(
                message: ChatMessage['text'],
                isMe: authenticateduser.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: ChatMessage['userImage'],
                username: ChatMessage['username'],
                message: ChatMessage['text'],
                isMe: authenticateduser.uid == currentMessageUserId,
              );
            }
          },
          itemCount: loadedMessages.length,
        );
      },
    );
  }
}
