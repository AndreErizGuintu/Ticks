import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo/Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF007AFF),
                        Color(0xFF5856D6),
                      ],
                    ),
                  ),
                  child: Icon(
                    CupertinoIcons.ticket,
                    size: 50,
                    color: CupertinoColors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Register to get started',
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
                const SizedBox(height: 40),
                // Username field
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: CupertinoColors.systemBackground,
                  ),
                  child: CupertinoTextField(
                    controller: _usernameController,
                    placeholder: 'Username',
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.transparent,
                    ),
                    style: TextStyle(
                      color: CupertinoColors.black,
                    ),
                    placeholderStyle: TextStyle(
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Password field
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: CupertinoColors.systemBackground,
                  ),
                  child: CupertinoTextField(
                    controller: _passwordController,
                    placeholder: 'Password',
                    obscureText: true,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.transparent,
                    ),
                    style: TextStyle(
                      color: CupertinoColors.black,
                    ),
                    placeholderStyle: TextStyle(
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Register button
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    color: Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(12),
                    onPressed: () {
                      // Get the Hive box
                      final box = Hive.box('auth');
                      
                      // Save username and password
                      // TODO: Add password hashing here before storing in production
                      box.put('username', _usernameController.text);
                      box.put('password', _passwordController.text);
                      
                      // Navigate back to Login page (restart app to show LoginPage)
                      Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const ConcertApp(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
