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
  bool _obscurePassword = true;
  String _errorMessage = '';

  void _register() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Validation
    if (username.isEmpty && password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter username and password';
      });
      return;
    }

    if (username.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a username';
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a password';
      });
      return;
    }

    if (username.length < 3) {
      setState(() {
        _errorMessage = 'Username must be at least 3 characters';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters';
      });
      return;
    }

    // Get the Hive box
    final box = Hive.box('auth');

    // Save username and password
    // TODO: Add password hashing here before storing in production
    box.put('username', username);
    box.put('password', password);

    // Navigate back to Login page (restart app to show LoginPage)
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => const ConcertApp(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF000000),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // App Logo/Icon with shadow
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF007AFF),
                        Color(0xFF5856D6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF007AFF).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    CupertinoIcons.ticket_fill,
                    size: 60,
                    color: CupertinoColors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: CupertinoColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign up to get started with Ticks',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFF8E8E93),
                  ),
                ),
                const SizedBox(height: 50),

                // Error message
                if (_errorMessage.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: CupertinoColors.systemRed.withValues(alpha: 0.1),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.exclamationmark_circle_fill,
                          color: CupertinoColors.systemRed,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: CupertinoColors.systemRed,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Username field with icon
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Color(0xFF2C2C2E),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 12),
                        child: Icon(
                          CupertinoIcons.person_fill,
                          color: Color(0xFF8E8E93),
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: CupertinoTextField(
                          controller: _usernameController,
                          placeholder: 'Username',
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          style: TextStyle(
                            fontSize: 17,
                            color: CupertinoColors.white,
                          ),
                          placeholderStyle: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF8E8E93),
                          ),
                          onChanged: (value) {
                            if (_errorMessage.isNotEmpty) {
                              setState(() {
                                _errorMessage = '';
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Password field with icon and toggle
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Color(0xFF2C2C2E),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 12),
                        child: Icon(
                          CupertinoIcons.lock_fill,
                          color: Color(0xFF8E8E93),
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: CupertinoTextField(
                          controller: _passwordController,
                          placeholder: 'Password',
                          obscureText: _obscurePassword,
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          style: TextStyle(
                            fontSize: 17,
                            color: CupertinoColors.white,
                          ),
                          placeholderStyle: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF8E8E93),
                          ),
                          onChanged: (value) {
                            if (_errorMessage.isNotEmpty) {
                              setState(() {
                                _errorMessage = '';
                              });
                            }
                          },
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        child: Icon(
                          _obscurePassword
                              ? CupertinoIcons.eye_slash_fill
                              : CupertinoIcons.eye_fill,
                          color: Color(0xFF8E8E93),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Register button with gradient
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF007AFF),
                        Color(0xFF5856D6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF007AFF).withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(14),
                    onPressed: _register,
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
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
