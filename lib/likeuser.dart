import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:theklicks/chat_page.dart';
import 'package:theklicks/likeuserProfile.dart';
import 'package:theklicks/models/user.dart';
import 'package:theklicks/profile_page.dart';

class LikedMe extends StatefulWidget {
  const LikedMe({Key? key}) : super(key: key);

  @override
  State<LikedMe> createState() => _LikedMeState();
}

class _LikedMeState extends State<LikedMe> {
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<List<Usermodel>> getUsersWhoLikedMe(String currentUserEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users1')
          .where('likedPeople', arrayContains: currentUserEmail)
          .get();

      return querySnapshot.docs.map((doc) {
        return Usermodel.fromSnap(doc);
      }).toList();
    } catch (e) {
      print('Error fetching users who liked you: $e');
      return [];
    }
  }

  Future<void> likeBack(Usermodel likedUser) async {
    try {
      if (likedUser.likedBack.contains(currentUser?.email)) {
        await FirebaseFirestore.instance
            .collection('users1')
            .doc(currentUser?.uid)
            .update({
          'likedPeople': FieldValue.arrayRemove([likedUser.email])
        });

        await FirebaseFirestore.instance
            .collection('users1')
            .doc(likedUser.uid)
            .update({
          'likedBack': FieldValue.arrayRemove([currentUser?.email])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users1')
            .doc(currentUser?.uid)
            .update({
          'likedPeople': FieldValue.arrayUnion([likedUser.email])
        });

        await FirebaseFirestore.instance
            .collection('users1')
            .doc(likedUser.uid)
            .update({
          'likedBack': FieldValue.arrayUnion([currentUser?.email])
        });
      }
      setState(() {});
    } catch (e) {
      print('Error liking back: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333),
        title: const Text(
          'Liked Users',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Usermodel>>(
        future: getUsersWhoLikedMe(currentUser?.email ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users have liked you yet.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return LikedUserCard(
                  user: snapshot.data![index],
                  likeBack: likeBack,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class LikedUserCard extends StatelessWidget {
  final Usermodel user;
  final Function(Usermodel) likeBack;

  const LikedUserCard({Key? key, required this.user, required this.likeBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool likedBack =
        user.likedBack.contains(FirebaseAuth.instance.currentUser?.email);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: NetworkImage(
                  user.profileImageUrl.isEmpty
                      ? 'https://example.com/placeholder.jpg'
                      : user.profileImageUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.bio,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                IconButton(
                  icon: Icon(
                    likedBack ? Icons.favorite : Icons.favorite_border,
                    color: likedBack ? Colors.red : Colors.black,
                    size: 36,
                  ),
                  onPressed: () {
                    likeBack(user);
                  },
                ),
                if (likedBack)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chat),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatPage(friendUsername: user.username),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.person),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage2(
                                bio: user.bio,
                                email: user.email,
                                gender: user.gender,
                                imageUrl: user.profileImageUrl,
                                status: user.single,
                                username: user.username,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
