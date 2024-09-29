import 'package:flutter/material.dart';
import 'package:techproject/screens/quiz2.dart';

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 100), // Espace sous l'icône

                // Progress Bar
                LinearProgressIndicator(
                  value: 0.1, // 10% progress for the first question
                  backgroundColor: Colors.grey[400],
                  color: Colors.orange,
                  minHeight: 3,
                ),
                SizedBox(height: 40),

                // Image au centre
                Center(
                  child: Image.asset(
                    'assets/io.png', // Assurez-vous que l'image existe
                    width: 150,
                    height: 150,
                  ),
                ),
                SizedBox(height: 40),

                // Question
                Text(
                  "How are you feeling right now?",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),

                // Answers
                QuizOption(
                    text: "Happy", onPressed: () => _goToNextPage(context)),
                QuizOption(
                    text: "Sad", onPressed: () => _goToNextPage(context)),
                QuizOption(
                    text: "Angry", onPressed: () => _goToNextPage(context)),

                QuizOption(
                    text: "Tired", onPressed: () => _goToNextPage(context)),
                QuizOption(
                    text: "Okay", onPressed: () => _goToNextPage(context)),
              ],
            ),
          ),

          // Icone Positionnée en haut à gauche
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          // Icône de question en haut à droite
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.help_outline,
                  color: Colors.black, size: 24), // Icône d'aide
              onPressed: () {
                // Action pour l'icône de question
              },
            ),
          ),
        ],
      ),
    );
  }

  void _goToNextPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizPage2()),
    );
  }
}

// Quiz Option Button
class QuizOption extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  QuizOption({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          textStyle: TextStyle(fontSize: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
