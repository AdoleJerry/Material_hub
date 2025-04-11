import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_hub/auth/auth.dart';
import 'package:material_hub/sign_in_page/email_sign_in_page/email_sign_in_form_stateful.dart';
import 'package:material_hub/sign_in_page/email_sign_in_page/validators.dart';
import 'package:material_hub/user_type/user_type.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel({
    this.role = UserType.student,
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
    required this.auth,
  });

  String email;
  String password;
  UserType role;
  EmailSignInFormType formType;
  bool isLoading;
  final AuthBase auth;
  bool submitted;
  CustomUser? user;

  bool get isSignInMode => formType == EmailSignInFormType.register;

  bool get isFormValid =>
      emailValidator.isValid(email) && passwordValidator.isValid(password);

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  void updateRole(UserType role) {
    this.role = role;
    notifyListeners();
  }

  Future<void> submit() async {
    updateWith(
      submitted: true,
      isLoading: true,
    );
    try {
      CustomUser? user;
      if (formType == EmailSignInFormType.signIn) {
        try {
          user = await auth.signInWithEmailAndPassword(email, password);
        } catch (e) {
          throw PlatformException(
            code: 'ERROR_USER_NOT_FOUND',
            message: 'No user found for the provided email.',
          );
        }
      } else {
        try {
          user =
              await auth.createUserWithEmailAndPassword(email, password, role);
          if (user != null) {
            await auth.setUserRole(user.uid, role);
          }
        } catch (e) {
          throw PlatformException(
            code: 'ERROR_USER_CREATION_FAILED',
            message: 'Failed to create user with the provided email.',
          );
        }
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  String? get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidpasswordErrorText : null;
  }

  String? get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  void toggleFormType() {
    final newFormType = formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: newFormType,
      submitted: false,
      isLoading: false,
    );
    notifyListeners();
  }

  void updateEmail(String email) {
    updateWith(email: email);
    notifyListeners();
  }

  void updatePassword(String password) {
    updateWith(password: password);
    notifyListeners();
  }

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
  }
}
