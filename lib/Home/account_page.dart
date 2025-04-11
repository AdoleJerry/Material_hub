import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_hub/Home/account_page_sub/uploads_page.dart';
import 'package:material_hub/Home/account_page_sub/Tranasaction_history.dart';
import 'package:material_hub/auth/auth.dart';
import 'package:material_hub/common_widgets/avatar.dart';
import 'package:material_hub/common_widgets/platform_alert_dialog.dart';
import 'package:material_hub/sign_in_page/sign_in_page.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? userType;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    final user = Provider.of<CustomUser>(context, listen: false);
    final doc = await FirebaseFirestore.instance
        .collection('user_data')
        .doc(user.uid)
        .get();

    if (mounted) {
      setState(() {
        userType = doc['role'];
      });
    }
  }

  Future<void> _signout(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SignInPage()),
        (route) => false,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignout(BuildContext context) async {
    final didRequestSignout = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      defaultactionText: 'Logout',
      cancelactionText: 'Cancel',
    ).show(context);
    if (didRequestSignout == true) {
      return _signout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Account',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: _buildUser(user),
        ),
      ),
      body: _accountPageBody(context),
    );
  }

  Widget _buildUser(CustomUser user) {
    return Column(
      children: [
        Avatar(
          photoUrl: user.photoUrl,
          raduis: 50,
          color: Colors.white,
          email: user.email,
        ),
        const SizedBox(
          height: 1,
        ),
      ],
    );
  }

  Widget _accountPageBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Transaction History'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransactionHistory(),
                    ),
                  );
                },
              ),
              if (userType == 'lecturer')
                ListTile(
                  leading: const Icon(Icons.upload_file),
                  title: const Text('Uploads'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UploadsPage(),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _confirmSignout(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}
