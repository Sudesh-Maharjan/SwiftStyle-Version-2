import 'package:flutter/material.dart';
import 'package:salon/login.dart';
import 'package:salon/register.dart';
// import 'login_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});
  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showLoginPage = true;
  void onUsersAccountCreated() {
    // Add your logic here
    print('User account created'); // Example logic
  }

  //toggle between login and register
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
        onUsersAccountCreated: onUsersAccountCreated,
      );
    }
  }
}
