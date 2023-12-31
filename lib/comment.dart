import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String username;
  final String text;

  const Comment({
    Key? key,
    required this.username,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              username[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
