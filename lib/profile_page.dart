// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:theklicks/my_posts.dart';
import 'chat_page.dart';
import 'settings.dart';

class User {
  final String userId;
  final String username;
  final List<Post> posts;

  User({
    required this.userId,
    required this.username,
    required this.posts,
  });
}

class Post {
  final String postId;
  final String content;
  final DateTime timestamp;

  Post({
    required this.postId,
    required this.content,
    required this.timestamp,
  });
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final currentUser = FirebaseAuth.instance.currentUser;
  String? profileImageUrl;
  String? profileImageUrl2;
  bool isProfileImageChanged = false;
  String username = 'Guest';
  String bio = 'No bio available';
  String? gender;
  String? isSingle;

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirebase();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImageUrl = pickedFile.path;
        isProfileImageChanged = true;
      });

      await _uploadImageToStorage(); // Upload image to Firebase Storage
      _saveProfileChanges();

      // Show a message when the picture is updated
      // _scaffoldKey.currentState?.showSnackBar(
      //   SnackBar(
      //     content: Text('Profile picture updated'),
      //   ),
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Profile picture updated',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green, // Set background color
          duration: const Duration(seconds: 2), // Set duration
          behavior: SnackBarBehavior.floating, // Make it a floating Snackbar
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ), // Add rounded corners
        ),
      );
    }
  }

  Future<void> _uploadImageToStorage() async {
    if (profileImageUrl != null) {
      final file = File(profileImageUrl!);
      final fileName = '${currentUser?.uid}_profile_picture.jpg';

      try {
        await FirebaseStorage.instance
            .ref('profile_pictures/$fileName')
            .putFile(file);
        final downloadURL = await FirebaseStorage.instance
            .ref('profile_pictures/$fileName')
            .getDownloadURL();

        setState(() {
          profileImageUrl2 = downloadURL;
        });
        _saveProfileChanges();
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
      }
    }
  }

  Future<void> _saveProfileChanges() async {
    final userCollection = FirebaseFirestore.instance.collection('users1');

    // Update user information in Firestore
    await userCollection.doc(currentUser?.uid).update({
      'profileImageUrl': profileImageUrl2,
    });
    setState(() {});
    // Simulate fetching data from Firebase
    await _fetchDataFromFirebase();
  }

  Future<void> _fetchDataFromFirebase() async {
    final userCollection = FirebaseFirestore.instance.collection('users1');

    // Fetch user information from Firestore
    final userDoc = await userCollection.doc(currentUser?.uid).get();
    final userData = userDoc.data() as Map<String, dynamic>?;

    // Update the UI with the fetched data
    if (userData != null) {
      setState(() {
        username = userData['username'] ?? username;
        bio = userData['bio'] ?? bio;
        gender = userData['gender'] ?? gender;
        isSingle = userData['single'] ?? isSingle;
        profileImageUrl2 = userData['profileImageUrl'] ?? profileImageUrl2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Profile Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    initialUsername: username,
                    initialBio: bio,
                    initialGender: gender,
                    isSingle: isSingle,
                    onSave: (updatedValues) {
                      setState(() {
                        username = updatedValues['username'] ?? username;
                        bio = updatedValues['bio'] ?? bio;
                        gender = updatedValues['gender'] ?? gender;
                        isSingle = updatedValues['single'] ?? isSingle;
                      });
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatPage(friendUsername: ''),
                ),
              );
            },
          ),
        ],
        toolbarTextStyle: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ).bodyMedium,
        titleTextStyle: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ).titleLarge,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              // You can customize the background image properties here
              image: profileImageUrl2 != null
                  ? DecorationImage(
                      image: NetworkImage(profileImageUrl2!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 72,
                      backgroundColor: Colors.white,
                      backgroundImage: profileImageUrl2 != null &&
                              Uri.parse(profileImageUrl2!).isAbsolute
                          ? NetworkImage(profileImageUrl2!)
                          : null,
                      child: profileImageUrl2 == null ||
                              !Uri.parse(profileImageUrl2!).isAbsolute
                          ? const Icon(
                              Icons.person,
                              size: 72,
                              color: Colors.pinkAccent,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  currentUser?.email ?? 'No email available',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                _buildProfileCard('Username', username),
                const SizedBox(height: 10),
                _buildProfileCard('Bio', bio),
                const SizedBox(height: 10),
                _buildProfileCard('Gender', gender ?? 'Not specified'),
                const SizedBox(height: 10),
                _buildProfileCard('Single', isSingle ?? 'Not specified'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            MyPosts(userEmail: currentUser?.email.toString()),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 60),
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'My Posts',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.pinkAccent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
