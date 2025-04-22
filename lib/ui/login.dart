import 'package:flutter/material.dart';
import 'package:todo_list_app/ui/home.dart';

class LoginScreen extends StatefulWidget
{
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen>
{
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  color: Colors.white.withOpacity(0.95),
                  child: Padding(padding: const EdgeInsets.all(24.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline, size: 80, color: Colors.indigo,),
                            SizedBox(height: 15),
                            Text('Welcome to CheckMe',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                              color: Colors.indigo[900]),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Email required';
                                if(!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)){
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                              onSaved: (value) => email = value!,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if(value == null || value.isEmpty) return 'Password required';
                                if(value.length < 6) return 'Minimum 6 characters';
                                return null;
                              },
                              onSaved: (value) => password = value!,
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 15,
                                ),
                                shape : RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                ),

                              ),
                              onPressed: ()
                              {
                                if(_formKey.currentState!.validate()){
                                  _formKey.currentState!.save();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen(userEmail: email),
                                    ),
                                  );
                                }
                              },
                              child: Text('Login',
                                style: TextStyle(fontSize: 18,color: Colors.white),
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                ),

              ),
            ),
          ),

        ]

      ),
    );
  }
}