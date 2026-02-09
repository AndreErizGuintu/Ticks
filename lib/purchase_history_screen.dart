// Purchase History Screen - displays all purchases with QR placeholder

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  final bool isDarkMode;

  const PurchaseHistoryScreen({
    super.key,
    required this.isDarkMode,
  });

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    // Read purchase history from Hive
    final box = Hive.box('auth');
    final purchaseHistory = box.get('purchaseHistory', defaultValue: []) as List;

    final backgroundColor = widget.isDarkMode ? Color(0xFF000000) : Color(0xFFF2F2F7);
    final cardColor = widget.isDarkMode ? Color(0xFF1C1C1E) : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = Color(0xFF8E8E93);

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: widget.isDarkMode ? Color(0xFF1C1C1E) : Colors.white,
        middle: Text(
          "Purchase History",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: textColor,
          ),
        ),
      ),
      child: SafeArea(
        child: purchaseHistory.isEmpty
            ? _buildEmptyState(textColor, secondaryTextColor)
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(16),
                itemCount: purchaseHistory.length,
                itemBuilder: (context, index) {
                  // Show newest first
                  final purchaseData = purchaseHistory[purchaseHistory.length - 1 - index] as Map;
                  return _buildPurchaseCard(
                    purchaseData,
                    cardColor,
                    textColor,
                    secondaryTextColor,
                  );
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState(Color textColor, Color secondaryTextColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.ticket,
            size: 80,
            color: secondaryTextColor.withOpacity(0.5),
          ),
          SizedBox(height: 20),
          Text(
            "No Purchases Yet",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Your ticket purchases will appear here",
            style: TextStyle(
              fontSize: 16,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseCard(
    Map purchaseData,
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    final status = purchaseData['status'] ?? 'PENDING';
    final artist = purchaseData['artist'] ?? 'Unknown Artist';
    final tour = purchaseData['tour'] ?? '';
    final venue = purchaseData['venue'] ?? 'Unknown Venue';
    final date = purchaseData['date'] ?? '';
    final ticketType = purchaseData['ticketType'] ?? 'Standard';
    final quantity = purchaseData['quantity'] ?? 1;
    final amount = purchaseData['amount'] ?? 0.0;
    final paidAtStr = purchaseData['paidAt'];

    final statusColor = _getStatusColor(status);
    final formattedAmount = '₱${amount.toStringAsFixed(0)}';

    return GestureDetector(
      onTap: () => _showPurchaseDetail(purchaseData),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: widget.isDarkMode
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      artist,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  _buildStatusBadge(status, statusColor),
                ],
              ),
              SizedBox(height: 4),
              Text(
                tour,
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryTextColor,
                ),
              ),
              SizedBox(height: 12),
              // Details row
              Row(
                children: [
                  Icon(
                    CupertinoIcons.ticket,
                    size: 16,
                    color: secondaryTextColor,
                  ),
                  SizedBox(width: 6),
                  Text(
                    quantity > 1
                        ? '$ticketType x$quantity'
                        : ticketType,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                  Spacer(),
                  Text(
                    formattedAmount,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF007AFF),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.location,
                    size: 16,
                    color: secondaryTextColor,
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      venue,
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.calendar,
                    size: 16,
                    color: secondaryTextColor,
                  ),
                  SizedBox(width: 6),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
              if (status == 'PAID' && paidAtStr != null) ...[
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.checkmark_circle,
                      size: 16,
                      color: Color(0xFF34C759),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Paid on ${_formatDate(DateTime.parse(paidAtStr))}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF34C759),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PAID':
        return Color(0xFF34C759);
      case 'PENDING':
        return Color(0xFFFF9500);
      case 'CANCELLED':
        return Color(0xFFFF3B30);
      default:
        return Color(0xFF8E8E93);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showPurchaseDetail(Map purchaseData) {
    final status = purchaseData['status'] ?? 'PENDING';
    final artist = purchaseData['artist'] ?? 'Unknown Artist';
    final tour = purchaseData['tour'] ?? '';
    final venue = purchaseData['venue'] ?? 'Unknown Venue';
    final date = purchaseData['date'] ?? '';
    final ticketType = purchaseData['ticketType'] ?? 'Standard';
    final quantity = purchaseData['quantity'] ?? 1;
    final amount = purchaseData['amount'] ?? 0.0;
    final id = purchaseData['id'] ?? 'N/A';
    final paidAtStr = purchaseData['paidAt'];

    final formattedAmount = '₱${amount.toStringAsFixed(0)}';
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = Color(0xFF8E8E93);
    final cardColor = widget.isDarkMode ? Color(0xFF1C1C1E) : Colors.white;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Drag indicator
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: secondaryTextColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            // Title
            Text(
              "Ticket Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 24),
            // QR Placeholder
            _buildQRPlaceholder(status),
            SizedBox(height: 24),
            // Purchase info
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildDetailRow("Artist", artist, textColor, secondaryTextColor),
                  _buildDetailRow("Tour", tour, textColor, secondaryTextColor),
                  _buildDetailRow("Venue", venue, textColor, secondaryTextColor),
                  _buildDetailRow("Date", date, textColor, secondaryTextColor),
                  _buildDetailRow("Ticket Type", ticketType, textColor, secondaryTextColor),
                  _buildDetailRow("Quantity", quantity.toString(), textColor, secondaryTextColor),
                  _buildDetailRow("Amount", formattedAmount, textColor, secondaryTextColor),
                  _buildDetailRow("Status", status, textColor, secondaryTextColor),
                  if (paidAtStr != null)
                    _buildDetailRow("Paid At", _formatDate(DateTime.parse(paidAtStr)), textColor, secondaryTextColor),
                  _buildDetailRow("Order ID", id, textColor, secondaryTextColor),
                ],
              ),
            ),
            // Close button
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    color: Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(12),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Close",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRPlaceholder(String status) {
    final isPaid = status == 'PAID';
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: isPaid ? Colors.white : Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPaid ? Color(0xFF34C759) : Color(0xFF8E8E93),
          width: 2,
        ),
      ),
      child: isPaid
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Placeholder QR pattern
                Container(
                  width: 120,
                  height: 120,
                  child: CustomPaint(
                    painter: _QRPlaceholderPainter(),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Scan at entry",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8E8E93),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.qrcode,
                  size: 60,
                  color: Color(0xFF8E8E93),
                ),
                SizedBox(height: 12),
                Text(
                  "QR will appear\nafter payment",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8E8E93),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color textColor, Color secondaryTextColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: secondaryTextColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for QR placeholder pattern
class _QRPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final cellSize = size.width / 10;

    // Draw a simplified QR-like pattern
    // Corner squares (positioning patterns)
    _drawCornerSquare(canvas, paint, 0, 0, cellSize);
    _drawCornerSquare(canvas, paint, size.width - cellSize * 3, 0, cellSize);
    _drawCornerSquare(canvas, paint, 0, size.height - cellSize * 3, cellSize);

    // Random data pattern in center
    final random = [
      [4, 1], [5, 1], [6, 2], [4, 3], [5, 4], [6, 3],
      [1, 4], [2, 5], [3, 4], [1, 6], [3, 6],
      [4, 5], [5, 5], [6, 5], [4, 6], [6, 6],
      [7, 4], [8, 5], [7, 6], [8, 7],
      [4, 7], [5, 8], [6, 7], [5, 7],
    ];

    for (final pos in random) {
      canvas.drawRect(
        Rect.fromLTWH(pos[0] * cellSize, pos[1] * cellSize, cellSize * 0.9, cellSize * 0.9),
        paint,
      );
    }
  }

  void _drawCornerSquare(Canvas canvas, Paint paint, double x, double y, double cellSize) {
    // Outer square
    canvas.drawRect(Rect.fromLTWH(x, y, cellSize * 3, cellSize * 3), paint);
    // Inner white
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(x + cellSize * 0.5, y + cellSize * 0.5, cellSize * 2, cellSize * 2), whitePaint);
    // Center black
    canvas.drawRect(Rect.fromLTWH(x + cellSize, y + cellSize, cellSize, cellSize), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
