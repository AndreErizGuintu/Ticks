// homepage.dart (Perfect iPhone Sizes)
import 'dart:async';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'services/purchase_store.dart';

class Homepage extends StatefulWidget {
  final bool isDarkMode;
  final Function(Map<String, dynamic>) onBuyTicket;

  const Homepage({
    super.key,
    required this.isDarkMode,
    required this.onBuyTicket,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<Map<String, dynamic>> concerts = [
    {
      'artist': 'TAYLOR SWIFT',
      'tour': 'THE ERAS TOUR',
      'date': 'March 15-16, 2024',
      'time': '7:00 PM',
      'venue': 'Mall of Asia Arena',
      'location': 'Pasay City, Philippines',
      'price': 4500,
      'color': Color(0xFFFF6B8B),
      'tickets_left': 42,
      'description': 'Experience the spectacular journey through all of Taylor Swift\'s musical eras in this unforgettable concert featuring hits from every album.',
      'duration': '3 hours',
      'genre': 'Pop',
      'seats_available': 'VIP, Gold, Silver',
      'ticket_types': [
        {'name': 'VIP', 'price': 12000, 'perks': 'Front Row, Meet & Greet, Merch Pack'},
        {'name': 'Gold', 'price': 8000, 'perks': 'Premium Seating, Early Entry'},
        {'name': 'Silver', 'price': 4500, 'perks': 'Standard Seating'},
      ],
      'images': [
        'https://i.pinimg.com/1200x/51/8d/86/518d860985b35619ec72fd3f06c3bddd.jpg',
        'https://i.pinimg.com/736x/dd/d7/7b/ddd77bd4c8d00a0ed4ebcb83cca2355c.jpg',
        'https://i.pinimg.com/1200x/24/dd/52/24dd52b4f1b37710e4c1c8e48b5d457b.jpg',
      ],
      'highlights': [
        'All albums covered',
        'Spectacular stage design',
        'Special guest appearances',
        'Exclusive merchandise'
      ]
    },
    {
      'artist': 'LANY',
      'tour': '24K MAGIC WORLD TOUR',
      'date': 'April 22, 2024',
      'time': '8:00 PM',
      'venue': 'Smart Araneta Coliseum',
      'location': 'Quezon City, Philippines',
      'price': 3800,
      'color': Color(0xFF00C2FF),
      'tickets_left': 28,
      'description': 'Join Lany for an evening of pure funk, soul, and pop perfection in his 24K Magic World Tour featuring all his chart-topping hits.',
      'duration': '2.5 hours',
      'genre': 'Funk/Pop',
      'seats_available': 'VIP, Lower Box, Upper Box',
      'ticket_types': [
        {'name': 'VIP', 'price': 9500, 'perks': 'Front Row, Exclusive Merch'},
        {'name': 'Lower Box', 'price': 6000, 'perks': 'Great View, Comfortable Seats'},
        {'name': 'Upper Box', 'price': 3800, 'perks': 'Standard Seating'},
      ],
      'images': [
        'https://i.pinimg.com/1200x/ed/27/61/ed276122b0f146ac1cabfc704346aef9.jpg',
        'https://i.pinimg.com/1200x/56/8b/e7/568be7d399297c65d89332d2d7c69f30.jpg',
        'https://i.pinimg.com/1200x/79/fe/c2/79fec270f7d5dd7f062bff9e87d23e89.jpg',
      ],
      'highlights': [
        'Live band performance',
        'Dance routines',
        'Classic hits medley',
        'Interactive audience moments'
      ]
    },
    {
      'artist': 'COLDPLAY',
      'tour': 'MUSIC OF THE SPHERES',
      'date': 'May 10-11, 2024',
      'time': '7:30 PM',
      'venue': 'Philippine Arena',
      'location': 'Bocaue, Bulacan',
      'price': 5200,
      'color': Color(0xFF00D4AA),
      'tickets_left': 15,
      'description': 'Witness Coldplay\'s cosmic journey through their latest album in a spectacular visual and musical experience with stunning light displays.',
      'duration': '2 hours 45 mins',
      'genre': 'Alternative Rock',
      'seats_available': 'VIP, Patron, General Admission',
      'ticket_types': [
        {'name': 'VIP', 'price': 15000, 'perks': 'Front Stage, Soundcheck Access, Limited Edition Kit'},
        {'name': 'Patron', 'price': 8500, 'perks': 'Premium Seating, Early Entry'},
        {'name': 'General Admission', 'price': 5200, 'perks': 'Standard Seating'},
      ],
      'images': [
        'https://i.pinimg.com/736x/6d/47/ad/6d47ad6bc652dc71c0de78556ba019f4.jpg',
        'https://i.pinimg.com/1200x/dd/71/0a/dd710a08747c250deac51c4a58639a75.jpg',
        'https://i.pinimg.com/1200x/64/00/33/64003374d278e5bb39e7163238ad8355.jpg',

      ],
      'highlights': [
        'LED wristbands',
        'Spectacular light show',
        'Acoustic set',
        'Environmental themes'
      ]
    },
    {
      'artist': 'BLACKPINK',
      'tour': 'BORN PINK WORLD TOUR',
      'date': 'June 18-19, 2024',
      'time': '8:00 PM',
      'venue': 'Mall of Asia Arena',
      'location': 'Pasay City, Philippines',
      'price': 6800,
      'color': Color(0xFFFF9500),
      'tickets_left': 8,
      'description': 'K-pop sensation BLACKPINK brings their electrifying performance to Manila in their Born Pink World Tour featuring powerful choreography.',
      'duration': '3 hours',
      'genre': 'K-Pop',
      'seats_available': 'VIP, Standing, Seated',
      'ticket_types': [
        {'name': 'VIP', 'price': 18000, 'perks': 'Soundcheck, Hi-Touch, Exclusive Merch'},
        {'name': 'Standing', 'price': 10000, 'perks': 'Dance Floor Access'},
        {'name': 'Seated', 'price': 6800, 'perks': 'Reserved Seating'},
      ],
      'images': [
        'https://i.pinimg.com/736x/79/1b/3e/791b3e4630c1ae0a2746bbafbe2b64ec.jpg',
        'https://i.pinimg.com/736x/91/23/c5/9123c5ebcf0eeac7b652795cb394da56.jpg',
        'https://i.pinimg.com/736x/73/15/2b/73152b07becb9d29b525d6193ddd651f.jpg',
      ],
      'highlights': [
        'Group choreography',
        'Solo performances',
        'Fan interactions',
        'Special stage effects'
      ]
    },
  ];

  // Load API key from environment variables (fallback to development key for testing)
  final String apiKey = dotenv.env['XENDIT_API_KEY'] ?? "xnd_development_IgiQCiy0Q9Er1xrrPUXZPt6C7N7UKZW0SUWaG6MVQs19TxlV7LLbcXKVkcJU18m";

  @override
  void initState() {
    super.initState();
    print("[Homepage] Initializing...");
    print("[Homepage] API Key from dotenv: ${dotenv.env['XENDIT_API_KEY'] != null ? 'LOADED' : 'NULL'}");
    print("[Homepage] Using API key (first 30 chars): ${apiKey.substring(0, apiKey.length > 30 ? 30 : apiKey.length)}...");
    print("[Homepage] Full key length: ${apiKey.length} characters");
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final backgroundColor = widget.isDarkMode ? Color(0xFF000000) : Color(0xFFF2F2F7);
    final cardColor = widget.isDarkMode ? Color(0xFF1C1C1E) : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = widget.isDarkMode ? Color(0xFF8E8E93) : Color(0xFF8E8E93);
    final shadowColor = widget.isDarkMode ? Colors.transparent : Colors.black.withValues(alpha: 0.05);

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: widget.isDarkMode ? Color(0xFF1C1C1E) : Colors.white,
        middle: Text(
          "Concerts",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            // Hero Banner
            Container(
              height: 180,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.network(
                      'https://i.pinimg.com/1200x/62/3b/39/623b39f03d312ce6b8f33d213ac806d5.jpg',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: widget.isDarkMode ? Color(0xFF1C1C1E) : Color(0xFFF2F2F7),
                          child: Center(child: CupertinoActivityIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                widget.isDarkMode ? Color(0xFF0A84FF) : Color(0xFF007AFF),
                                widget.isDarkMode ? Color(0xFF5E5CE6) : Color(0xFF5856D6),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.music_note,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Live Music',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: widget.isDarkMode ? 0.5 : 0.3),
                          Colors.black.withValues(alpha: widget.isDarkMode ? 0.2 : 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.isDarkMode
                                ? Colors.white.withValues(alpha: 0.15)
                                : Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'NOW BOOKING',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: widget.isDarkMode ? Colors.white : Color(0xFF007AFF),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Epic Concerts\nComing Soon',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.1,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black.withValues(alpha: 0.5),
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Stats Cards
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: cardColor,
                        boxShadow: [BoxShadow(color: shadowColor, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF007AFF).withValues(alpha: widget.isDarkMode ? 0.2 : 0.1),
                            ),
                            child: Icon(
                              CupertinoIcons.ticket,
                              color: Color(0xFF007AFF),
                              size: 18,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '4 Shows',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 11,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: cardColor,
                        boxShadow: [BoxShadow(color: shadowColor, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFF9500).withValues(alpha: widget.isDarkMode ? 0.2 : 0.1),
                            ),
                            child: Icon(
                              CupertinoIcons.clock_fill,
                              color: Color(0xFFFF9500),
                              size: 18,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Limited',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          Text(
                            'Tickets',
                            style: TextStyle(
                              fontSize: 11,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: cardColor,
                        boxShadow: [BoxShadow(color: shadowColor, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF30D158).withValues(alpha: widget.isDarkMode ? 0.2 : 0.1),
                            ),
                            child: Icon(
                              CupertinoIcons.checkmark_seal_fill,
                              color: Color(0xFF30D158),
                              size: 18,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Secure',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          Text(
                            'Booking',
                            style: TextStyle(
                              fontSize: 11,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Featured Concerts Header
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                "Featured Concerts",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  letterSpacing: -0.5,
                ),
              ),
            ),

            // Concerts List
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                children: concerts.map((concert) => buildConcertCard(
                  concert,
                  isDarkMode: widget.isDarkMode,
                )).toList(),
              ),
            ),

            // Payment Methods Section
            Container(
              padding: EdgeInsets.all(16),
              color: widget.isDarkMode ? Color(0xFF1C1C1E) : Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Secure Payment Partners",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "100% safe and encrypted transactions",
                    style: TextStyle(
                      fontSize: 13,
                      color: secondaryTextColor,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Payment Logos
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: widget.isDarkMode ? Color(0xFF2C2C2E) : Color(0xFFF2F2F7),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPaymentLogo(
                          'GCash',
                          widget.isDarkMode,
                          'https://i.pinimg.com/1200x/23/3d/0d/233d0d4c5ecda418ec75274ee2c56aa4.jpg',
                        ),
                        _buildPaymentLogo(
                          'BDO',
                          widget.isDarkMode,
                          'https://i.pinimg.com/1200x/2f/de/54/2fde5444c3c5c7ab4c63e8b4c19f4b44.jpg',
                        ),
                        _buildPaymentLogo(
                          'PayMaya',
                          widget.isDarkMode,
                          'https://i.pinimg.com/736x/cc/b0/7b/ccb07b15d3061701a2a40d72aaff219a.jpg',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Security Info
                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.isDarkMode
                            ? [
                          Color(0xFF0A84FF).withValues(alpha: 0.2),
                          Color(0xFF5E5CE6).withValues(alpha: 0.2),
                        ]
                            : [
                          Color(0xFF007AFF).withValues(alpha: 0.1),
                          Color(0xFF5856D6).withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: widget.isDarkMode
                                  ? [Color(0xFF0A84FF), Color(0xFF5E5CE6)]
                                  : [Color(0xFF007AFF), Color(0xFF5856D6)],
                            ),
                          ),
                          child: Icon(
                            CupertinoIcons.lock_shield_fill,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "PCI DSS Compliant",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Bank-level security for payments",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: secondaryTextColor,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConcertCard(Map<String, dynamic> concert, {
    required bool isDarkMode,
  }) {
    final cardColor = isDarkMode ? Color(0xFF1C1C1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkMode ? Color(0xFF8E8E93) : Color(0xFF8E8E93);
    final shadowColor = isDarkMode ? Colors.transparent : Colors.black.withOpacity(0.05);

    return GestureDetector(
      onTap: () => _showConcertDetails(concert, isDarkMode),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: cardColor,
          boxShadow: [BoxShadow(color: shadowColor, blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Concert Images Slider
            Container(
              height: 160,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: concert['images'].length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          concert['images'][index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: isDarkMode ? Color(0xFF2C2C2E) : Color(0xFFF2F2F7),
                              child: Center(child: CupertinoActivityIndicator()),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.black.withOpacity(0.6) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.ticket,
                            size: 12,
                            color: Color(0xFF007AFF),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${concert['tickets_left']} left',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Concert Info
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Artist and Tour
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: concert['color'],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          concert['artist'] as String,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Text(
                      concert['tour'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: secondaryTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  // Date and Location
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar,
                        size: 16,
                        color: Color(0xFF007AFF),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${concert['date']} • ${concert['time']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.location_solid,
                        size: 16,
                        color: Color(0xFFFF9500),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          concert['venue'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Price and Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'From ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: secondaryTextColor,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '₱',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF007AFF),
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${concert['price']}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF007AFF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(
                            'starting price',
                            style: TextStyle(
                              fontSize: 10,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF007AFF),
                        onPressed: () => _showTicketSelection(concert, isDarkMode),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.ticket_fill,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Tickets',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
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
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentLogo(String name, bool isDarkMode, String imageUrl) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDarkMode ? Color(0xFF2C2C2E) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFF007AFF).withOpacity(isDarkMode ? 0.2 : 0.1),
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.creditcard_fill,
                      color: Color(0xFF007AFF),
                      size: 24,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  void _showConcertDetails(Map<String, dynamic> concert, bool isDarkMode) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => ConcertDetailsPage(
        concert: concert,
        isDarkMode: isDarkMode,
        onBuyTicket: () => _showTicketSelection(concert, isDarkMode),
      ),
    );
  }

  void _showTicketSelection(Map<String, dynamic> concert, bool isDarkMode) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => TicketSelectionPage(
        concert: concert,
        isDarkMode: isDarkMode,
        onPurchase: (selectedTicket, quantity) {
          _buyTicket(concert, selectedTicket, quantity);
        },
      ),
    );
  }

  Future<void> _buyTicket(Map<String, dynamic> concert, Map<String, dynamic> selectedTicket, int quantity) async {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: Text("Processing"),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              CupertinoActivityIndicator(radius: 20),
              SizedBox(height: 16),
              Text(
                "Securing your tickets...",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );

    final url = "https://api.xendit.co/v2/invoices";
    String auth = 'Basic ' + base64Encode(utf8.encode(apiKey));
    final totalAmount = (selectedTicket['price'] as int) * quantity;

    print("[_buyTicket] Creating invoice - ticket: ${selectedTicket['name']}, quantity: $quantity, totalAmount: $totalAmount");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Authorization": auth, "Content-Type": "application/json"},
        body: jsonEncode({
          "external_id": "concert_${DateTime.now().millisecondsSinceEpoch}",
          "amount": totalAmount,
          "description": "${concert['artist']} - ${concert['tour']} (${selectedTicket['name']} x$quantity)",
          "payment_methods": ["GCASH", "CREDIT_CARD", "PAYMAYA"],
        }),
      );


      final data = jsonDecode(response.body);
      print("[_buyTicket] Xendit response: $data");
      String? id = data["id"];
      String? invoiceUrl = data["invoice_url"];

      Navigator.of(context, rootNavigator: true).pop();

      if (id == null || invoiceUrl == null) {
        print("[_buyTicket] ERROR: id or invoiceUrl is null");
        _showErrorDialog("Failed to create payment. Please try again.");
        return;
      }

      print("[_buyTicket] Invoice created - id: $id");

      // Create purchase record in memory store
      PurchaseStore().createPurchase(
        invoiceId: id,
        concert: concert,
        ticket: selectedTicket,
        quantity: quantity,
      );

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => PaymentPage(
            url: invoiceUrl,
            invoiceId: id,
            concert: concert,
            ticket: selectedTicket,
            price: totalAmount.toDouble(),
            isDarkMode: widget.isDarkMode,
            onPaymentSuccess: () {
              // Mark purchase as paid in the store
              print("[_buyTicket] onPaymentSuccess callback triggered for invoice: $id");
              PurchaseStore().markAsPaid(id);

              // Save to Hive
              _savePurchaseToHive(id);

              // Show success dialog after WebView is dismissed
              Future.delayed(Duration(milliseconds: 500), () {
                if (mounted) {
                  _showSuccessDialog("${concert['artist']} - ${selectedTicket['name']} x$quantity ticket purchased successfully!");
                }
              });
            },
          ),
        ),
      );
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      _showErrorDialog("Network error. Please check your connection.");
    }
  }

  void _showSuccessDialog(String message) {
    final isDarkMode = widget.isDarkMode;
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Icon(CupertinoIcons.checkmark_alt, size: 48, color: Color(0xFF34C759)),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
          ),
        ),
        actions: [CupertinoDialogAction(
          child: Text("OK"),
          onPressed: () => Navigator.of(context).pop(),
        )],
      ),
    );
  }

  void _savePurchaseToHive(String invoiceId) {
    // Get the purchase from the store
    final purchase = PurchaseStore().findById(invoiceId);
    if (purchase == null || purchase.status != 'PAID') {
      print("[_savePurchaseToHive] Purchase not found or not paid: $invoiceId");
      return;
    }

    // Get Hive box
    final box = Hive.box('auth');

    // Update totalSpent
    final currentTotal = box.get('totalSpent', defaultValue: 0.0) as double;
    final newTotal = currentTotal + purchase.amount;
    box.put('totalSpent', newTotal);
    print("[_savePurchaseToHive] Updated totalSpent: $currentTotal -> $newTotal");

    // Update purchaseHistory
    final history = box.get('purchaseHistory', defaultValue: []) as List;
    final purchaseData = {
      'id': purchase.id,
      'artist': purchase.concertArtist,
      'tour': purchase.concertTour,
      'venue': purchase.concertVenue,
      'date': purchase.concertDate,
      'ticketType': purchase.ticketType,
      'quantity': purchase.quantity,
      'amount': purchase.amount,
      'status': purchase.status,
      'paidAt': purchase.paidAt?.toIso8601String(),
      'createdAt': purchase.createdAt.toIso8601String(),
    };
    history.add(purchaseData);
    box.put('purchaseHistory', history);
    print("[_savePurchaseToHive] Added to history, total purchases: ${history.length}");
  }

  void _showErrorDialog(String message) {
    final isDarkMode = widget.isDarkMode;
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Icon(CupertinoIcons.xmark_circle, size: 48, color: Color(0xFFFF3B30)),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
          ),
        ),
        actions: [CupertinoDialogAction(
          child: Text("Try Again"),
          onPressed: () => Navigator.of(context).pop(),
        )],
      ),
    );
  }
}

class ConcertDetailsPage extends StatelessWidget {
  final Map<String, dynamic> concert;
  final bool isDarkMode;
  final VoidCallback onBuyTicket;

  const ConcertDetailsPage({
    super.key,
    required this.concert,
    required this.isDarkMode,
    required this.onBuyTicket,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final backgroundColor = isDarkMode ? Color(0xFF000000) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkMode ? Color(0xFF8E8E93) : Color(0xFF8E8E93);
    final cardColor = isDarkMode ? Color(0xFF1C1C1E) : Color(0xFFF2F2F7);

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: isDarkMode ? Color(0xFF1C1C1E) : Colors.white,
        middle: Text(
          "Details",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: Icon(
            CupertinoIcons.xmark,
            size: 20,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            // Hero Image Gallery
            Container(
              height: screenHeight * 0.35,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: concert['images'].length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        concert['images'][index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: isDarkMode ? Color(0xFF1C1C1E) : Color(0xFFF2F2F7),
                            child: Center(child: CupertinoActivityIndicator()),
                          );
                        },
                      );
                    },
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.black.withOpacity(0.6) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.ticket,
                            size: 12,
                            color: Color(0xFF007AFF),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${concert['tickets_left']} tickets left',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Concert Info
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Artist and Tour
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: concert['color'],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          concert['artist'] as String,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      concert['tour'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: secondaryTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Details Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildDetailCard(
                        icon: CupertinoIcons.calendar,
                        title: 'Date & Time',
                        value: '${concert['date']}\n${concert['time']}',
                        color: Color(0xFF007AFF),
                        isDarkMode: isDarkMode,
                      ),
                      _buildDetailCard(
                        icon: CupertinoIcons.location_solid,
                        title: 'Venue',
                        value: concert['venue'] as String,
                        color: Color(0xFFFF9500),
                        isDarkMode: isDarkMode,
                      ),
                      _buildDetailCard(
                        icon: CupertinoIcons.clock_fill,
                        title: 'Duration',
                        value: concert['duration'] as String,
                        color: Color(0xFF34C759),
                        isDarkMode: isDarkMode,
                      ),
                      _buildDetailCard(
                        icon: CupertinoIcons.music_note_2,
                        title: 'Genre',
                        value: concert['genre'] as String,
                        color: Color(0xFFAF52DE),
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Description Section
                  Text(
                    'About This Concert',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: cardColor,
                    ),
                    child: Text(
                      concert['description'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Highlights
                  Text(
                    'Concert Highlights',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: (concert['highlights'] as List).map((highlight) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              concert['color'].withOpacity(isDarkMode ? 0.2 : 0.1),
                              concert['color'].withOpacity(isDarkMode ? 0.3 : 0.2),
                            ],
                          ),
                          border: Border.all(
                            color: concert['color'].withOpacity(isDarkMode ? 0.4 : 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.star_fill,
                              size: 12,
                              color: concert['color'],
                            ),
                            SizedBox(width: 4),
                            Text(
                              highlight,
                              style: TextStyle(
                                fontSize: 12,
                                color: concert['color'],
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 28),

                  // Action Button
                  CupertinoButton.filled(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    borderRadius: BorderRadius.circular(12),
                    onPressed: onBuyTicket,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.ticket_fill,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Get Tickets',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required bool isDarkMode,
  }) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(isDarkMode ? 0.1 : 0.05),
        border: Border.all(
          color: color.withOpacity(isDarkMode ? 0.2 : 0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(isDarkMode ? 0.2 : 0.1),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Color(0xFF8E8E93) : Color(0xFF8E8E93),
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class TicketSelectionPage extends StatefulWidget {
  final Map<String, dynamic> concert;
  final bool isDarkMode;
  final Function(Map<String, dynamic>, int) onPurchase;

  const TicketSelectionPage({
    super.key,
    required this.concert,
    required this.isDarkMode,
    required this.onPurchase,
  });

  @override
  State<TicketSelectionPage> createState() => _TicketSelectionPageState();
}

class _TicketSelectionPageState extends State<TicketSelectionPage> {
  int _selectedTicketIndex = 0;
  int _ticketQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final ticketTypes = widget.concert['ticket_types'] as List;
    final selectedTicket = ticketTypes[_selectedTicketIndex];
    final totalPrice = (selectedTicket['price'] as int) * _ticketQuantity;

    final backgroundColor = widget.isDarkMode ? Color(0xFF000000) : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = widget.isDarkMode ? Color(0xFF8E8E93) : Color(0xFF8E8E93);
    final cardColor = widget.isDarkMode ? Color(0xFF1C1C1E) : Color(0xFFF2F2F7);

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: widget.isDarkMode ? Color(0xFF1C1C1E) : Colors.white,
        middle: Text(
          "Select Tickets",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: Icon(
            CupertinoIcons.xmark,
            size: 20,
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            // Concert Info Banner
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.isDarkMode
                      ? [Color(0xFF0A84FF), Color(0xFF5E5CE6)]
                      : [Color(0xFF007AFF), Color(0xFF5856D6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF007AFF).withOpacity(widget.isDarkMode ? 0.3 : 0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.concert['artist'] as String,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.concert['tour'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar,
                        size: 14,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6),
                      Text(
                        widget.concert['date'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        CupertinoIcons.location_solid,
                        size: 14,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.concert['venue'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Ticket Types Header
                  Text(
                    "Select Ticket Type",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Ticket Options
                  Column(
                    children: ticketTypes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final ticket = entry.value;
                      final isSelected = index == _selectedTicketIndex;

                      return Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTicketIndex = index),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isSelected
                                  ? Color(0xFF007AFF).withOpacity(widget.isDarkMode ? 0.2 : 0.1)
                                  : cardColor,
                              border: Border.all(
                                color: isSelected ? Color(0xFF0B5715) : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? Color(0xFF007AFF) : Color(0xFF8E8E93),
                                  ),
                                  child: Icon(
                                    isSelected ? CupertinoIcons.checkmark_alt : CupertinoIcons.ticket,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ticket['name'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: textColor,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        ticket['perks'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: secondaryTextColor,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '₱',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF007AFF),
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${ticket['price']}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF007AFF),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "each",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  // Quantity Selector
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: cardColor,
                      border: Border.all(
                        color: widget.isDarkMode
                            ? Color(0xFF3A3A3C)
                            : Color(0xFFC6C6C8).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Quantity",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: widget.isDarkMode ? Color(0xFF2C2C2E) : Colors.white,
                                border: Border.all(
                                  color: widget.isDarkMode ? Color(0xFF3A3A3C) : Color(0xFFC6C6C8),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  CupertinoButton(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    onPressed: () => setState(
                                          () => _ticketQuantity = _ticketQuantity > 1
                                          ? _ticketQuantity - 1
                                          : 1,
                                    ),
                                    child: Icon(
                                      CupertinoIcons.minus,
                                      color: textColor,
                                      size: 18,
                                    ),
                                  ),
                                  Container(
                                    width: 40,
                                    child: Text(
                                      '$_ticketQuantity',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                  CupertinoButton(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    onPressed: () => setState(
                                          () => _ticketQuantity =
                                      _ticketQuantity < 10 ? _ticketQuantity + 1 : 10,
                                    ),
                                    child: Icon(
                                      CupertinoIcons.plus,
                                      color: textColor,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Maximum of 10 tickets per purchase",
                          style: TextStyle(
                            fontSize: 11,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Total Price
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.isDarkMode
                            ? [
                          Color(0xFF0A84FF).withOpacity(0.2),
                          Color(0xFF5E5CE6).withOpacity(0.2),
                        ]
                            : [
                          Color(0xFF007AFF).withOpacity(0.1),
                          Color(0xFF5856D6).withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Color(0xFF0F0FEC).withOpacity(widget.isDarkMode ? 0.3 : 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Total Amount",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF007AFF),
                          ),
                        ),
                        SizedBox(height: 6),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '₱',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF007AFF),
                                ),
                              ),
                              TextSpan(
                                text: '$totalPrice',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF007AFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "${selectedTicket['name']} × $_ticketQuantity",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF007AFF).withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 12),
                        Divider(
                          color: Color(0xFF007AFF).withOpacity(widget.isDarkMode ? 0.3 : 0.2),
                          height: 1,
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal",
                              style: TextStyle(
                                fontSize: 13,
                                color: secondaryTextColor,
                              ),
                            ),
                            Text(
                              "₱${selectedTicket['price']}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Service Fee",
                              style: TextStyle(
                                fontSize: 13,
                                color: secondaryTextColor,
                              ),
                            ),
                            Text(
                              "₱${(selectedTicket['price'] * 0.05).round()}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons
                  SizedBox(height: 24),
                  Column(
                    children: [
                      CupertinoButton.filled(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        borderRadius: BorderRadius.circular(12),
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onPurchase(selectedTicket, _ticketQuantity);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.creditcard_fill,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Buy Now',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      CupertinoButton(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        borderRadius: BorderRadius.circular(12),
                        color: cardColor,
                        onPressed: () => Navigator.pop(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.xmark,
                              size: 18,
                              color: textColor,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Cancel',
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  final String url;
  final String invoiceId;
  final Map<String, dynamic> concert;
  final Map<String, dynamic> ticket;
  final double price;
  final VoidCallback onPaymentSuccess;
  final bool isDarkMode;

  const PaymentPage({
    super.key,
    required this.url,
    required this.invoiceId,
    required this.concert,
    required this.ticket,
    required this.price,
    required this.onPaymentSuccess,
    required this.isDarkMode,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> with WidgetsBindingObserver {
  late WebViewController controller;
  bool _isLoading = true;
  Timer? _pollingTimer;
  // Use same fallback logic as main page
  final String _apiKey = dotenv.env['XENDIT_API_KEY'] ?? "xnd_development_IgiQCiy0Q9Er1xrrPUXZPt6C7N7UKZW0SUWaG6MVQs19TxlV7LLbcXKVkcJU18m";
  bool _paymentProcessed = false; // Idempotency flag to prevent duplicate processing

  @override
  void initState() {
    super.initState();

    print("[PaymentPage] Initializing - API Key loaded: ${_apiKey.isNotEmpty ? 'Yes' : 'No'}");
    print("[PaymentPage] API Key (first 20 chars): ${_apiKey.substring(0, _apiKey.length > 20 ? 20 : _apiKey.length)}...");
    print("[PaymentPage] Invoice ID: ${widget.invoiceId}");

    // Add lifecycle observer for iOS background/foreground handling
    WidgetsBinding.instance.addObserver(this);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'PaymentSuccess',
        onMessageReceived: (JavaScriptMessage message) {
          print("[PaymentPage] JavaScript message received: ${message.message}");
          if (message.message == 'PAID' || message.message == 'SUCCESS') {
            print("[PaymentPage] Payment confirmed via JavaScript channel!");
            _handlePaymentSuccess();
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) setState(() => _isLoading = true);
            _checkUrlForSuccess(url);
          },
          onPageFinished: (url) {
            if (mounted) setState(() => _isLoading = false);
            _checkUrlForSuccess(url);
            _injectPaymentDetectionScript();
          },
          onNavigationRequest: (request) {
            _checkUrlForSuccess(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    _startPolling();
  }

  // Inject JavaScript to detect payment completion
  void _injectPaymentDetectionScript() {
    controller.runJavaScript('''
      (function() {
        console.log('[Xendit] Payment detection script injected');
        
        // Check if page indicates success
        function checkPaymentStatus() {
          var bodyText = document.body.innerText || '';
          var url = window.location.href;
          
          if (url.includes('status=paid') || 
              url.includes('success') || 
              bodyText.toLowerCase().includes('payment successful') ||
              bodyText.toLowerCase().includes('pembayaran berhasil')) {
            console.log('[Xendit] SUCCESS detected in page!');
            if (window.PaymentSuccess) {
              PaymentSuccess.postMessage('PAID');
            }
          }
        }
        
        // Run check immediately
        setTimeout(checkPaymentStatus, 1000);
        
        // Run check periodically
        setInterval(checkPaymentStatus, 2000);
      })();
    ''');
  }

  // Check URL for success indicators (helps with iOS redirect handling)
  void _checkUrlForSuccess(String url) {
    print("[PaymentPage] URL navigation: $url");

    if ((url.contains('status=paid') ||
         url.contains('success') ||
         url.contains('payment_success') ||
         url.contains('completed')) &&
        !_paymentProcessed) {
      print("[PaymentPage] ✅ Success URL detected!");
      _handlePaymentSuccess();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("[PaymentPage] App lifecycle changed: $state");

    // When app returns to foreground on iOS, check payment status
    if (state == AppLifecycleState.resumed && !_paymentProcessed) {
      print("[PaymentPage] App resumed - checking payment status immediately");
      _checkPaymentStatusNow();
    }
  }

  void _startPolling() {
    print("[PaymentPage] Starting polling for invoice: ${widget.invoiceId}");

    // Do an immediate check
    _checkPaymentStatusNow();

    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      // Skip if already processed
      if (_paymentProcessed) {
        print("[PaymentPage] Payment already processed, skipping poll");
        timer.cancel();
        return;
      }

      try {
        final url = "https://api.xendit.co/v2/invoices/${widget.invoiceId}";
        String auth = 'Basic ' + base64Encode(utf8.encode(_apiKey));
        print("[PaymentPage] Polling... checking status (attempt ${timer.tick})");

        final response = await http.get(
          Uri.parse(url),
          headers: {
            "Authorization": auth,
            "Content-Type": "application/json",
          }
        ).timeout(
          Duration(seconds: 8),
          onTimeout: () {
            print("[PaymentPage] ⚠️ Request timeout after 8s");
            return http.Response('{"error": "timeout"}', 408);
          },
        );

        print("[PaymentPage] Polling response code: ${response.statusCode}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final status = data["status"];
          print("[PaymentPage] ✓ Current status: $status");

          // Log full response for debugging
          print("[PaymentPage] Full response: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...");

          if (status == "PAID" && !_paymentProcessed) {
            print("[PaymentPage] ===== PAYMENT CONFIRMED PAID =====");
            _handlePaymentSuccess();
            timer.cancel();
          } else if (status == "EXPIRED" || status == "FAILED") {
            print("[PaymentPage] Payment ${status}");
            timer.cancel();
            _handlePaymentFailure(status);
          }
        } else if (response.statusCode == 401) {
          print("[PaymentPage] ❌ AUTH ERROR 401 - API Key issue!");
          print("[PaymentPage] Using key: ${_apiKey.substring(0, 20)}...");
          print("[PaymentPage] Full key length: ${_apiKey.length}");
          // Don't cancel timer, might be temporary
        } else {
          print("[PaymentPage] API Error: ${response.statusCode}");
          print("[PaymentPage] Response body: ${response.body}");
        }
      } catch (e, stackTrace) {
        print("[PaymentPage] Polling error: $e");
        print("[PaymentPage] Stack trace: ${stackTrace.toString().substring(0, 200)}");
      }
    });
  }

  // Manual status check (used when app resumes)
  Future<void> _checkPaymentStatusNow() async {
    if (_paymentProcessed) {
      print("[PaymentPage] Already processed, skipping manual check");
      return;
    }

    try {
      final url = "https://api.xendit.co/v2/invoices/${widget.invoiceId}";
      String auth = 'Basic ' + base64Encode(utf8.encode(_apiKey));

      print("[PaymentPage] === MANUAL STATUS CHECK ===");
      print("[PaymentPage] Invoice ID: ${widget.invoiceId}");
      print("[PaymentPage] API endpoint: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": auth,
          "Content-Type": "application/json",
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          print("[PaymentPage] Manual check timeout");
          return http.Response('{"error": "timeout"}', 408);
        },
      );

      print("[PaymentPage] Manual check response code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data["status"];
        print("[PaymentPage] Manual check status: $status");
        print("[PaymentPage] Response: ${response.body.substring(0, response.body.length > 300 ? 300 : response.body.length)}");

        if (status == "PAID") {
          print("[PaymentPage] ✅ PAID status detected in manual check!");
          _handlePaymentSuccess();
        } else {
          print("[PaymentPage] Status is still: $status");
        }
      } else {
        print("[PaymentPage] Manual check failed with code: ${response.statusCode}");
        print("[PaymentPage] Error body: ${response.body}");
      }
    } catch (e, stackTrace) {
      print("[PaymentPage] Manual check error: $e");
      print("[PaymentPage] Stack: $stackTrace");
    }
  }

  void _handlePaymentSuccess() async {
    if (_paymentProcessed) {
      print("[PaymentPage] Already processed, skipping");
      return;
    }

    print("[PaymentPage] 🎉 Processing payment success...");
    _paymentProcessed = true;
    _pollingTimer?.cancel();
    _pollingTimer = null;

    // Call success callback first
    print("[PaymentPage] Calling onPaymentSuccess");
    widget.onPaymentSuccess();

    // Small delay to ensure callback completes
    await Future.delayed(Duration(milliseconds: 200));

    // Pop the WebView page
    print("[PaymentPage] Attempting to pop WebView page...");
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      print("[PaymentPage] ✅ WebView closed successfully");
    } else {
      print("[PaymentPage] ❌ Cannot pop WebView");
    }
  }

  void _handlePaymentFailure(String status) {
    if (mounted) {
      final isDark = widget.isDarkMode;
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Icon(
            CupertinoIcons.xmark_circle,
            size: 48,
            color: Color(0xFFFF3B30)
          ),
          content: Text(
            "Payment $status. Please try again.",
            style: TextStyle(
              color: isDark ? CupertinoColors.white : CupertinoColors.black,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close WebView
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    print("[PaymentPage] Disposing - cleaning up");
    WidgetsBinding.instance.removeObserver(this);
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Color(0xFF000000) : CupertinoColors.white;
    final textColor = widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black;

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: widget.isDarkMode ? Color(0xFF1C1C1E) : CupertinoColors.white,
        middle: Text(
          "Payment",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: textColor,
          ),
        ),
      ),
      child: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (_isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(radius: 20),
                  SizedBox(height: 16),
                  Text(
                    "Loading payment gateway...",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
