import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final String initialUsername;
  final String initialBio;
  final String? initialGender;
  final String? isSingle;
  final Null Function(Map<String, dynamic> updatedValues) onSave;

  const SettingsPage({
    Key? key,
    required this.initialUsername,
    required this.initialBio,
    this.initialGender,
    required this.onSave,
    this.isSingle,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  bool? _isMale;
  bool? _isSingle;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.initialUsername);
    _bioController = TextEditingController(text: widget.initialBio);
    _isMale = widget.initialGender == 'Male';
    _isSingle = false; // Initialize with a default value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF333333), // Dark gray
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField('Username', _usernameController),
            const SizedBox(height: 16),
            _buildTextField('Bio', _bioController),
            const SizedBox(height: 16),
            _buildSwitch('Gender', _isMale, (value) {
              setState(() {
                _isMale = value;
              });
            }),
            const SizedBox(height: 16),
            _buildSwitch('Single', _isSingle, (value) {
              setState(() {
                _isSingle = value;
              });
            }),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await _saveProfileDataToFirestore();

                widget.onSave({
                  'username': _usernameController.text,
                  'bio': _bioController.text,
                  'gender':
                      _isMale != null ? (_isMale! ? 'Male' : 'Female') : null,
                  'single':
                      _isSingle != null ? (_isSingle! ? 'Yes' : 'No') : null,
                });

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // Coral color
                onPrimary: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFD5A44)), // Coral color
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSwitch(String label, bool? value, Function(bool) onChanged) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
        Switch(
          value: value ?? false,
          onChanged: onChanged,
          activeColor: const Color(0xFFFD5A44), // Coral color
        ),
        Text(
          value ?? false ? 'Yes' : 'No',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Future<void> _saveProfileDataToFirestore() async {
    final userCollection = FirebaseFirestore.instance.collection('users1');
    final currentUser = FirebaseAuth.instance.currentUser;

    await userCollection.doc(currentUser?.uid).update({
      'username': _usernameController.text,
      'Email': currentUser!.email,
      'bio': _bioController.text,
      'gender': _isMale != null ? (_isMale! ? 'Male' : 'Female') : null,
      'single': _isSingle != null ? (_isSingle! ? 'Yes' : 'No') : null,
    });
  }
}
