import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:material_hub/Home/displayaData/display_data.dart';
import 'package:material_hub/common_widgets/platform_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class ProcessPayment extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController phoneNumberController;
  final String userId;
  final int amount;
  final Function onLoadingChange;
  final DisplayData item;

  const ProcessPayment({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.phoneNumberController,
    required this.userId,
    required this.amount,
    required this.onLoadingChange,
    required this.item,
  });

  Future<void> _processPayment(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      onLoadingChange(true);
      try {
        final String email = emailController.text.toString();
        final String phonenumber = phoneNumberController.text.toString();

        final Map<String, dynamic> requestData = {
          "email": email,
          "phonenumber": phonenumber.toString(),
          "amount": amount.toString(),
          "userid": userId,
          "title": item.title,
          "description": item.description,
          "imageUrl": item.imageUrl,
        };

        print('Request Data: $requestData');

        final url = Uri.parse(
            'https://initiatepaymenttransaction-zronqoa4na-uc.a.run.app');

        // Send the POST request
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestData),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final String checkoutUrl = responseData['redirect_url'];

          if (await canLaunch(checkoutUrl)) {
            await launch(checkoutUrl);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) => PlatformAlertDialog(
                cancelactionText: 'close',
                title: 'Could not open Website',
                content: 'Failed to open website for payment',
                defaultactionText: 'Ok',
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Failed to initiate payment: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to proceed to payment')),
        );
      } finally {
        onLoadingChange(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (userId.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User not found. Please log in again.'),
            ),
          );
          return;
        }
        _processPayment(context);
      },
      child: const Text('Proceed to Payment'),
    );
  }
}
