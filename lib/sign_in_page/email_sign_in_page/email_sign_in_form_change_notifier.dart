import 'package:flutter/material.dart';
import 'package:material_hub/common_widgets/form_submit_button.dart';
import 'package:material_hub/common_widgets/platform_alert_dialog.dart';
import 'package:material_hub/sign_in_page/email_sign_in_page/email_sign_in_change_model.dart';
import 'package:material_hub/user_type/user_type.dart';
import 'package:provider/provider.dart';
import '../../auth/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  const EmailSignInFormChangeNotifier({
    super.key,
    required this.model,
    required this.role,
  });
  final EmailSignInChangeModel model;
  final UserType role;

  static Widget create(BuildContext context, UserType role) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(auth: auth, role: role),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) => EmailSignInFormChangeNotifier(
          model: model,
          role: role,
        ),
      ),
    );
  }

  @override
  State<EmailSignInFormChangeNotifier> createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
    } catch (e) {
      print(e);
      await PlatformAlertDialog(
        title: 'Sign in Failed',
        cancelactionText: 'Cancel',
        content: 'Incorrect details',
        defaultactionText: 'Ok',
      ).show(context);
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      const SizedBox(height: 16.0),
      _buildPasswordTextField(),
      const SizedBox(height: 16.0),
      _buildRoleField(),
      const SizedBox(height: 16.0),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      TextButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        child: Text(model.secondaryButtonText),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Colors.white),
        hintText: 'password',
        errorText: model.passwordErrorText,
        enabled: !model.isLoading,
      ),
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      textInputAction: TextInputAction.done,
      onChanged: model.updatePassword,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Colors.white),
        hintText: 'example@gmail.com',
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: model.updateEmail,
      focusNode: _emailFocusNode,
      onEditingComplete: _emailEditingComplete,
    );
  }

  DropdownButtonFormField<UserType> _buildRoleField() {
    return DropdownButtonFormField<UserType>(
      iconEnabledColor: Colors.white,
      iconDisabledColor: const Color.fromRGBO(0, 0, 0, 1),
      dropdownColor: Colors.white,
      value: model.role,
      onChanged: !model.isLoading && model.isSignInMode
          ? (UserType? newValue) {
              if (newValue != null) {
                model.updateRole(newValue);
              }
            }
          : null,
      items: UserType.values.map((UserType userType) {
        return DropdownMenuItem<UserType>(
          value: userType,
          child: Text(userType.toString().split('.').last),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'Role',
        labelStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildChildren(),
      ),
    );
  }
}
