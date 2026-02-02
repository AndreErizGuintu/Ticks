// In-memory purchase store singleton

import '../models/purchase.dart';

class PurchaseStore {
  // Singleton instance
  static final PurchaseStore _instance = PurchaseStore._internal();
  factory PurchaseStore() => _instance;
  PurchaseStore._internal();

  // In-memory list of purchases
  final List<Purchase> _purchases = [];

  /// Get all purchases (unmodifiable view)
  List<Purchase> get purchases => List.unmodifiable(_purchases);

  /// Get purchases filtered by status
  List<Purchase> getByStatus(String status) {
    return _purchases.where((p) => p.status == status).toList();
  }

  /// Get paid purchases
  List<Purchase> get paidPurchases => getByStatus('PAID');

  /// Get pending purchases
  List<Purchase> get pendingPurchases => getByStatus('PENDING');

  /// Add a new purchase
  void addPurchase(Purchase purchase) {
    print("[PurchaseStore] Adding purchase: ${purchase.id}, status: ${purchase.status}");
    _purchases.add(purchase);
    print("[PurchaseStore] Total purchases now: ${_purchases.length}");
  }

  /// Create and add a purchase from concert/ticket data
  Purchase createPurchase({
    required String invoiceId,
    required Map<String, dynamic> concert,
    required Map<String, dynamic> ticket,
    int quantity = 1,
  }) {
    print("[PurchaseStore] Creating purchase - invoiceId: $invoiceId, quantity: $quantity");
    final purchase = Purchase.fromConcertAndTicket(
      invoiceId: invoiceId,
      concert: concert,
      ticket: ticket,
      quantity: quantity,
    );
    addPurchase(purchase);
    return purchase;
  }

  /// Find a purchase by ID
  Purchase? findById(String id) {
    print("[PurchaseStore] Looking for purchase with id: $id");
    try {
      final purchase = _purchases.firstWhere((p) => p.id == id);
      print("[PurchaseStore] Found purchase: ${purchase.id}, status: ${purchase.status}");
      return purchase;
    } catch (e) {
      print("[PurchaseStore] Purchase not found with id: $id");
      return null;
    }
  }

  /// Mark a purchase as paid by ID
  bool markAsPaid(String invoiceId) {
    print("[PurchaseStore] ===== MARKING AS PAID =====");
    print("[PurchaseStore] Invoice ID: $invoiceId");
    print("[PurchaseStore] Current purchases count: ${_purchases.length}");

    // Debug: print all purchase IDs
    for (var p in _purchases) {
      print("[PurchaseStore] - Purchase: ${p.id}, status: ${p.status}");
    }

    final purchase = findById(invoiceId);
    if (purchase != null) {
      print("[PurchaseStore] Found purchase to mark as paid: ${purchase.id}");
      print("[PurchaseStore] Before: status = ${purchase.status}");
      purchase.markAsPaid();
      print("[PurchaseStore] After: status = ${purchase.status}");
      print("[PurchaseStore] ===== MARKED AS PAID SUCCESS =====");
      return true;
    }
    print("[PurchaseStore] ===== FAILED TO FIND PURCHASE =====");
    return false;
  }

  /// Clear all purchases (for testing)
  void clear() {
    _purchases.clear();
  }

  /// Get total amount spent (paid purchases only)
  double get totalSpent {
    return paidPurchases.fold(0.0, (sum, p) => sum + p.amount);
  }

  /// Get count of all purchases
  int get count => _purchases.length;

  /// Get count of paid purchases
  int get paidCount => paidPurchases.length;
}
