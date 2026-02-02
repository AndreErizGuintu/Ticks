// Purchase model for storing ticket purchases in memory

class Purchase {
  final String id;
  final String concertArtist;
  final String concertTour;
  final String concertVenue;
  final String concertDate;
  final String ticketType;
  final int quantity;
  final double amount;
  String status; // PENDING, PAID, CANCELLED
  DateTime? paidAt;
  final DateTime createdAt;

  Purchase({
    required this.id,
    required this.concertArtist,
    required this.concertTour,
    required this.concertVenue,
    required this.concertDate,
    required this.ticketType,
    this.quantity = 1,
    required this.amount,
    this.status = 'PENDING',
    this.paidAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Creates a Purchase from concert and ticket data
  factory Purchase.fromConcertAndTicket({
    required String invoiceId,
    required Map<String, dynamic> concert,
    required Map<String, dynamic> ticket,
    int quantity = 1,
  }) {
    final pricePerTicket = (ticket['price'] as num).toDouble();
    return Purchase(
      id: invoiceId,
      concertArtist: concert['artist'] ?? 'Unknown Artist',
      concertTour: concert['tour'] ?? '',
      concertVenue: concert['venue'] ?? 'Unknown Venue',
      concertDate: concert['date'] ?? '',
      ticketType: ticket['name'] ?? 'Standard',
      quantity: quantity,
      amount: pricePerTicket * quantity,
      status: 'PENDING',
    );
  }

  /// Mark as paid
  void markAsPaid() {
    print("[Purchase] Marking purchase ${id} as PAID (was: $status)");
    status = 'PAID';
    paidAt = DateTime.now();
    print("[Purchase] Purchase ${id} is now $status, paidAt: $paidAt");
  }

  /// Mark as cancelled
  void markAsCancelled() {
    status = 'CANCELLED';
  }

  /// Get formatted amount with currency symbol
  String get formattedAmount => '₱${amount.toStringAsFixed(0)}';

  /// Get a short description
  String get description => '$concertArtist - $ticketType${quantity > 1 ? ' x$quantity' : ''}';
}
