import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon/components/my_buttons.dart';
import 'package:salon/components/my_textfield.dart';
import 'package:salon/components/square_tile.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // LoginPage({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  void signUserUp() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      //check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        addUserDetails(
          firstNameController.text.trim(),
          lastNameController.text.trim(),
          emailController.text.trim(),
          int.parse(ageController.text.trim()),
        );
      } else {
        //show th error message
        showerrormessage("Password dont match");
      }
      //pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);
      showerrormessage(e.code);
    }
  }

  Future addUserDetails(
      String firstName, String lastName, String email, int age) async {
    await FirebaseFirestore.instance.collection('users').add({
      'First Name': firstName,
      'Last Name': lastName,
      'Email': email,
      'Age': age,
    });
  }

//wrong email message popup
  void showerrormessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              message,
            ),
          );
        });
  }

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
                child: Text('Login as business'),
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
                child: Text('Sign up as business'),
              ),
            ),
          ],
        );
      },
    );
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
                const SizedBox(height: 25),
                const Icon(
                  Icons.lock,
                  size: 50,
                ),
                const SizedBox(height: 25),
                Text(
                  'Create an account',
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
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: firstNameController,
                  hintText: 'First Name',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: lastNameController,
                  hintText: 'Last Name',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: ageController,
                  hintText: 'Age',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: "Sign Up",
                  onTap: () => signUserUp(),
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
                    Container(
                      width: 80,
                      height: 80,
                      child:
                          const SquareTile(imagePath: 'lib/images/google.png'),
                    ),
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
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login  ',
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
