import 'package:flutter/material.dart';

class AvatarSelectable extends StatelessWidget {
  const AvatarSelectable({super.key}) : super();

  @override
  Widget build(BuildContext context) {
    return const Stack(fit: StackFit.expand, children: [
      Icon(
        Icons.person_2_outlined,
      ),
    ]);
  }
}
