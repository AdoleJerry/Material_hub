import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:material_hub/Home/displayaData/display_data.dart';
import 'package:material_hub/common_widgets/platform_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class ProcessPayment extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController phoneNumberController;
  final String userId;
  final int amount;
  final Function(bool) onLoadingChange;
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

  @override
  _ProcessPaymentState createState() => _ProcessPaymentState();
}

class _ProcessPaymentState extends State<ProcessPayment> {
  bool _isLoading = false;

  Future<void> _processPayment(BuildContext context) async {
    if (widget.formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      widget.onLoadingChange(true);

      try {
        final String email = widget.emailController.text.toString();
        final String phonenumber = widget.phoneNumberController.text.toString();

        final Map<String, dynamic> requestData = {
          "email": email,
          "phonenumber": phonenumber,
          "amount": widget.amount.toString(),
          "userid": widget.userId,
          "title": widget.item.title,
          "description": widget.item.description,
          "imageUrl": widget.item.imageUrl,
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
                cancelactionText: 'Close',
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
        setState(() {
          _isLoading = false;
        });
        widget.onLoadingChange(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (widget.userId.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User not found. Please log in again.'),
            ),
          );
          return;
        }
        _processPayment(context);
      },
      child: _isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2,
              ),
            )
          : const Text('Proceed to Payment'),
    );
  }
}
