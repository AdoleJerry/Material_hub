import 'package:flutter/material.dart';
import 'package:material_hub/common_widgets/custom_rasised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    super.key,
    required String text,
    required VoidCallback? onPressed,
    super.color = Colors.white,
  }) : super(
          child: Text(
            text,
            style: const TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          height: 44.0,
          borderRadius: 4.0,
          onpressed: onPressed,
        );
}
