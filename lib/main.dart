import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theklicks/chat/provider/firebase_provider.dart';
import 'package:theklicks/home_page.dart';

import 'package:theklicks/login_page.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:theklicks/provider/userProvider.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBSep7Vak2WP7Gb9qNlVKY3fb0y6pZqNrs',
          appId: '1:882651731701:android:cba141db54ba3f030517bc',
          messagingSenderId: '882651731701',
          projectId: 'klicks-2252e',
          storageBucket: 'klicks-2252e.appspot.com'));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBSep7Vak2WP7Gb9qNlVKY3fb0y6pZqNrs',
          appId: '1:882651731701:android:cba141db54ba3f030517bc',
          messagingSenderId: '882651731701',
          projectId: 'klicks-2252e',
          storageBucket: 'klicks-2252e.appspot.com'));

  await FirebaseMessaging.instance.getInitialMessage();

  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => FirebaseProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // Choose your primary color
        hintColor: Colors.orange, // Choose your accent color
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // Checking if the snapshot has any data or not
            if (snapshot.hasData) {
              // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
              return const HomePage();
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
          }

          // means connection to future hasnt been made yet
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return LoginPage();
        },
      ));
}
