<<<<<<< HEAD
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_hub/auth/auth.dart';
import 'package:material_hub/common_widgets/platform_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    super.key,
    required this.photoUrl,
    required this.raduis,
    this.color = Colors.black54,
    this.email,
  });

  final String? photoUrl;
  final double raduis;
  final Color color;
  final String? email;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;
  XFile? _selectedImage;
  bool _isLoading = false; // State to track if the image is loading

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.photoUrl;
  }

  Future<void> _pickImage() async {
    if (await _requestPermissions()) {
      try {
        final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80, // Compress the image to a lower quality
        );
        if (pickedFile != null) {
          setState(() {
            _selectedImage = pickedFile; // Set the selected image for preview
            _isLoading = true; // Start loading indicator
          });

          final auth = Provider.of<AuthBase>(context, listen: false);
          final user = await auth.currentUser();

          // Call the service to upload the image and save the profile picture details
          final newDownloadUrl = await auth.uploadAndSaveProfilePicture(
              user!.uid, pickedFile.path);

          // Update the state with the new image URL
          setState(() {
            _imageUrl = newDownloadUrl; // Set the new profile picture URL
            _isLoading = false; // Stop loading indicator
          });

          // Show success dialog
          await PlatformAlertDialog(
            title: 'Success',
            content: 'Profile picture uploaded successfully!',
            defaultactionText: 'OK',
            cancelactionText: 'Close',
          ).show(context);
        }
      } catch (e) {
        // Show error dialog if the upload fails
        await PlatformAlertDialog(
          title: 'Upload Failed',
          content: 'Image failed to upload. Please try again.',
          defaultactionText: 'OK',
          cancelactionText: 'Cancel',
        ).show(context);

        setState(() {
          _isLoading = false; // Stop loading indicator if there's an error
        });
        print('Error: $e');
      }
    }
  }

  Future<bool> _requestPermissions() async {
    final status = await [
      Permission.camera,
      Permission.storage,
    ].request();

    return status[Permission.camera]!.isGranted &&
        status[Permission.storage]!.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.color,
                width: 3.0,
              ),
            ),
            child: CircleAvatar(
              radius: widget.raduis,
              backgroundColor: Colors.black12,
              backgroundImage: _selectedImage != null
                  ? FileImage(File(_selectedImage!.path))
                  : (_imageUrl != null ? NetworkImage(_imageUrl!) : null),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ) // Show loading indicator while uploading
                  : (_imageUrl == null && _selectedImage == null
                      ? Icon(
                          Icons.person_2_rounded,
                          size: widget.raduis,
                          color: Colors.white,
                        )
                      : null),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          widget.email ?? '',
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }
}
=======
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_hub/auth/auth.dart';
import 'package:material_hub/common_widgets/platform_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    super.key,
    required this.photoUrl,
    required this.raduis,
    this.color = Colors.black54,
    this.email,
  });

  final String? photoUrl;
  final double raduis;
  final Color color;
  final String? email;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;
  XFile? _selectedImage;
  bool _isLoading = false; // State to track if the image is loading

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.photoUrl;
  }

  Future<void> _pickImage() async {
    if (await _requestPermissions()) {
      try {
        final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80, // Compress the image to a lower quality
        );
        if (pickedFile != null) {
          setState(() {
            _selectedImage = pickedFile; // Set the selected image for preview
            _isLoading = true; // Start loading indicator
          });

          final auth = Provider.of<AuthBase>(context, listen: false);
          final user = await auth.currentUser();

          // Call the service to upload the image and save the profile picture details
          final newDownloadUrl = await auth.uploadAndSaveProfilePicture(
              user!.uid, pickedFile.path);

          // Update the state with the new image URL
          setState(() {
            _imageUrl = newDownloadUrl; // Set the new profile picture URL
            _isLoading = false; // Stop loading indicator
          });

          // Show success dialog
          await PlatformAlertDialog(
            title: 'Success',
            content: 'Profile picture uploaded successfully!',
            defaultactionText: 'OK',
            cancelactionText: 'Close',
          ).show(context);
        }
      } catch (e) {
        // Show error dialog if the upload fails
        await PlatformAlertDialog(
          title: 'Upload Failed',
          content: 'Image failed to upload. Please try again.',
          defaultactionText: 'OK',
          cancelactionText: 'Cancel',
        ).show(context);

        setState(() {
          _isLoading = false; // Stop loading indicator if there's an error
        });
        print('Error: $e');
      }
    }
  }

  Future<bool> _requestPermissions() async {
    final status = await [
      Permission.camera,
      Permission.storage,
    ].request();

    return status[Permission.camera]!.isGranted &&
        status[Permission.storage]!.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.color,
                width: 3.0,
              ),
            ),
            child: CircleAvatar(
              radius: widget.raduis,
              backgroundColor: Colors.black12,
              backgroundImage: _selectedImage != null
                  ? FileImage(File(_selectedImage!.path))
                  : (_imageUrl != null ? NetworkImage(_imageUrl!) : null),
              child: _isLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ) // Show loading indicator while uploading
                  : (_imageUrl == null && _selectedImage == null
                      ? Icon(
                          Icons.person_2_rounded,
                          size: widget.raduis,
                          color: Colors.white,
                        )
                      : null),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          widget.email ?? '',
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }
}
>>>>>>> 8ddb56bed4ea68597595ff99aef8608671358442
