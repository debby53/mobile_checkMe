// main.dart
import 'package:flutter/material.dart';


void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CheckMe Todo App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

// Login Screen with Validation
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Email validation regex
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Password validation (at least 8 characters with 1 number and 1 letter)
  bool _isValidPassword(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[a-zA-Z]'));
  }

  _login() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate login request
      Future.delayed(const Duration(seconds: 1), () {
        setState(() => _isLoading = false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(userName: _nameController.text),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'CheckMe',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 48),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!_isValidEmail(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password';
                      }
                      if (!_isValidPassword(value)) {
                        return 'Password must be at least 8 characters with numbers and letters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                      'Login',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Todo Model Class
class Todo {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime? dueDate;
  String category;

  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.dueDate,
    this.category = 'Personal',
  });
}

// Home Screen with Todo Dashboard
class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Todo> _todos = [];
  final List<Todo> _filteredTodos = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Personal', 'Work', 'School', 'Urgent'];

  @override
  void initState() {
    super.initState();
    // Add some sample todos
    _todos.addAll([
      Todo(
        id: '1',
        title: 'Complete Flutter project',
        description: 'Implement all required features for the CheckMe app',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        category: 'Work',
      ),
      Todo(
        id: '2',
        title: 'Buy groceries',
        description: 'Milk, eggs, bread, and vegetables',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Personal',
      ),
    ]);
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredTodos.clear();
      _filteredTodos.addAll(_todos.where((todo) {
        final matchesSearch = todo.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            todo.description.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == 'All' || todo.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList());
    });
  }

  void _addTodo(Todo newTodo) {
    setState(() {
      _todos.add(newTodo);
      _applyFilters();
    });
  }

  void _toggleTodoCompletion(String id) {
    setState(() {
      final index = _todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        _todos[index].isCompleted = !_todos[index].isCompleted;
        _applyFilters();
      }
    });
  }

  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((todo) => todo.id == id);
      _applyFilters();
    });
  }

  String _getDueStatus(DateTime? dueDate) {
    if (dueDate == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (dueDay.isBefore(today)) {
      return ' (Overdue)';
    } else if (dueDay == today) {
      return ' (Due Today)';
    } else {
      return ' (Due ${DateFormat('MM' 'dd'  'yyyy').format(dueDate)})';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckMe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildCategoryFilterSheet(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Welcome message with avatar
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.teal.shade300,
                  radius: 24,
                  child: Text(
                    widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${widget.userName}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'You have ${_todos.where((t) => !t.isCompleted).length} tasks remaining',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search todos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _applyFilters();
                });
              },
            ),
          ),

          // Category filter chips
          if (_selectedCategory != 'All')
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: Row(
                children: [
                  Text('Category: $_selectedCategory',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = 'All';
                        _applyFilters();
                      });
                    },
                    child: const Icon(Icons.close, size: 16),
                  ),
                ],
              ),
            ),

          // Todo list
          Expanded(
            child: _filteredTodos.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty && _selectedCategory == 'All'
                        ? 'No todos yet. Add one!'
                        : 'No matching todos found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _filteredTodos.length,
              itemBuilder: (context, index) {
                final todo = _filteredTodos[index];
                final dueStatus = _getDueStatus(todo.dueDate);

                return Dismissible(
                  key: Key(todo.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _deleteTodo(todo.id),
                  child: ListTile(
                    leading: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (bool? value) {
                        _toggleTodoCompletion(todo.id);
                      },
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration:
                        todo.isCompleted ? TextDecoration.lineThrough : null,
                        color: todo.isCompleted ? Colors.grey : null,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(todo.category).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            todo.category,
                            style: TextStyle(
                              fontSize: 12,
                              color: _getCategoryColor(todo.category),
                            ),
                          ),
                        ),
                        if (todo.dueDate != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            dueStatus,
                            style: TextStyle(
                              fontSize: 12,
                              color: dueStatus.contains('Overdue')
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodoDetailScreen(
                            todo: todo,
                            onTodoUpdated: () {
                              setState(() {
                                _applyFilters();
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryFilterSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((category) {
              return FilterChip(
                label: Text(category),
                selected: _selectedCategory == category,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                    _applyFilters();
                  });
                  Navigator.pop(context);
                },
                backgroundColor: _getCategoryColor(category).withOpacity(0.1),
                selectedColor: _getCategoryColor(category).withOpacity(0.3),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Work':
        return Colors.blue;
      case 'Personal':
        return Colors.teal;
      case 'School':
        return Colors.purple;
      case 'Urgent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showAddTodoDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddTodoForm(
          onTodoAdded: _addTodo,
          categories: _categories.where((c) => c != 'All').toList(),
        );
      },
    );
  }
}

extension on DateFormat {
  format(DateTime dueDate) {}
}

class DateFormat {
  DateFormat(String s);
}

// Add Todo Form
class AddTodoForm extends StatefulWidget {
  final Function(Todo) onTodoAdded;
  final List<String> categories;

  const AddTodoForm({
    Key? key,
    required this.onTodoAdded,
    required this.categories,
  }) : super(key: key);

  @override
  State<AddTodoForm> createState() => _AddTodoFormState();
}

class _AddTodoFormState extends State<AddTodoForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedCategory = 'Personal';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _selectedDate,
        category: _selectedCategory,
      );
      widget.onTodoAdded(newTodo);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add New Todo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: widget.categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due Date (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'No date selected'
                            : DateFormat('MMM d, yyyy').format(_selectedDate!),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CANCEL'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('SAVE'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// Todo Detail Screen
class TodoDetailScreen extends StatefulWidget {
  final Todo todo;
  final VoidCallback onTodoUpdated;

  const TodoDetailScreen({
    Key? key,
    required this.todo,
    required this.onTodoUpdated,
  }) : super(key: key);

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late bool _isCompleted;
  late DateTime? _dueDate;
  late String _category;
  bool _isEditing = false;

  get fontSize => null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(text: widget.todo.description);
    _isCompleted = widget.todo.isCompleted;
    _dueDate = widget.todo.dueDate;
    _category = widget.todo.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Save changes when exiting edit mode
        widget.todo.title = _titleController.text;
        widget.todo.description = _descriptionController.text;
        widget.todo.isCompleted = _isCompleted;
        widget.todo.dueDate = _dueDate;
        widget.todo.category = _category;
        widget.onTodoUpdated();
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!_isEditing) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  String _getDueStatusText() {
    if (_dueDate == null) return 'No due date';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(_dueDate!.year, _dueDate!.month, _dueDate!.day);

    if (dueDay.isBefore(today)) {
      return 'Overdue (${DateFormat('MMM d, yyyy').format(_dueDate!)})';
    } else if (dueDay == today) {
      return 'Due Today (${DateFormat('MMM d, yyyy').format(_dueDate!)})';
    } else {
      return 'Due on ${DateFormat('MMM d, yyyy').format(_dueDate!)}';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Work':
        return Colors.blue;
      case 'Personal':
        return Colors.teal;
      case 'School':
        return Colors.purple;
      case 'Urgent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _toggleEditing,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task completion status
            Row(
              children: [
                Checkbox(
                  value: _isCompleted,
                  onChanged: (bool? value) {
                    if (_isEditing && value != null) {
                      setState(() {
                        _isCompleted = value;
                      });
                    }
                  },
                ),
                Text(
                  _isCompleted ? 'Completed' : 'Not completed',
                  style: TextStyle(
                    color: _isCompleted ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Category badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getCategoryColor(_category).withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _category,
                style: TextStyle(
                  color: _getCategoryColor(_category),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'Title',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            _isEditing
                ? TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            )
                : Text(
              widget.todo.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            _isEditing
                ? TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            )
                : Text(
              widget.todo.description.isEmpty
                  ? 'No description provided'
                  : widget.todo.description,
              style: TextStyle(
                fontSize: 16,
                color: widget.todo.description.isEmpty ? Colors.grey : null,
              ),
            ),
            const SizedBox(height: 24),

            // Due date
            const Text(
              'Due Date',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isEditing ? Colors.grey : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getDueStatusText(),
                      style: TextStyle(
                        color: _dueDate == null
                            ? Colors.grey
                            : (_getDueStatusText().contains('Overdue')
                            ? Colors.red
                            : null),
                        fontSize: 16,
                      ),
                    ),
                    if (_isEditing) const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Category selector
            if (_isEditing) ...[
              const Text(
                'Category',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                value: _category,
                items: ['Personal', 'Work', 'School', 'Urgent'].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _category = newValue;
                    });
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  } }