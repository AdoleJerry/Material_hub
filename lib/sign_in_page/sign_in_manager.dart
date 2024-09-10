import 'package:flutter/foundation.dart';
import 'package:material_hub/auth/auth.dart';

class SignInManager {
  SignInManager({
    required this.auth,
    required this.isLoading,
  });
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;
}
