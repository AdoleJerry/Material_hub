<<<<<<< HEAD
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_hub/Home/displayaData/display_data.dart';
import 'package:material_hub/Home/payment/process_payment.dart';
import 'package:material_hub/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:pdf_thumbnail/pdf_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class PaymentPage extends StatefulWidget {
  final DisplayData item;

  const PaymentPage({super.key, required this.item});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool isLoading = false;
  CustomUser? _user;
  File? _pdfFile; // Store the downloaded PDF file

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _downloadPdfToCache(
        widget.item.imageUrl); // Download the PDF when page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment for ${widget.item.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text('Price: ${widget.item.price}'),
              const SizedBox(height: 16),
              // Display PDF thumbnail
              _pdfFile != null
                  ? Expanded(
                      child: PdfThumbnail.fromFile(
                        _pdfFile!.path,
                        currentPage: 1, // Display the first page of the PDF
                        height: 390, // Adjust thumbnail size
                        backgroundColor: Colors.grey[200]!,
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ProcessPayment(
                formKey: _formKey,
                emailController: _emailController,
                phoneNumberController: _phoneNumberController,
                userId: _user?.uid ?? '',
                amount: widget.item.price,
                onLoadingChange: (isLoading) {
                  setState(() {
                    this.isLoading = isLoading;
                  });
                },
                item: widget.item,
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initializeUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      setState(() {
        _user = CustomUser(uid: firebaseUser.uid);
        _emailController.text = firebaseUser.email ?? '';
      });
    }
  }

  // Method to download the PDF and cache it locally
  Future<void> _downloadPdfToCache(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // Get the cache directory path
        final cacheDir = await getTemporaryDirectory();

        // Extract file name and directory path
        final fileName = Uri.parse(url).pathSegments.last;
        final filePath = '${cacheDir.path}/$fileName';

        // Create the file and write the content
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        setState(() {
          _pdfFile = file; // Set the downloaded PDF file to display in UI
        });
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }
}
=======
import 'package:flutter/material.dart';
import 'package:material_hub/Home/displayaData/display_data.dart';
import 'package:material_hub/Home/payment/process_payment.dart';
import 'package:material_hub/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentPage extends StatefulWidget {
  final DisplayData item;

  const PaymentPage({super.key, required this.item});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool isLoading = false;
  CustomUser? _user;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment for ${widget.item.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text('Price: ${widget.item.price}'),
              const SizedBox(height: 16),
              Expanded(
                child: Image.network(
                  widget.item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.broken_image),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ProcessPayment(
                formKey: _formKey,
                emailController: _emailController,
                phoneNumberController: _phoneNumberController,
                userId: _user?.uid ?? '',
                amount: widget.item.price,
                onLoadingChange: (isLoading) {
                  setState(() {
                    isLoading = true;
                  });
                },
                item: widget.item,
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initializeUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      setState(() {
        _user = CustomUser(uid: firebaseUser.uid);
        _emailController.text = firebaseUser.email ?? '';
      });
    }
  }
}
>>>>>>> 8ddb56bed4ea68597595ff99aef8608671358442
