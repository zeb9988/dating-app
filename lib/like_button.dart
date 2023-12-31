// like_button.dart

import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final int count;
  final VoidCallback onTap;

  const LikeButton({
    Key? key,
    required this.isLiked,
    required this.count,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.pink : Colors.black,
            size: 24,
          ),
          const SizedBox(width: 4),
          Text(
            '$count Likes',
            style: TextStyle(
              color: isLiked ? Colors.pink : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
