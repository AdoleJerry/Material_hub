<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:material_hub/common_widgets/custom_rasised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    super.key,
    required String asset,
    required String text,
    required Color color,
    required Color textcolor,
    required VoidCallback onpressed,
  }) : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(asset),
              Text(
                text,
                style: TextStyle(color: textcolor, fontSize: 15.0),
              ),
              Opacity(
                opacity: 0.0,
                child: Image.asset(asset),
              ),
            ],
          ),
          color: color,
          onpressed: onpressed,
        );
}
=======
import 'package:flutter/material.dart';
import 'package:material_hub/common_widgets/custom_rasised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    super.key,
    required String asset,
    required String text,
    required Color color,
    required Color textcolor,
    required VoidCallback onpressed,
  }) : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(asset),
              Text(
                text,
                style: TextStyle(color: textcolor, fontSize: 15.0),
              ),
              Opacity(
                opacity: 0.0,
                child: Image.asset(asset),
              ),
            ],
          ),
          color: color,
          onpressed: onpressed,
        );
}
>>>>>>> 8ddb56bed4ea68597595ff99aef8608671358442
