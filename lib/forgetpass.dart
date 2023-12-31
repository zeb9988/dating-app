// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:theklicks/coponents/my_textfield.dart';
import 'package:theklicks/coponents/sighnin_button.dart';
import 'package:theklicks/login_page.dart';

class ForgetPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  Future<void> resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
            email: emailController.text.trim(),
          )
          .then((value) => print('email sent'))
          .onError((error, stackTrace) => print('error'));

      // Show a success message or navigate to a success screen
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Password Reset Email Sent'),
            content: const Text(
              'An email has been sent to reset your password. Please check your email.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => LoginPage()));
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // Handle errors (e.g., user not found)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to send password reset email. ${e.message}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forget Password'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(
              icon: Icons.email,
              controller: emailController,
              hintText: 'Enter your email',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => resetPassword(context),
              child: Container(
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
                    "Forgot",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
