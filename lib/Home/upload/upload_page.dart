import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:material_hub/Home/upload/upload_validator.dart';
import 'package:material_hub/common_widgets/platform_alert_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

class UploadPage extends StatefulWidget with TitleAndPriceValidators {
  UploadPage({
    super.key,
    this.fileName,
    this.filePath,
  });
  final String? filePath;
  final String? fileName;

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String? _filePath;
  String? _fileName;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _titleFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      setState(() {
        _filePath = result.files.single.path!;
        _fileName = basename(_filePath!);
      });
    }
  }

  Future<void> _submitDetails(
    BuildContext context,
    String title,
    int price,
    String description,
    String? filePath,
    String fileName,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && _filePath != null) {
      try {
        File file = File(_filePath!);
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child('sharedStream/${user.uid}/$_fileName')
            .putFile(file);

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('shared_stream').add({
          'title': title,
          'price': price,
          'description': description,
          'createdAt': Timestamp.now(),
          'downloadUrl': downloadUrl,
          'email': user.email,
          'userid': user.uid,
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Upload complete'),
              content: const Text('Your file has been uploaded successfully.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        Navigator.pop(context);
      } on FirebaseException catch (e) {
        String errorMessage = 'File could not upload';
        if (e.code == 'canceled') {
          errorMessage = 'Upload canceled. Please try again.';
        }
        await PlatformAlertDialog(
          title: 'Upload failed',
          content: errorMessage,
          defaultactionText: 'Ok',
          cancelactionText: 'Cancel',
        ).show(context);
      } catch (e) {
        await PlatformAlertDialog(
          title: 'Upload failed',
          content: 'An unexpected error occurred',
          defaultactionText: 'Ok',
          cancelactionText: 'Cancel',
        ).show(context);
      }
    } else {
      await PlatformAlertDialog(
        title: 'Select File',
        content: 'File not selected',
        defaultactionText: 'Ok',
        cancelactionText: 'Cancel',
      ).show(context);
    }
  }

  TextField buildTitleTextField() {
    return TextField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Title',
        labelStyle: TextStyle(color: Colors.black),
        enabled: true,
      ),
      autocorrect: true,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      focusNode: _titleFocusNode,
      textCapitalization: TextCapitalization.words,
    );
  }

  TextField buildPriceTextField() {
    return TextField(
      controller: _priceController,
      decoration: const InputDecoration(
        labelText: 'Price',
        labelStyle: TextStyle(color: Colors.black),
        enabled: true,
      ),
      autocorrect: true,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      focusNode: _priceFocusNode,
    );
  }

  TextField buildDescriptionTextField() {
    return TextField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        labelStyle: TextStyle(color: Colors.black),
        enabled: true,
      ),
      autocorrect: true,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      focusNode: _descriptionFocusNode,
      textCapitalization: TextCapitalization.words,
      maxLines: 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              IconButton(
                onPressed: _filePicker,
                icon: Icon(
                  _filePath != null ? Icons.check_circle : Icons.file_open,
                ),
                color: _filePath != null ? Colors.green : null,
                iconSize: 50,
              ),
              const SizedBox(
                height: 20,
              ),
              buildTitleTextField(),
              const SizedBox(height: 10),
              buildPriceTextField(),
              const SizedBox(height: 20),
              buildDescriptionTextField(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final int? price = int.tryParse(_priceController.text);
                  if (price != null) {
                    _submitDetails(
                      context,
                      _titleController.text,
                      price,
                      _descriptionController.text,
                      _filePath,
                      _fileName!,
                    );
                  } else {
                    // Handle the error when price is not a valid integer
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Invalid Price'),
                          content: const Text(
                              'Please enter a valid number for the price.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
