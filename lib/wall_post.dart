import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'like_button.dart';
import 'path_to_your_maps_page/maps_page.dart';

// Define the Comment class
class Comment {
  final String username;
  final String text;
  final String? profileImageUrl; // Add profile image URL

  Comment({
    required this.username,
    required this.text,
    this.profileImageUrl,
  });
}

// Define the Reply class
class Reply {
  final String username;
  final String text;

  Reply({
    required this.username,
    required this.text,
  });
}

// Define the WallPost class
class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final String gender;
  final List likes;
  final List<dynamic> comments;
  final String? profileImageUrl;
  final List<Reply> replies;

  const WallPost({
    Key? key,
    required this.message,
    required this.gender,
    required this.user,
    required this.postId,
    required this.likes,
    required this.comments,
    required this.profileImageUrl,
    required this.replies,
  }) : super(key: key);

  @override
  State<WallPost> createState() => _WallPostState();
}

// Define the _WallPostState class
class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike({required String id}) {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(id);

    if (isLiked) {
      postRef.update({
        'likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          postId: widget.postId,
          profilepic: widget.profileImageUrl!,
          comments: widget.comments,
          replies: widget.replies,
        ),
      ),
    );
  }

  void deletePost() {
    if (currentUser.email == widget.user) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Post'),
            content: const Text('Are you sure you want to delete this post?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('User Posts')
                      .doc(widget.postId)
                      .delete();
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permission Denied'),
            content:
                const Text('You do not have permission to delete this post.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      margin: const EdgeInsets.all(7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('User Posts')
            .doc(widget.postId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          var post = snapshot.data!;
          var commentsData = post['comments'] ?? [];

          List<Comment> comments = commentsData.map<Comment>((commentData) {
            return Comment(
              username: commentData['username'],
              text: commentData['text'],
            );
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    // Background Image
                    Container(
                      height: 200, // Adjust the height as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: widget.profileImageUrl != null &&
                                widget.profileImageUrl!.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(widget.profileImageUrl!),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: NetworkImage(
                                  widget.gender == 'male'
                                      ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8oghbsuzggpkknQSSU-Ch_xep_9v3m6EeBQ&usqp=CAU'
                                      : 'https://static.vecteezy.com/system/resources/previews/024/766/959/non_2x/default-female-avatar-profile-icon-social-media-chatting-online-user-free-vector.jpg',
                                ),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),

                    // Content Overlay
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // User Info
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: widget.profileImageUrl !=
                                                null &&
                                            widget.profileImageUrl!.isNotEmpty
                                        ? NetworkImage(widget.profileImageUrl!)
                                        : null,
                                    child: widget.profileImageUrl == null ||
                                            widget.profileImageUrl!.isEmpty
                                        ? const Icon(
                                            Icons.person,
                                            color: Colors.black,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.user,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              // Icons (Chat, Location, More)
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.chat,
                                      color: Colors.black,
                                      size: 28,
                                    ),
                                    onPressed: openChat,
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.location_history,
                                      color: Colors.black,
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MapsPage(),
                                        ),
                                      );
                                    },
                                  ),
                                  if (currentUser.email == widget.user)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Colors.red,
                                        size: 28,
                                      ),
                                      onPressed: deletePost,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.message,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  maxLines: isExpanded ? null : 3,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.message.length > 100)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      isExpanded ? 'See Less' : 'See More',
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    LikeButton(
                      isLiked: isLiked,
                      count: widget.likes.length,
                      onTap: () {
                        toggleLike(id: widget.postId);
                      },
                    ),
                    const SizedBox(width: 14),
                    Text(
                      widget.likes.length.toString(),
                      style: TextStyle(
                        color: isLiked ? Colors.pink[300] : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(child: Container()),
                    if (widget.gender == 'male')
                      Icon(
                        Icons.male,
                        size: 40,
                      )
                    else
                      Icon(
                        Icons.female,
                        size: 40,
                      )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Define the ChatScreen class
class ChatScreen extends StatefulWidget {
  final String postId;
  final List comments;
  final List<Reply> replies;
  final String profilepic;

  const ChatScreen({
    Key? key,
    required this.postId,
    required this.profilepic,
    required this.comments,
    required this.replies,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

// Define the _ChatScreenState class
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _commentController = TextEditingController();
  late List<Comment> comments;
  String? name;
  String? profileImageUrl; // Add profile image URL

  Future<void> _fetchDataFromFirebase() async {
    final userCollection = FirebaseFirestore.instance.collection('users1');
    final currentUser = FirebaseAuth.instance.currentUser;
    final userDoc = await userCollection.doc(currentUser?.uid).get();
    final userData = userDoc.data() as Map<String, dynamic>?;

    if (userData != null) {
      setState(() {
        name = userData['username'] ?? name;
        profileImageUrl =
            userData['profileImageUrl']; // Update with the actual field name
      });
    }
  }

  @override
  void initState() {
    comments = (widget.comments as List<dynamic>).map<Comment>((commentData) {
      return Comment(
        username: commentData['username'],
        text: commentData['text'],
        profileImageUrl:
            commentData['profileImageUrl'], // Include profile image URL
      );
    }).toList();
    _fetchDataFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat for Post',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.map,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Set reverse to true for chat-like behavior
              itemCount: comments.length,
              itemBuilder: (context, index) {
                Comment comment = comments[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: comment.profileImageUrl != null &&
                                comment.profileImageUrl!.isNotEmpty
                            ? NetworkImage(comment.profileImageUrl!)
                            : Image.asset('assets/icon.png')
                                .image, // Use Image.asset to create an ImageProvider for the asset
                        backgroundColor: Colors.blue,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              comment.text,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          for (Reply reply in widget.replies)
            ReplyWidget(
              reply: reply,
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Type your Reply...',
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Comment newComment = Comment(
                    username: name!,
                    text: _commentController.text,
                    profileImageUrl:
                        profileImageUrl, // Include profile image URL
                  );

                  setState(() {
                    comments.add(newComment);
                    _commentController.clear();
                  });

                  DocumentReference postRef = FirebaseFirestore.instance
                      .collection('User Posts')
                      .doc(widget.postId);

                  await postRef.update({
                    'comments': FieldValue.arrayUnion([
                      {
                        'username': newComment.username,
                        'text': newComment.text,
                        'profileImageUrl': newComment
                            .profileImageUrl, // Include profile image URL
                      }
                    ])
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Send',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // Spacer(),
        ],
      ),
    );
  }
}

// Define the ReplyWidget class
class ReplyWidget extends StatelessWidget {
  final Reply reply;

  const ReplyWidget({
    Key? key,
    required this.reply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reply.username,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(reply.text),
        ],
      ),
    );
  }
}
