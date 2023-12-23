import 'package:flutter/material.dart';
import 'package:todoapp/screens/authforms.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Authentication"),
        centerTitle: true,
      ),
      body: const AuthForm()
    );
  }
}
