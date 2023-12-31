import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:theklicks/chat/service/firebase_firestore_service.dart';
import 'package:theklicks/chat/service/notification_service.dart';
// import 'package:theklicks/components/my_textfield.dart';
// import 'package:theklicks/components/signin_button.dart';
import 'package:theklicks/coponents/my_textfield.dart';
import 'package:theklicks/coponents/sighnin_button.dart';
import 'package:theklicks/errorwidget/errorDialouge.dart';
import 'package:theklicks/forgetpass.dart';
// import 'package:theklicks/errorwidget/error_dialog.dart';
import 'package:theklicks/home_page.dart';
import 'package:theklicks/sighnup.dart';

// import 'package:theklicks/signup.dart';
class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  static final notifications = NotificationsService();
  Future<void> signUserIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestoreService.updateUserData(
        {'lastActive': DateTime.now()},
      );

      await notifications.requestPermission();
      await notifications.getToken();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const HomePage();
      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        showErrorDialog(
            context: context, title: 'Invalid username', error: e.toString());
      } else if (e.code == "wrong-password") {
        showErrorDialog(
            context: context, title: 'Invalid password', error: e.toString());
      } else {
        showErrorDialog(context: context, title: 'Error', error: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Hello Again!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 36),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Welcome Back, you have been missed!',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        icon: Icons.email,
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        icon: Icons.password,
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgetPasswordPage())),
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => signUserIn(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          context: context,
                        ),
                        child: const SigninButton(),
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignUpPage()));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "Sign up Now",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'or continue with',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
