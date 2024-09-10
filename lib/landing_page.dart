import 'package:flutter/material.dart';
import 'package:material_hub/auth/auth.dart';
import 'package:material_hub/Home/loading_page.dart';
import 'package:material_hub/services/database.dart';
import 'package:material_hub/sign_in_page/sign_in_page.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<CustomUser?>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          CustomUser? user = snapshot.data;
          if (user == null) {
            return const SignInPage();
          } else {
            return Provider<CustomUser>.value(
              value: user,
              child: Provider<Database>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                child: const LoadingPage(),
              ),
            );
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
