import 'package:flutter/material.dart';
import 'package:material_hub/sign_in_page/email_sign_in_page/email_sign_in_form_change_notifier.dart';
import 'package:material_hub/user_type/user_type.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({
    super.key,
    required this.role,
  });

  final UserType role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInFormChangeNotifier.create(context, role),
          ),
        ),
      ),
    );
  }
}
