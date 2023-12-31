import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:theklicks/wall_post.dart'; // Assuming you have a WallPost widget

class MyPosts extends StatelessWidget {
  const MyPosts({Key? key, required this.userEmail}) : super(key: key);
  final userEmail;

  @override
  Widget build(BuildContext context) {
    print(userEmail);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Posts',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('User Posts')
              .where('UserEmail', isEqualTo: userEmail)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return WallPost(
                  gender: data['gender'],
                  profileImageUrl: data['profileImageUrl'],
                  message: data['Message'],
                  user: data['UserEmail'],
                  postId: document.id,
                  likes: data['likes'],
                  comments: data['comments'],
                  replies: const [], // Add replies if needed
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
