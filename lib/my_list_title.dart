import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const MyListTile({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black,
              size: 30,
            ),
            const SizedBox(width: 20),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
