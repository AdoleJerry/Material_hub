import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_hub/Home/courses_page/ipayment_history.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses Page'),
        centerTitle: true,
      ),
      body: const PurchasedItemsList(), // The body of the page
    );
  }
}

class PurchasedItemsList extends StatefulWidget {
  const PurchasedItemsList({super.key});

  @override
  State<PurchasedItemsList> createState() => _PurchasedItemsListState();
}

class _PurchasedItemsListState extends State<PurchasedItemsList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<List<PaymentHistory>> _getPurchasedItems() async {
    final querySnapshot = await _firestore
        .collection('payment-history')
        .doc(userId)
        .collection('user-payment-history')
        .withConverter<PaymentHistory>(
          fromFirestore: (snapshot, _) =>
              PaymentHistory.fromJson(snapshot.data()!), // Deserialize
          toFirestore: (payment, _) => payment.toJson(), // Serialize
        )
        .where('status', isEqualTo: 'successful') // Example query filter
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  late Future<List<PaymentHistory>> _purchasedItemsFuture;

  @override
  void initState() {
    super.initState();
    _purchasedItemsFuture = _getPurchasedItems(); // Load data initially
  }

  // This function will be called when pulling down to refresh the page
  Future<void> _refreshPurchasedItems() async {
    setState(() {
      _purchasedItemsFuture = _getPurchasedItems();
    });
    await _purchasedItemsFuture; // Wait for data to be refreshed
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPurchasedItems, // Swipe down to refresh
      child: FutureBuilder<List<PaymentHistory>>(
        future: _purchasedItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching purchased items'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No purchased items found'));
          } else {
            final purchasedItems = snapshot.data!;

            return ListView.separated(
              itemCount: purchasedItems.length,
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.grey, // Color of the separator line
                  thickness: 1.0, // Thickness of the line
                );
              },
              itemBuilder: (context, index) {
                final item = purchasedItems[index];

                return ListTile(
                  title: Text(item.title),
                  subtitle: Text('Amount: ${item.amount} Naira'),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () async {
                      final imageUrl = item.imageUrl;
                      if (imageUrl.isNotEmpty) {
                        if (await canLaunch(imageUrl)) {
                          await launch(imageUrl);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to open image')),
                          );
                        }
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
