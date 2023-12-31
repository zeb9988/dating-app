import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Soulmate'),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text('This is the search screen'),
      ),
    );
  }
}
