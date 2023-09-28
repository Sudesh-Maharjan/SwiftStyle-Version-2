import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon/AuthPages/authentication.dart';
import 'package:salon/Businessaccountpages/BusinessSignUpPage.dart';
import 'package:salon/Businessaccountpages/Login_business.dart';
import 'package:salon/Forgotpassword.dart';
import 'package:salon/components/my_buttons.dart';
import 'package:salon/components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // LoginPage({Key? key}) : super(key: key);
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void showBusinessAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Business Account',
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 76, 175, 165),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Perform login as business
                  // Replace with your desired functionality
                  Navigator.pop(context);
                  // Navigate to business login page
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => BusinessLoginPage()),
                  // );
                },
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusinessLoginPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 125,
                    height: 21,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 62, 169, 158),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Login as business',
                        style: TextStyle(
                          backgroundColor: Color.fromARGB(255, 76, 175, 165),
                          color:
                              Colors.white, // Replace with desired text color
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 76, 175, 165),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Perform sign up as business
                  // Replace with your desired functionality
                  Navigator.pop(context);
                  // Navigate to business sign up page
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => BusinessSignUpPage()),
                  // );
                },
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BusinessSignupPage(
                                  onBusinessAccountCreated: closeBusinessAlert,
                                )));
                  },
                  child: Text(
                    'Sign up as business',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void closeBusinessAlert() {
    Navigator.pop(context);
  }

  Future<String?> getUserType(User? user) async {
    if (user != null) {
      try {
        final firestore = FirebaseFirestore.instance;

        // Check if the user document exists in 'users' collection
        final userDoc = await firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          return 'user';
        }

        // Check if the user document exists in 'businesses_user_info' collection
        final businessUserDoc = await firestore
            .collection('businesses_user_info')
            .doc(user.uid)
            .get();
        if (businessUserDoc.exists) {
          return 'business';
        }
      } catch (e) {
        print('Error getting user type: $e');
        return null;
      }
    }
    return null;
  }

  void signUserIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = authResult.user;

      if (user != null) {
        // User successfully signed in, now check their user type
        final userType = await getUserType(user);

        if (userType == 'user') {
          // Navigate to the user home screen
          print('User logged in');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AuthPage()));
        } else if (userType == 'business') {
          // Navigate to the business home screen
          print('Business logged in');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AuthPage()));
        } else {
          //vayena vani error msg yeta show garni
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Unknown user type'),
          ));
        }
      } else {
        //null case lai yeta show garne
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User is null'),
        ));
      }
    } catch (e) {
      // Handle authentication errors (e.g., invalid credentials)
      // You can show an error message or take appropriate action here
      print('Error signing in: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error signing in: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),
                Text(
                  'Welcome!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 10),
                MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    keyboardType: TextInputType.text),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ));
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: "Log In",
                  onTap: () => signUserIn(),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   width: 80,
                    //   height: 80,
                    //   child:
                    //       const SquareTile(imagePath: 'lib/images/google.png'),
                    // ),
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: showBusinessAlert,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(
                              255, 62, 169, 158), // Replace with desired color
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Sign in as business',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors
                                  .black, // Replace with desired text color
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
