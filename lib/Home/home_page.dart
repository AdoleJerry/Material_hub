import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_hub/Home/displayaData/display_data.dart';
import 'package:material_hub/Home/payment/payment_page.dart';
import 'package:material_hub/Home/upload/upload_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_thumbnail/pdf_thumbnail.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userType;
  String searchQuery = "";
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: isSearching
            ? _buildSearchField()
            : const Text(
                'Home',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
        actions: [
          if (userType == 'lecturer')
            IconButton(
              onPressed: () => _upload(context),
              icon: const Icon(
                Icons.upload_file_sharp,
                color: Colors.black,
                size: 30,
              ),
            ),
          IconButton(
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchQuery = "";
                  _searchController.clear();
                }
                isSearching = !isSearching;
              });
            },
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.black,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSearching)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "What would you like to read?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Expanded(
            child: isSearching && searchQuery.isEmpty
                ? Container()
                : _bodyOfHome(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
        border: InputBorder.none,
      ),
      style: const TextStyle(color: Colors.black, fontSize: 18.0),
      autofocus: true,
      onChanged: (query) {
        setState(() {
          searchQuery = query.trim();
        });
      },
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> _bodyOfHome() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream:
          FirebaseFirestore.instance.collection('shared_stream').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = snapshot.data!.docs;
        List<DisplayData> items = documents
            .map((doc) => DisplayData.fromDocumentSnapshot(doc))
            .where((item) =>
                item.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                item.description
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
            .toList();

        if (items.isEmpty && searchQuery.isNotEmpty) {
          return const Center(
            child: Text(
              'No results found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            if (item.imageUrl.isNotEmpty) {
              return GestureDetector(
                onTap: () {
                  _tappedGrid(context, item);
                },
                child: GridTile(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Uploaded by : ${item.email}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: _buildPdfPreview(item.imageUrl),
                      ),
                      if (item.title.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            item.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      Text(
                        item.price.toString(),
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  void _tappedGrid(BuildContext context, DisplayData item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentPage(
                  item: item,
                )));
  }

  Future<void> _getUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('user_data')
          .doc(user.uid)
          .get();

      if (mounted) {
        setState(() {
          userType = doc['role'];
        });
      }
    }
  }

  Widget _buildPdfPreview(String pdfUrl) {
    return FutureBuilder<File>(
      future: _downloadFile(pdfUrl), // Download PDF to a local file
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading PDF'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No PDF document found'));
        }

        // Use PdfThumbnail.fromFile to display the PDF thumbnail
        final pdfFile = snapshot.data!;
        return PdfThumbnail.fromFile(
          pdfFile.path,
          currentPage: 1, // Display the first page of the PDF
          height: 150, // Adjust the height of the thumbnail
          backgroundColor:
              Colors.grey[200]!, // Optional: set a background color
        );
      },
    );
  }

// Function to download PDF to local file
  Future<File> _downloadFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // Verify the temporary directory and create it if necessary
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/${Uri.parse(url).pathSegments.last}';
        final file = File(filePath);

        // Log the file path for debugging
        print('Saving file to: $filePath');

        // Write bytes to file and return the file
        await file.writeAsBytes(bytes);
        return file;
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      // Log the error for debugging
      print('Error downloading file: $e');
      throw Exception('Error downloading file: $e');
    }
  }

  void _upload(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UploadPage()),
    );
  }
}
