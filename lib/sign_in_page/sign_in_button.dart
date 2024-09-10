import 'package:flutter/material.dart';
import 'package:material_hub/common_widgets/custom_rasised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    super.key,
    required String text,
    required Color color,
    required Color textcolor,
    required VoidCallback onpressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(color: textcolor, fontSize: 15.0),
          ),
          color: color,
          onpressed: onpressed,
        );
}
