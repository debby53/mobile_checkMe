import 'package:flutter/material.dart';

class TodoDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> todo;
  final int index;
  final Function(Map<String, dynamic>) onUpdate;

  const TodoDetailsScreen({
    super.key,
    required this.todo,
    required this.index,
    required this.onUpdate,
  });

  @override
  State<StatefulWidget> createState() => _TodoDetailsScreenState();
}

class _TodoDetailsScreenState extends State<TodoDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    title = widget.todo['title'] ?? '';
    description = widget.todo['description'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Creation date
              Text(
                "Created At: ${widget.todo['createdAt']}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              // Title field
              Text(
                "Title",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(
                  hintText: 'Enter title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Title required' : null,
                onSaved: (value) => title = value!.trim(),
              ),
              const SizedBox(height: 24),

              // Description field
              Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: description,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter full description',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => description = value!.trim(),
              ),
              const SizedBox(height: 32),

              // Save Changes Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onUpdate({
                      ...widget.todo,
                      'title': title,
                      'description': description,
                    });
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
