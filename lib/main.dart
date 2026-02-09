import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'homepage.dart';
import 'purchase_history_screen.dart';
import 'register_page.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';


final ValueNotifier<bool> darkModeNotifier = ValueNotifier<bool>(false);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('auth');

  // Initialize dotenv with proper error handling
  try {
    await dotenv.load(fileName: ".env");
    print("✅ .env file loaded successfully");
  } catch (e) {
    print("⚠️ Warning: .env file not found or failed to load: $e");
    print("Using fallback API keys for development");
    // Initialize dotenv with empty map to prevent NotInitializedError
    dotenv.testLoad(fileInput: '');
  }

  runApp(const ConcertApp());
}

class ConcertApp extends StatelessWidget {
  const ConcertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDarkMode, _) {
        return CupertinoApp(
          debugShowCheckedModeBanner: false,
          theme: CupertinoThemeData(
            brightness: isDarkMode ? Brightness.dark : Brightness.light,
            primaryColor: Color(0xFF007AFF),
            barBackgroundColor: isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
            scaffoldBackgroundColor: isDarkMode ? Color(0xFF000000) : CupertinoColors.systemGroupedBackground,
            textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(
                fontFamily: 'SF Pro Display',
              ),
            ),
          ),
          home: const LoginPage(),
        );
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  bool _hasCredentials = false;
  bool _biometricsEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkIfShouldShowRegister();
    _loadAuthFlags();
  }

  void _loadAuthFlags() {
    final box = Hive.box('auth');
    final username = box.get('username');
    final password = box.get('password');

    setState(() {
      _hasCredentials = username != null && password != null;
      _biometricsEnabled = box.get('biometricsEnabled', defaultValue: false) == true;
    });

    // If credentials exist (normal returning user), prefill username.
    // (Password is intentionally not auto-filled for normal login.)
    if (username is String && username.isNotEmpty) {
      _usernameController.text = username;
    }
  }

  void _checkIfShouldShowRegister() async {
    final box = Hive.box('auth');
    final username = box.get('username');
    final password = box.get('password');

    // If no credentials exist, navigate to Register page
    if (username == null || password == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => const RegisterPage()),
        );
      });
    }
  }

  void _signIn() {
    final box = Hive.box('auth');
    final storedUsername = box.get('username');
    final storedPassword = box.get('password');

    if (_usernameController.text == storedUsername &&
        _passwordController.text == storedPassword) {
      // Login successful - navigate to MainScreen
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid Username or Password';
      });
    }
  }

  void _resetData() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Reset Data'),
        content: const Text(
            'Are you sure you want to reset your account data? This will delete your username, password, purchase history, and all related data.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              final box = Hive.box('auth');
              // Delete ALL data
              box.delete('username');
              box.delete('password');
              box.delete('totalSpent');
              box.delete('purchaseHistory');
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(builder: (context) => const RegisterPage()),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDarkMode, _) {
        return CupertinoPageScaffold(
          backgroundColor:
              isDarkMode ? Color(0xFF000000) : CupertinoColors.systemGroupedBackground,
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
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Username field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
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
                          color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                        ),
                        placeholderStyle: TextStyle(
                          color:
                              isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Password field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
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
                          color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                        ),
                        placeholderStyle: TextStyle(
                          color:
                              isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Error message
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(
                            color: CupertinoColors.systemRed,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    // Sign In button
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        color: Color(0xFF007AFF),
                        borderRadius: BorderRadius.circular(12),
                        onPressed: _signIn,
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // Face ID button (only when username/password exist AND user enabled it in Settings)
                    if (_hasCredentials && _biometricsEnabled) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          color: isDarkMode ? const Color(0xFF1C1C1E) : CupertinoColors.systemGrey5,
                          borderRadius: BorderRadius.circular(12),
                          onPressed: () async {
                            setState(() {
                              _errorMessage = '';
                            });

                            // ENABLE FACE ID WHEN TESTING ON IPHONE
                            // ------------------------------------------------------------
                            // NOTE:
                            // - iOS requires Face ID usage description in Info.plist.
                            // - Face ID won't work on simulator.
                            // - Android will use fingerprint/biometrics depending on device.
                            //
                            final auth = LocalAuthentication();
                            final canCheck = await auth.canCheckBiometrics;
                            final supported = await auth.isDeviceSupported();
                            if (!canCheck || !supported) {
                              setState(() {
                                _errorMessage = 'Biometrics not available on this device';
                              });
                              return;
                            }

                            // (Optional) check enrolled biometrics types
                            // final types = await auth.getAvailableBiometrics();
                            // final hasFaceId = types.contains(BiometricType.face);

                            final didAuth = await auth.authenticate(
                              localizedReason: 'Use Face ID to sign in',
                              biometricOnly: true,
                            );


                            if (!didAuth) return;

                            // If Face ID succeeds, auto-fill and sign-in.
                            final box = Hive.box('auth');
                            _usernameController.text = (box.get('username') ?? '') as String;
                            _passwordController.text = (box.get('password') ?? '') as String;
                            _signIn();
                            // ------------------------------------------------------------

                            // For now (biometric disabled in code), do nothing.
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.person_crop_circle_badge_checkmark,
                                size: 20,
                                color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Sign in with Face ID',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                    // Reset Data button
                    CupertinoButton(
                      onPressed: _resetData,
                      child: Text(
                        'Reset Data',
                        style: TextStyle(
                          color: CupertinoColors.systemRed,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _cartCount = 0;

  bool _biometricsEnabled = false;

  @override
  void initState() {
    super.initState();
    final box = Hive.box('auth');
    _biometricsEnabled = box.get('biometricsEnabled', defaultValue: false) == true;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDarkMode, _) {
        return CupertinoTabScaffold(
          backgroundColor:
              isDarkMode ? Color(0xFF000000) : CupertinoColors.systemGroupedBackground,
          tabBar: CupertinoTabBar(
            backgroundColor:
                isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
            activeColor: Color(0xFF007AFF),
            inactiveColor: isDarkMode ? CupertinoColors.systemGrey : CupertinoColors.secondaryLabel,
            border: Border(
              top: BorderSide(
                color: isDarkMode ? Color(0xFF2C2C2E) : Color(0xFFC6C6C8),
                width: 0.5,
              ),
            ),
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.music_note),
                label: "Concerts",
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.ticket),
                label: "Tickets",
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                label: "Profile",
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.settings),
                label: "Settings",
              ),
            ],
          ),
          tabBuilder: (context, index) {
            switch (index) {
              case 0:
                return Homepage(
                  isDarkMode: isDarkMode,
                  onBuyTicket: (concert) {
                    setState(() {
                      _cartCount++;
                    });
                  },
                );
              case 1:
                return CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    backgroundColor:
                        isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
                    middle: const Text(
                      "My Tickets",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  child: Container(
                    color: isDarkMode
                        ? const Color(0xFF000000)
                        : CupertinoColors.systemGroupedBackground,
                    child: ListView(
                      children: [
                        const SizedBox(height: 20),
                        // Header Card
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF007AFF),
                                Color(0xFF5856D6),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Concert Journey",
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "3 upcoming • 5 attended",
                                style: TextStyle(
                                  color: CupertinoColors.white.withOpacity(0.9),
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Total Spent",
                                          style: TextStyle(
                                            color: CupertinoColors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "₱24,500",
                                          style: TextStyle(
                                            color: CupertinoColors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: CupertinoColors.white.withOpacity(0.3),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Next Event",
                                          style: TextStyle(
                                            color: CupertinoColors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Mar 15",
                                          style: TextStyle(
                                            color: CupertinoColors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Upcoming Events",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(2, (index) {
                          List concerts = ["Taylor Swift - The Eras Tour", "Bruno Mars - 24K Magic"];
                          List dates = ["March 15, 2024 • 7:00 PM", "April 22, 2024 • 8:00 PM"];
                          List venues = ["Mall of Asia Arena", "Smart Araneta Coliseum"];
                          List colors = [Color(0xFFFF2D55), Color(0xFF32D74B)];

                          return Container(
                            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
                            ),
                            child: CupertinoListTile(
                              backgroundColor: Colors.transparent,
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: colors[index].withOpacity(0.2),
                                ),
                                child: Icon(
                                  CupertinoIcons.ticket,
                                  color: colors[index],
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                concerts[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dates[index],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                    ),
                                  ),
                                  Text(
                                    venues[index],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                CupertinoIcons.chevron_forward,
                                size: 16,
                                color: isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Past Events",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(3, (index) {
                          List concerts = ["Ed Sheeran", "Ariana Grande", "The Weeknd"];
                          List dates = ["Nov 5, 2023", "Feb 18, 2023", "Sep 14, 2022"];

                          return Container(
                            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
                            ),
                            child: CupertinoListTile(
                              backgroundColor: Colors.transparent,
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: CupertinoColors.systemGrey4.withOpacity(0.3),
                                ),
                                child: Icon(
                                  CupertinoIcons.checkmark_alt,
                                  color: CupertinoColors.systemGrey2,
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                concerts[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                                ),
                              ),
                              subtitle: Text(
                                dates[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              case 2:
                // Read data from Hive
                final box = Hive.box('auth');
                final username = box.get('username', defaultValue: 'Guest');
                final totalSpent = box.get('totalSpent', defaultValue: 0.0) as double;
                final purchaseHistory = box.get('purchaseHistory', defaultValue: []) as List;

                // Calculate stats
                final purchaseCount = purchaseHistory.length;
                final totalSpentFormatted = totalSpent >= 1000
                    ? '₱${(totalSpent / 1000).toStringAsFixed(1)}K'
                    : '₱${totalSpent.toStringAsFixed(0)}';

                return CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    backgroundColor:
                        isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
                    middle: const Text(
                      "Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  child: Container(
                    color: isDarkMode
                        ? const Color(0xFF000000)
                        : CupertinoColors.systemGroupedBackground,
                    child: ListView(
                      children: [
                        const SizedBox(height: 20),

                        // Profile Header
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
                          ),
                          child: Column(
                            children: [
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
                                  CupertinoIcons.person_fill,
                                  size: 50,
                                  color: CupertinoColors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                username,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Concert Enthusiast",
                                style: TextStyle(
                                  color: isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Purchases",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "$purchaseCount",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF007AFF),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 30,
                                    color: CupertinoColors.separator,
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Total Spent",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          totalSpentFormatted,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF30D158),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Account Info
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                                child: Text(
                                  "Account Information",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                                  ),
                                ),
                              ),
                              CupertinoListTile(
                                backgroundColor: Colors.transparent,
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFF007AFF).withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.person,
                                    color: Color(0xFF007AFF),
                                    size: 22,
                                  ),
                                ),
                                title: Text(
                                  "Username",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  username,
                                  style: TextStyle(
                                    color: isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Quick Actions
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                                child: Text(
                                  "Quick Actions",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                                  ),
                                ),
                              ),
                              CupertinoListTile(
                                backgroundColor: Colors.transparent,
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFFF9500).withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.bell,
                                    color: Color(0xFFFF9500),
                                    size: 22,
                                  ),
                                ),
                                title: Text(
                                  "Notifications",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  "Manage your notifications",
                                  style: TextStyle(
                                    color: isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                  ),
                                ),
                                trailing: Icon(
                                  CupertinoIcons.chevron_forward,
                                  size: 18,
                                  color: isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                ),
                              ),
                              Container(
                                height: 0.5,
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                color: CupertinoColors.separator,
                              ),
                              CupertinoListTile(
                                backgroundColor: Colors.transparent,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => PurchaseHistoryScreen(
                                        isDarkMode: isDarkMode,
                                      ),
                                    ),
                                  );
                                },
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFF30D158).withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.bag,
                                    color: Color(0xFF30D158),
                                    size: 22,
                                  ),
                                ),
                                title: Text(
                                  "Purchase History",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  "View all your purchases",
                                  style: TextStyle(
                                    color: isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                  ),
                                ),
                                trailing: Icon(
                                  CupertinoIcons.chevron_forward,
                                  size: 18,
                                  color: isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                ),
                              ),
                              Container(
                                height: 0.5,
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                color: CupertinoColors.separator,
                              ),
                              CupertinoListTile(
                                backgroundColor: Colors.transparent,
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFFF3B30).withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.creditcard,
                                    color: Color(0xFFFF3B30),
                                    size: 22,
                                  ),
                                ),
                                title: Text(
                                  "Payment Methods",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  "Manage your payment options",
                                  style: TextStyle(
                                    color: isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                  ),
                                ),
                                trailing: Icon(
                                  CupertinoIcons.chevron_forward,
                                  size: 18,
                                  color: isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Logout button
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xFF007AFF),
                                ),
                                child: CupertinoButton(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  onPressed: () {
                                    // Simple logout: just navigate back to Login page.
                                    // Does NOT delete data or reset anything.
                                    Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(builder: (context) => const LoginPage()),
                                    );
                                  },
                                  child: Text(
                                    "Logout",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: CupertinoColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                );
              default:
                return CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    backgroundColor:
                        isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
                    middle: const Text(
                      "Settings",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  child: Container(
                    color: isDarkMode
                        ? const Color(0xFF000000)
                        : CupertinoColors.systemGroupedBackground,
                    child: ListView(
                      children: [
                        const SizedBox(height: 20),

                        // Appearance Settings
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: isDarkMode
                                ? const Color(0xFF1C1C1E)
                                : CupertinoColors.systemBackground,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                                child: Text(
                                  "Appearance",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                                  ),
                                ),
                              ),
                              CupertinoListTile(
                                backgroundColor: Colors.transparent,
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFF007AFF).withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    isDarkMode
                                        ? CupertinoIcons.moon_fill
                                        : CupertinoIcons.sun_max_fill,
                                    color: const Color(0xFF007AFF),
                                    size: 22,
                                  ),
                                ),
                                title: Text(
                                  "Dark Mode",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  isDarkMode ? "Enabled" : "Disabled",
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? const Color(0xFFAEAEB2)
                                        : CupertinoColors.secondaryLabel,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: CupertinoSwitch(
                                  value: isDarkMode,
                                  onChanged: (value) {
                                    // This is the only place that updates dark mode.
                                    // Because the whole app listens to darkModeNotifier,
                                    // the switch will never get out of sync.
                                    darkModeNotifier.value = value;
                                  },
                                  activeColor: const Color(0xFF007AFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Biometrics Settings
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: isDarkMode
                                ? const Color(0xFF1C1C1E)
                                : CupertinoColors.systemBackground,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                                child: Text(
                                  "Biometrics",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                                  ),
                                ),
                              ),
                              CupertinoListTile(
                                backgroundColor: Colors.transparent,
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFF007AFF).withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.person_crop_circle_badge_checkmark,
                                    color: Color(0xFF007AFF),
                                    size: 22,
                                  ),
                                ),
                                title: Text(
                                  "Face ID",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  "Enable or disable Face ID sign-in",
                                  style: TextStyle(
                                    color: isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                  ),
                                ),
                                trailing: CupertinoSwitch(
                                  value: _biometricsEnabled,
                                  onChanged: (value) {
                                    final box = Hive.box('auth');
                                    box.put('biometricsEnabled', value);

                                    setState(() {
                                      _biometricsEnabled = value;
                                    });
                                  },
                                  activeColor: const Color(0xFF007AFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                );
            }
          },
        );
      },
    );
  }
}
