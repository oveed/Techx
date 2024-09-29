import 'package:flutter/material.dart';
import 'package:techproject/screens/quiz1.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../camera.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraService _cameraService;
  int _pictureCount = 0;

  @override
  void initState() {
    super.initState();
    _cameraService = CameraService();
    _startTakingPictures();
  }

  Future<void> _startTakingPictures() async {
    await _cameraService.initialize();
    if (!Hive.isBoxOpen('picture_results')) {
      await Hive.openBox('picture_results');
    }
    _cameraService.startPictureTaking(onPictureTaken: (result) {
      setState(() {
        Hive.box('picture_results').put('picture_${_pictureCount++}', result);
      });
    });
  }

  @override
  void dispose() {
    _cameraService.stopPictureTaking();
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Blue Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade700, // Darker at the top
                  Colors.blue.shade300, // Lighter at the bottom
                ],
              ),
            ),
          ),

          // Background Half Circle Image
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),

          // Back Button "<" in the top-left corner
          Positioned(
            top: 40, // Adjust as per design
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          // Content in the Center
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Text
                  Text(
                    "We’re going to ask you 10 questions about emotional health",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 30),

                  Center(
                    child: Image.asset(
                      'assets/thinking.gif',
                      height: 100, // Adjust the size
                    ),
                  ),

                  SizedBox(height: 30),

                  // Second Text
                  Text(
                    "They'll be about your relationships with others, your image of yourself, "
                    "how you deal with demands and goals in everyday life, and also about your physical well-being.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Third Text
                  Text(
                    "Afterwards you will get your first feedback.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 100),

                  // START Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuizPage()),
                        );
                      },
                      child: Text("START!"),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
