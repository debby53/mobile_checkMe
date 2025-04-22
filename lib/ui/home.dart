import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'details.dart';

class HomeScreen extends StatefulWidget{
  final String userEmail;

  const HomeScreen({super.key,required this.userEmail});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  List<Map<String, dynamic>> todos = [
    {"title":"Do Mobile assignment","done":true},
    {"title":"Do Java homework", "done":true},
    {"title":"Attend Innovation", "done":false},
    {"title":"Working on .Net project", "done":false},
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> getFilteredTodos(String filter){
    if (filter == 'Completed'){
      return todos.where((todo) => todo['done'] == true).toList();
    }
    else if (filter == 'Pending'){
      return todos.where((todo) => todo['done'] == false).toList();
    }
    else {
      return todos;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> tabs = ['All', 'Completed', 'Pending'];
    return Scaffold(
      appBar: AppBar(
        title: Text('CheckMe App'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.indigo,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.indigo,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: tabs.map((t) => Tab(text: t,)).toList(),
              ),
            ),


        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person,color: Colors.indigo,),

          ),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Welcome, ${widget.userEmail.split('@')[0]} 👋',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: tabs.map((tab){
                    var filtered = getFilteredTodos(tab);
                    return filtered.isEmpty
                        ? Center(child: Text('No $tab todos'))
                        : ListView.builder(

                        itemCount: filtered.length,
                        itemBuilder: (context, index){
                          var todo = filtered[index];

                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TodoDetailsScreen(
                                    todo: todos[index],
                                    index: index,
                                    onUpdate: (updatedTodo) {
                                      setState(() {
                                        todos[index] = updatedTodo;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            leading: Checkbox(
                              value: todo['done'],
                              onChanged: (value) {
                                setState(() {
                                  todo['done'] = value!;
                                });
                              },
                            ),
                            title: Text(
                              todo['title'],
                              style: TextStyle(
                                decoration: todo['done'] ? TextDecoration.lineThrough : null,
                                color: todo['done'] ? Colors.grey : Colors.black,
                              ),
                            ),
                          );

                        },

                    );
                  }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: (){
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                child: TodoForm(onSubmit: (newTodo){
                    setState(() {
                      todos.add(newTodo);
                    });
                    Navigator.pop(context);
              }),
              ),
          );
        },
              child: Icon(Icons.add),
      ),
    );

  }

}

class TodoForm extends StatefulWidget{
  final Function(Map<String, dynamic>) onSubmit;

  const TodoForm({required this.onSubmit});

  @override
  State<StatefulWidget> createState() => _TodoFormState();

}

class _TodoFormState extends State<TodoForm>{

  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
        child: Wrap(
          runSpacing: 12,
          children: [
            Text('Add New Todo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Title *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty ? 'Title is required' : null ,
              onSaved: (value) => title = value!.trim(),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => description = value?.trim() ?? '',
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.maxFinite, 40)
                ),
                icon: Icon(Icons.save),
                label: Text("Save", style: TextStyle(color: Colors.white)),
                onPressed: (){
                  if (_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                    widget.onSubmit({
                      'title':title,
                      'description':description,
                      'done':false,
                      'createdAt':DateTime.now().toString(),
                    });
                  }
                },
            ),
          ],
        ),
    );
  }

}