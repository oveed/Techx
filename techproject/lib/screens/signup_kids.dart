import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:techproject/screens/home_parent.dart'; // Import Parent Home Page

class KidSignupPage extends StatelessWidget {
  final TextEditingController fullNameController =
      TextEditingController(); // Full Name field
  final TextEditingController emailController =
      TextEditingController(); // Kid's Email field
  final TextEditingController parentEmailController =
      TextEditingController(); // Parent's Email field
  final TextEditingController passwordController =
      TextEditingController(); // Password field

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Signup for Kids",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Create a kid account under your supervision!",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  inputFile(label: "Full Name", controller: fullNameController),
                  inputFile(
                      label: "Email",
                      controller: emailController), // Kid's email field
                  inputFile(
                      label: "Parent Email",
                      controller:
                          parentEmailController), // Parent's email field
                  inputFile(
                      label: "Password",
                      obscureText: true,
                      controller: passwordController),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    signUpKid(context); // Trigger signup function
                  },
                  color: Color(0xFF0057A3),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Signup",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUpKid(BuildContext context) async {
    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty || // Add email field validation
        parentEmailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showDialog(context, "Empty fields", "Please fill in all fields.");
    } else {
      try {
        var parentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: parentEmailController.text)
            .where('role', isEqualTo: 'parent')
            .get();

        if (parentSnapshot.docs.isEmpty) {
          _showDialog(context, "Parent Not Found",
              "The parent email you provided does not exist.");
          return; // Stop if parent is not found
        }

        // Create the kid's account using the entered email
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, // Use kid's email for their account
          password: passwordController.text,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'fullName': fullNameController.text,
          'email': emailController.text,
          'parentEmail': parentEmailController.text,
          'role': 'kid',
        });

        print('Kid account created successfully: ${userCredential.user!.uid}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ParentHomePage()),
        );
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'email-already-in-use') {
          message = 'This email is already in use.';
        } else if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'invalid-email') {
          message = 'The email address is not valid.';
        } else {
          message = e.message ?? 'An undefined error occurred.';
        }
        _showDialog(context, "Error", message);
        print('Error creating kid account: ${e.code} - ${e.message}');
      } catch (e) {
        _showDialog(context, "Error",
            "An unexpected error occurred. Please try again.");
        print('Error creating kid account: $e');
      }
    }
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

// Widget for input fields
Widget inputFile({label, obscureText = false, controller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: label == "Email" || label == "Parent Email"
            ? TextInputType.emailAddress
            : TextInputType.text,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}
