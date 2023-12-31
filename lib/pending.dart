import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:theklicks/models/user.dart';

class PendingPage extends StatelessWidget {
  const PendingPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Total Soulmates',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Total Soulmates Matched',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          FutureBuilder<int>(
            future: getTotalUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text(
                  'Total Users: ${snapshot.data}',
                  style: TextStyle(fontSize: 16),
                );
              }
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Usermodel>>(
              future: getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Usermodel> users = snapshot.data!;
                  return UsersGrid(users: users);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<int> getTotalUsers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users1').get();
    return querySnapshot.size;
  }

  Future<List<Usermodel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users1').get();

      return querySnapshot.docs.map((doc) {
        return Usermodel.fromSnap(doc);
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }
}

class UsersGrid extends StatefulWidget {
  final List<Usermodel> users;

  const UsersGrid({Key? key, required this.users}) : super(key: key);

  @override
  _UsersGridState createState() => _UsersGridState();
}

class _UsersGridState extends State<UsersGrid> {
  final Set<Offset> takenPositions = {};

  double getRandomRadius() {
    final random = Random();
    return random.nextDouble() * 40 + 20; // Radius between 20 and 60
  }

  Offset getRandomPosition() {
    final random = Random();
    final screenWidth = MediaQuery.of(context).size.width - 80;
    final screenHeight = MediaQuery.of(context).size.height - 80;

    while (true) {
      final position = Offset(random.nextDouble() * screenWidth,
          random.nextDouble() * screenHeight);

      if (takenPositions.every(
          (takenPosition) => (position - takenPosition).distance > 100.0)) {
        takenPositions.add(position);
        return position;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: widget.users.map((user) {
        final position = getRandomPosition();
        final radius = getRandomRadius();
        return Positioned(
          left: position.dx,
          top: position.dy,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              if (user.profileImageUrl != null &&
                  user.profileImageUrl.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.profileImageUrl),
                    radius: radius,
                  ),
                ),
              if (user.profileImageUrl == null || user.profileImageUrl.isEmpty)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    radius: radius,
                    backgroundColor: Colors.blue,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
