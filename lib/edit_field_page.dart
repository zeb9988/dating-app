import 'package:flutter/material.dart';

class EditFieldPage extends StatefulWidget {
  final String fieldName;
  final String initialValue;

  const EditFieldPage({super.key, 
    required this.fieldName,
    required this.initialValue,
  });

  @override
  _EditFieldPageState createState() => _EditFieldPageState();
}

class _EditFieldPageState extends State<EditFieldPage> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.fieldName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Current ${widget.fieldName}: ${widget.initialValue}'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'New ${widget.fieldName}',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _textEditingController.text);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
