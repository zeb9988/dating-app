import 'package:flutter/material.dart';

class ProfilePage2 extends StatelessWidget {
  final String imageUrl;
  final String username;
  final String email;
  final String bio;
  final String gender;
  final String status;

  const ProfilePage2({
    Key? key,
    required this.imageUrl,
    required this.username,
    required this.email,
    required this.bio,
    required this.gender,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.grey, // Customize the app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                const SizedBox(height: 20),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto', // Use a modern font
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Bio:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  bio,
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                _buildRow(Icons.person, gender),
                const SizedBox(height: 12),
                _buildRow(Icons.favorite, status),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.indigo),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ],
    );
  }
}
