import 'package:flutter/material.dart';
import 'package:theklicks/search_screen.dart';
import 'chatDetailPage.dart';

class ChatPage extends StatefulWidget {
  final String friendUsername;

  const ChatPage({super.key, required this.friendUsername});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class Message {
  final String username;
  final String content;

  Message({required this.username, required this.content});
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];
  TextEditingController messageController = TextEditingController();

  List<ChatUsers> chatUsers = [
    // Your existing ChatUsers data
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat with ${widget.friendUsername}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatUsers.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundImage: AssetImage('assets/icon.png'),
                    ),
                    title: Text(
                      chatUsers[index].text,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(chatUsers[index].secondaryText),
                    trailing: Text(chatUsers[index].time),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const ChatDetailPage();
                      }));
                    },
                  ),
                );
              },
            ),
          ),
          // Example Chat Interface
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Handle sending the message
                    // For example, you can add the message to the messages list
                    // and clear the text field
                    setState(() {
                      messages.add(
                        Message(
                          username: 'Your Username',
                          content: messageController.text,
                        ),
                      );
                      messageController.clear();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatUsers {
  String text;
  String secondaryText;
  String image;
  String time;

  ChatUsers({
    required this.text,
    required this.secondaryText,
    required this.image,
    required this.time,
  });
}
