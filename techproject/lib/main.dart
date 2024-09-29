import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:techproject/screens/login.dart';
import 'package:techproject/screens/signup.dart';
import 'package:techproject/screens/signup_kids.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  await Hive.initFlutter();
  await Hive.openBox('picture_results');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      home: const MyAppHomePage(),
    );
  }
}

class MyAppHomePage extends StatefulWidget {
  const MyAppHomePage({Key? key}) : super(key: key);

  @override
  _MyAppHomePageState createState() => _MyAppHomePageState();
}

class _MyAppHomePageState extends State<MyAppHomePage> {
  // Track which role is selected: true for Parent, false for Kid
  bool isParent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/Parents-pana.png",
              width: 350,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            const Text(
              "NAME",
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Create an account to get started ",
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),

            // Toggle for Parent or Kid
            Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              width: 200,
              decoration: BoxDecoration(
                color: Color(0xFF0057A3),
                borderRadius:
                    BorderRadius.circular(20), // Smaller border radius
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isParent = true;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: isParent ? Colors.white : Colors.grey,
                          size: 35, // Smaller icon size
                        ),
                        Text(
                          "Parent",
                          style: TextStyle(
                            color: isParent ? Colors.white : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isParent = false;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.child_care,
                          color: isParent ? Colors.grey : Colors.white,
                          size: 35, // Smaller icon size
                        ),
                        Text(
                          "Kid",
                          style: TextStyle(
                            color: isParent ? Colors.grey : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            Column(
              children: <Widget>[
                MaterialButton(
                  minWidth: 300,
                  height: 60,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  minWidth: 300,
                  height: 60,
                  onPressed: () {
                    // Navigate to either SignupPage or KidSignupPage based on isParent
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            isParent ? SignupPage() : KidSignupPage(),
                      ),
                    );
                  },
                  color: const Color(0xFF0057A3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "Signup",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
