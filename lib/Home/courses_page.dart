import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      body: PurchasedItemsList(),
    );
  }
}

class PurchasedItemsList extends StatelessWidget {
  PurchasedItemsList({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<List<Map<String, dynamic>>> _getPurchasedItems() async {
    final querySnapshot = await _firestore
        .collection('payment-history')
        .doc(userId)
        .collection('user-payment-history')
        .where('status',
            isEqualTo: 'Successful') // Only show successful payments
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getPurchasedItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching purchased items'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No purchased items found'));
        } else {
          final purchasedItems = snapshot.data!;

          return ListView.builder(
            itemCount: purchasedItems.length,
            itemBuilder: (context, index) {
              final item = purchasedItems[index];

              return ListTile(
                title: Text(item['title']),
                subtitle: Text('Amount: ${item['amount']} Naira'),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () async {
                    final imageUrl = item['imageUrl'];
                    if (imageUrl != null && imageUrl.isNotEmpty) {
                      if (await canLaunch(imageUrl)) {
                        await launch(imageUrl);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to open image URL')),
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
    );
  }
}
