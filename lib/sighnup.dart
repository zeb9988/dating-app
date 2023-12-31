import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:theklicks/chat/service/firebase_firestore_service.dart';
import 'package:theklicks/chat/service/notification_service.dart';
import 'package:theklicks/coponents/my_textfield.dart';
import 'package:theklicks/errorwidget/errorDialouge.dart';
import 'package:theklicks/login_page.dart';
import 'package:theklicks/models/user.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, Key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordController2 = TextEditingController();
  static final notifications = NotificationsService();
  final _usernameController =
      TextEditingController(); // Add this controller for the username

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String password2,
    required String username, // Add the username parameter
  }) async {
    if (password == password2) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        Usermodel usermodel = Usermodel(
            uid: userCredential.user!.uid,
            likedBack: [],
            likedPeople: [],
            profileImageUrl:
                'https://static.vecteezy.com/system/resources/previews/024/766/959/non_2x/default-female-avatar-profile-icon-social-media-chatting-online-user-free-vector.jpg',
            gender: 'female',
            single: '',
            username: username,
            email: email,
            bio: '');
        _saveProfileDataToFirestore(usermodel);

        await FirebaseFirestoreService.createUser(
          // image: image,
          email: email,
          uid: userCredential.user!.uid,
          name: username,
        );

        await notifications.requestPermission();
        await notifications.getToken();
        // await FirebaseFirestore.instance
        //     .collection("users")
        //     .doc(userCredential.user!.email)
        //     .set({
        //   'username': username, // Store the username in Firebase
        // });

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomePage()));
      } catch (e) {
        // ignore: use_build_context_synchronously
        showErrorDialog(context: context, title: 'Error', error: e.toString());
      }
    } else {
      showErrorDialog(
          context: context, title: 'Error', error: 'Passwords do not match');
    }
  }

  Future<void> _saveProfileDataToFirestore(Usermodel usermodel) async {
    final userCollection = FirebaseFirestore.instance.collection('users1');
    final currentUser = FirebaseAuth.instance.currentUser;

    await userCollection.doc(currentUser?.uid).set(usermodel.toJson());
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Hello!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 36),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Let\'s create an account for you!',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        icon: Icons.account_circle,
                        controller: _usernameController,
                        hintText: 'Username',
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        icon: Icons.email,
                        controller: _emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        icon: Icons.password,
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        icon: Icons.password,
                        controller: _passwordController2,
                        hintText: 'Repeat Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => signUpWithEmail(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                          password2: _passwordController2.text,
                          username:
                              _usernameController.text, // Pass the username
                        ),
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
                              "Sign up",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => LoginPage()),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
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

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
    _usernameController.dispose(); // Dispose the username controller
  }
}
