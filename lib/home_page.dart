import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theklicks/chat/view/screens/chats_screen.dart';
import 'package:theklicks/drawer.dart';
import 'package:theklicks/login_page.dart';
import 'package:theklicks/pending.dart';
import 'package:theklicks/provider/userProvider.dart';
import 'package:theklicks/soulmate.dart';
import 'package:theklicks/wall_post.dart';

import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  String? name;
  String? gender;
  String? profileImageUrl;
  @override
  void initState() {
    _fetchDataFromFirebase();
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userprovider =
        Provider.of<UserProvider>(context, listen: false);
    await _userprovider.refreshUser();
  }

  Future<void> _fetchDataFromFirebase() async {
    final userCollection = FirebaseFirestore.instance.collection('users1');

    // Fetch user information from Firestore
    final userDoc = await userCollection.doc(currentUser?.uid).get();
    final userData = userDoc.data() as Map<String, dynamic>?;

    // Update the UI with the fetched data
    if (userData != null) {
      setState(() {
        name = userData['username'] ?? name;
        // bio = userData['bio'] ?? bio;
        gender = userData['gender'] ?? gender;
        // isSingle = userData['single'] ?? isSingle;
        profileImageUrl = userData['profileImageUrl'] ?? profileImageUrl;
      });
    }
  }

  // Future<void> _fetchDataFromFirebase() async {
  //   final userCollection = FirebaseFirestore.instance.collection('users');
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   // Fetch user information from Firestore
  //   final userDoc = await userCollection.doc(currentUser?.uid).get();
  //   final userData = userDoc.data() as Map<String, dynamic>?;

  //   // Update the UI with the fetched data
  //   if (userData != null) {
  //     print("UserData: $userData");
  //     setState(() {
  //       name = userData['username'] ?? name;
  //       profileImageUrl = userData['profileImageUrl'] ?? profileImageUrl;
  //       print("isSingle: $profileImageUrl");
  //     });
  //   }
  // }

  // post message
  void postMessage() async {
    // only post if theres something in the textfild
    if (textController.text.isNotEmpty) {
      //store in firebase
      await FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser?.email,
        'username': name,
        'profileImageUrl': profileImageUrl,
        'gender': gender,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'likes': [],
        'comments': [],
      });

      FocusScope.of(context).requestFocus(FocusNode());
      textController.clear();
    }
  }

  //navigate to profile page
  void goToProfilePage() {
    // pop menue drawer
    Navigator.pop(context);

    // go to new page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.pink, Colors.pinkAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Soulmate',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to the Soulmates Page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SoulmatePage(
                          postLikes: [],
                        )),
              );
            },
            icon: const Icon(
              Icons.people_outline,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigate to the Pending Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PendingPage()),
              );
            },
            icon: const Icon(
              Icons.tips_and_updates,
              color: Colors.black,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.sms), // Add the chat icon here
            onPressed: () {
              // Navigate to the Chat Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatsScreen()),
              );
            },
          ),
        ],
      ),
      drawerScrimColor: Colors.black.withOpacity(0.7),
      drawer: MyDrawer(
        appVersion: '1.0.0',
        onProfileTap: goToProfilePage,
        onSignOut: () async {
          final FirebaseAuth auth = FirebaseAuth.instance;
          await auth.signOut();
          if (!mounted) {
            return;
          }
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginPage()));
        },
      ),
      body: Center(
        child: Column(
          children: [
            // The wall
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("User Posts")
                      .orderBy(
                        "TimeStamp",
                        descending: false,
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          //get the message
                          final post = snapshot.data!.docs[index];
                          print(post.data());
                          return WallPost(
                            gender: post['gender'],
                            profileImageUrl: post['profileImageUrl'],
                            message: post['Message'],
                            user: post['username'],
                            postId: post.id,
                            likes: post['likes'],
                            comments: post['comments'],
                            replies: const [],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error:${snapshot.error}'),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onEditingComplete: postMessage,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        filled: true,
                        fillColor: Colors.grey[200]!
                            .withOpacity(0.8), // Transparent background color
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20), // Padding inside the input field
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(25), // Rounded border
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.pink, // Send button color
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
