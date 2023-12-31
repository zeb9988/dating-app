import 'package:flutter/material.dart';

class EssentialItem extends StatelessWidget {
  final String label;
  final String value;

  EssentialItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
