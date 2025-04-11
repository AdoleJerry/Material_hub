import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _HistoryPage();
}

class _HistoryPage extends State<TransactionHistory> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> _refreshTransactions() async {
    setState(() {}); // Forces the page to rebuild and refresh the Stream
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        centerTitle: true,
      ),
      body: _transactionHistoryBody(),
    );
  }

  Widget _transactionHistoryBody() {
    return Container(
      color: const Color.fromRGBO(178, 190, 181, 1),
      child: RefreshIndicator(
        onRefresh: _refreshTransactions,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('payment-history')
              .doc(userId)
              .collection("user-payment-history")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No transaction history found'),
              );
            }

            var transactions = snapshot.data!.docs;

            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                var transaction = transactions[index];

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    hoverColor: const Color.fromRGBO(178, 190, 181, 0.5),
                    title: Text(
                      'Transaction ID: ${transaction['title']}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount: ${transaction['amount']} Naira',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Date: ${transaction['updated_at']}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Status: ${transaction['status']}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
