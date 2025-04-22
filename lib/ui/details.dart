import 'package:flutter/material.dart';

class TodoDetailsScreen extends StatefulWidget{
  final Map<String, dynamic> todo;
  final int index;
  final Function(Map<String, dynamic>) onUpdate;

  const TodoDetailsScreen({super.key,
    required this.todo,
    required this.index,
    required this.onUpdate,
  });


  @override
  State<StatefulWidget> createState() => _TodoDetailsScreenState();

}

class _TodoDetailsScreenState extends State<TodoDetailsScreen>{

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
        title: Text('Todo Details'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
            child: ListView(
              children: [
                Text("Created: ${widget.todo['createdAt']}",style: TextStyle(fontSize: 14, color: Colors.grey)),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: title,
                  decoration: InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
                  onSaved: (value) =>  title = value!.trim(),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: description,
                  decoration: InputDecoration(
                    labelText: 'Description', border: OutlineInputBorder()
                  ),

                  maxLines: 3,
                  onSaved: (value) => description = value!.trim(),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    minimumSize: Size(double.maxFinite, 50),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                      widget.onUpdate({
                        ...widget.todo,
                        'title':title,
                        'description':description,
                      });
                      Navigator.pop(context);
                    }
                  },
          icon: Icon(Icons.edit),
          label: Text('Save Changes', ),
                ),
              ],
            ),
        ),
      ),
    );
  }

}