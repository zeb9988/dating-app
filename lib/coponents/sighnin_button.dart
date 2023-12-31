import 'package:flutter/material.dart';

class SigninButton extends StatelessWidget {
  const SigninButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF000000), Color(0xFF222222)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
      ),
    );
  }
}
