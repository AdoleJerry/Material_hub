import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadsPage extends StatelessWidget {
  const UploadsPage({super.key});

  Future<void> _deleteUpload(String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('shared_stream')
          .doc(docId)
          .delete();
    }
  }

  Future<void> _editUpload(BuildContext context, String docId,
      String currentTitle, int currentPrice, String currentDescription) async {
    final TextEditingController titleController =
        TextEditingController(text: currentTitle);
    final TextEditingController priceController =
        TextEditingController(text: currentPrice.toString());
    final TextEditingController descriptionController =
        TextEditingController(text: currentDescription);

    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Upload'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final int? price = int.tryParse(priceController.text);
      if (price != null) {
        await FirebaseFirestore.instance
            .collection('shared_stream')
            .doc(docId)
            .update({
          'title': titleController.text,
          'price': price,
          'description': descriptionController.text,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Please log in to view your uploads.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Uploads'),
      ),
      body: Container(
        color: const Color.fromRGBO(178, 190, 181, 1),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('shared_stream')
              .where('userid', isEqualTo: user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final uploads = snapshot.data!.docs;

            return ListView.builder(
              itemCount: uploads.length,
              itemBuilder: (context, index) {
                final upload = uploads[index];
                final data = upload.data() as Map<String, dynamic>;

                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(data['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: ${data['price']}'),
                        Text('Description: ${data['description']}'),
                        GestureDetector(
                          onTap: () async {
                            if (await canLaunch(data['downloadUrl'])) {
                              await launch(data['downloadUrl']);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Could not open file.')),
                              );
                            }
                          },
                          child: const Text(
                            'View/Download File',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _editUpload(
                              context,
                              upload.id,
                              data['title'],
                              data['price'],
                              data['description'],
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deleteUpload(upload.id);
                          },
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
