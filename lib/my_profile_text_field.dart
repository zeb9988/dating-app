// my_profile_text_field.dart

import 'package:flutter/material.dart';

class MyProfileTextField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final IconData? editIcon;

  const MyProfileTextField({
    Key? key,
    required this.label,
    required this.value,
    required this.onTap,
    this.editIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              if (editIcon != null)
                Icon(
                  editIcon,
                  size: 16,
                  color: Colors.grey[600],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
