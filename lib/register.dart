import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon/AuthPages/authentication.dart';
import 'package:salon/components/my_textfield.dart';

typedef void onUsersAccountCreated();

class RegisterPage extends StatefulWidget {
  final Function() onUsersAccountCreated;

  RegisterPage({required this.onUsersAccountCreated, required this.onTap});
  final Function()? onTap;
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

  // final bool isBusiness;

  Future<void> _createusersAccount() async {
    try {
      // Check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        // Create the user account
        UserCredential authResult =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AuthPage(),
        ));

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'email': emailController.text,
          'password': passwordController.text,
          'FirstName': firstNameController.text,
          'LastName': lastNameController.text,
          'BusinessLocation': ageController.text
        });
        widget.onUsersAccountCreated();

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AuthPage(),
        ));
      } else {
        // Display an error message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Passwords don't match"),
        ));
      }
    } on FirebaseAuthException catch (e) {
      showerrormessageregister(e.code);
    }
  }

  void showerrormessageregister(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: AlertDialog(
            title: Text(
              message,
            ),
          ),
        );
      },
    );
  }

  bool _validateRegisterInput() {
    //empty eroor handel gareko
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in all required fields.'),
      ));
      return false;
    }
    //first name ra last name lai character check gareko
    if (firstNameController.text.length <= 3 ||
        lastNameController.text.length <= 3) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "First name and last name should have more than 3 characters. "),
      ));
      return false;
    }
    if (ageController.text.length > 2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Age should have 2 or fewer digits."),
      ));
      return false;
    }
    return true;
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
                child: const Text('Sign up as business'),
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
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: firstNameController,
                  hintText: 'First Name',
                  obscureText: false,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                MyTextField(
                    controller: lastNameController,
                    hintText: 'Last Name',
                    obscureText: false,
                    keyboardType: TextInputType.text),
                const SizedBox(height: 10),
                MyTextField(
                  controller: ageController,
                  hintText: 'Age',
                  obscureText: false,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  keyboardType: TextInputType.text,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Container(
                      height: 40,
                      width: 180,
                      child: ElevatedButton(
                        onPressed: () async {
                          //will contain validation code and check if any fields are empty.
                          if (_validateRegisterInput()) {
                            await _createusersAccount();
                            widget.onUsersAccountCreated();
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        child: const Text('Create Users Account'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey[400],
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //         child: Text(
                //           'Or continue with',
                //           style: TextStyle(color: Colors.grey[700]),
                //         ),
                //       ),
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey[400],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 30),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       width: 80,
                //       height: 80,
                //       child:
                //           const SquareTile(imagePath: 'lib/images/google.png'),
                //     ),
                //     const SizedBox(width: 25),
                //     GestureDetector(
                //       onTap: showBusinessAlert,
                //       child: Container(
                //         width: 80,
                //         height: 80,
                //         decoration: BoxDecoration(
                //           color: Color.fromARGB(
                //               255, 62, 169, 158), // Replace with desired color
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //         child: const Center(
                //           child: Text(
                //             'Sign in as business',
                //             textAlign: TextAlign.center,
                //             style: TextStyle(
                //               color: Colors
                //                   .black, // Replace with desired text color
                //               fontSize: 12,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 30),
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
