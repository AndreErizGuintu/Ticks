import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'homepage.dart';
import 'purchase_history_screen.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print("✅ .env file loaded successfully");
  } catch (e) {
    print("⚠️ Warning: .env file not found or failed to load: $e");
    print("Using fallback API keys for development");
  }

  runApp(const ConcertApp());
}

class ConcertApp extends StatefulWidget {
  const ConcertApp({super.key});

  @override
  State<ConcertApp> createState() => _ConcertAppState();
}

class _ConcertAppState extends State<ConcertApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: Color(0xFF007AFF),
        barBackgroundColor: _isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
        scaffoldBackgroundColor: _isDarkMode ? Color(0xFF000000) : CupertinoColors.systemGroupedBackground,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: 'SF Pro Display',
          ),
        ),
      ),
      home: MainScreen(
        isDarkMode: _isDarkMode,
        onDarkModeChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onDarkModeChanged;

  const MainScreen({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _cartCount = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: widget.isDarkMode ? Color(0xFF000000) : CupertinoColors.systemGroupedBackground,
      tabBar: CupertinoTabBar(
        backgroundColor: widget.isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
        activeColor: Color(0xFF007AFF),
        inactiveColor: widget.isDarkMode ? CupertinoColors.systemGrey : CupertinoColors.secondaryLabel,
        border: Border(
          top: BorderSide(
            color: widget.isDarkMode ? Color(0xFF2C2C2E) : Color(0xFFC6C6C8),
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
              isDarkMode: widget.isDarkMode,
              onBuyTicket: (concert) {
                setState(() {
                  _cartCount++;
                });
              },
            );
          case 1:
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                backgroundColor: widget.isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
                middle: Text(
                  "My Tickets",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: Container(
                color: widget.isDarkMode ? Color(0xFF000000) : CupertinoColors.systemGroupedBackground,
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
                          color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
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
                          color: widget.isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
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
                              color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dates[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: widget.isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                ),
                              ),
                              Text(
                                venues[index],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: widget.isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            CupertinoIcons.chevron_forward,
                            size: 16,
                            color: widget.isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
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
                          color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
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
                          color: widget.isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
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
                              color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                            ),
                          ),
                          subtitle: Text(
                            dates[index],
                            style: TextStyle(
                              fontSize: 14,
                              color: widget.isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
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
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                backgroundColor: widget.isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
                middle: Text(
                  "Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: Container(
                color: widget.isDarkMode ? Color(0xFF000000) : CupertinoColors.systemGroupedBackground,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),

                    // Profile Header
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: widget.isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
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
                            "Alex Johnson",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Concert Enthusiast",
                            style: TextStyle(
                              color: CupertinoColors.secondaryLabel,
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
                                      "Concerts",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: CupertinoColors.secondaryLabel,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "8",
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
                                      "Tickets",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: CupertinoColors.secondaryLabel,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "12",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF30D158),
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
                                      "Spent",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: CupertinoColors.secondaryLabel,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "₱24.5K",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFF9500),
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
                        color: widget.isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
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
                                color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
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
                                CupertinoIcons.mail,
                                color: Color(0xFF007AFF),
                                size: 22,
                              ),
                            ),
                            title: Text(
                              "Email",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                              ),
                            ),
                            subtitle: Text(
                              "alex.johnson@email.com",
                              style: TextStyle(
                                color: widget.isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                              ),
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
                                color: Color(0xFF30D158).withOpacity(0.1),
                              ),
                              child: Icon(
                                CupertinoIcons.phone,
                                color: Color(0xFF30D158),
                                size: 22,
                              ),
                            ),
                            title: Text(
                              "Phone",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                              ),
                            ),
                            subtitle: Text(
                              "+63 912 345 6789",
                              style: TextStyle(
                                color: widget.isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                              ),
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
                                color: Color(0xFFAF52DE).withOpacity(0.1),
                              ),
                              child: Icon(
                                CupertinoIcons.location,
                                color: Color(0xFFAF52DE),
                                size: 22,
                              ),
                            ),
                            title: Text(
                              "Location",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                              ),
                            ),
                            subtitle: Text(
                              "Manila, Philippines",
                              style: TextStyle(
                                color: widget.isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
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
                        color: widget.isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
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
                                color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
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
                                color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                              ),
                            ),
                            subtitle: Text(
                              "Manage your notifications",
                              style: TextStyle(
                                color: widget.isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                              ),
                            ),
                            trailing: Icon(
                              CupertinoIcons.chevron_forward,
                              size: 18,
                              color: widget.isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
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
                                    isDarkMode: widget.isDarkMode,
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
                                color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                              ),
                            ),
                            subtitle: Text(
                              "View all your purchases",
                              style: TextStyle(
                                color: widget.isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                              ),
                            ),
                            trailing: Icon(
                              CupertinoIcons.chevron_forward,
                              size: 18,
                              color: widget.isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
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
                                color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                              ),
                            ),
                            subtitle: Text(
                              "Manage your payment options",
                              style: TextStyle(
                                color: widget.isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                              ),
                            ),
                            trailing: Icon(
                              CupertinoIcons.chevron_forward,
                              size: 18,
                              color: widget.isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
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
                backgroundColor: widget.isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
                middle: Text(
                  "Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: Container(
                color: widget.isDarkMode ? Color(0xFF000000) : CupertinoColors.systemGroupedBackground,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),

                    // Appearance Settings
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: widget.isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
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
                                color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
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
                                widget.isDarkMode ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill,
                                color: Color(0xFF007AFF),
                                size: 22,
                              ),
                            ),
                            title: Text(
                              "Dark Mode",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                              ),
                            ),
                            subtitle: Text(
                              widget.isDarkMode ? "Enabled" : "Disabled",
                              style: TextStyle(
                                color: widget.isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                fontSize: 14,
                              ),
                            ),
                            trailing: CupertinoSwitch(
                              value: widget.isDarkMode,
                              onChanged: widget.onDarkModeChanged,
                              activeColor: Color(0xFF007AFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // About Section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: widget.isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.systemBackground,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                            child: Text(
                              "About",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                              ),
                            ),
                          ),
                          CupertinoListTile(
                            backgroundColor: Colors.transparent,
                            onTap: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (context) => CupertinoActionSheet(
                                  title: Text("Developers"),
                                  message: Text("This app was developed by:"),
                                  actions: [
                                    CupertinoActionSheetAction(
                                      onPressed: () {},
                                      child: Text("Christian"),
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () {},
                                      child: Text("Andre"),
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () {},
                                      child: Text("Lance"),
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () {},
                                      child: Text("Reyn"),
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () {},
                                      child: Text("Francis"),
                                    ),
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Close"),
                                  ),
                                ),
                              );
                            },
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFF5AC8FA).withOpacity(0.1),
                              ),
                              child: Icon(
                                CupertinoIcons.person_2,
                                color: Color(0xFF5AC8FA),
                                size: 22,
                              ),
                            ),
                            title: Text(
                              "About",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                              ),
                            ),
                            subtitle: Text(
                              "View developers",
                              style: TextStyle(
                                color: widget.isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
                                fontSize: 14,
                              ),
                            ),
                            trailing: Icon(
                              CupertinoIcons.chevron_forward,
                              size: 18,
                              color: widget.isDarkMode ? Color(0xFFAEAEB2) : CupertinoColors.secondaryLabel,
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
  }
}
