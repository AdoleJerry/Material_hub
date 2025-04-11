import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentHistory {
  final String title;
  final double amount;
  final String status;
  final String imageUrl;

  PaymentHistory({
    required this.title,
    required this.amount,
    required this.status,
    required this.imageUrl,
  });

  // Factory method to create a PaymentHistory object from Firestore
  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      title: json['title'] ?? '',
      amount: json['amount']?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  // Method to convert a PaymentHistory object to Firestore format (optional)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'status': status,
      'imageUrl': imageUrl,
    };
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch payment history for the current user
  Future<List<PaymentHistory>> getPaymentHistory() async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    final querySnapshot = await _firestore
        .collection('payment-history')
        .doc(userId)
        .collection('user-payment-history')
        .withConverter<PaymentHistory>(
          fromFirestore: (snapshot, _) =>
              PaymentHistory.fromJson(snapshot.data()!), // Deserialize
          toFirestore: (payment, _) => payment.toJson(), // Serialize
        )
        .where('status', isEqualTo: 'Successful') // Example query filter
        .get();

    // Map the results to a list of PaymentHistory objects
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
