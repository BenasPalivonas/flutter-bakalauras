import 'package:flutter/material.dart';
import 'package:ui/services/api_service.dart';
import 'package:ui/services/local_notifications.dart';

import 'menu.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LocalNotificationService.initilize(context);

    return Scaffold(
        body: Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              hintText: 'Username',
              icon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              hintText: 'Password',
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () async {
              // if (_formKey.currentState!.validate()) {
              var body = {
                'username': _usernameController.text.toString(),
                'password': _passwordController.text.toString()
              };
              var answer = (await ApiService().Login(body));
              if (answer == true) {
                Navigator.push(
                    (context),
                    MaterialPageRoute(
                        builder: (context) => const HomePage(
                              selectedIndex: 0,
                            )));
              } else {
                _showSnackbar(context, 'Failed to login');
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    ));
  }
}

void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}
