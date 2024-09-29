import 'package:flutter/material.dart';
import 'package:techproject/screens/quiz5.dart';

class QuizPage4 extends StatelessWidget {
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

                // Superposition de deux LinearProgressIndicator
                Stack(
                  children: [
                    LinearProgressIndicator(
                      value: 0.4, // 20% d'orange par-dessus
                      backgroundColor: Colors.grey[400], // Pas de fond
                      color: Colors.orange, // Deuxième couleur en orange
                      minHeight: 3,
                    ),
                  ],
                ),
                SizedBox(height: 40),

                // Image au centre
                Center(
                  child: Image.asset(
                    'assets/a.jpg', // Assurez-vous que l'image existe
                    width: 150,
                    height: 150,
                  ),
                ),
                SizedBox(height: 40),

                // Question
                Text(
                  "Did something at school make you feel good today?",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),

                // Answers
                QuizOption(
                    text: "Yes, I spent time playing.",
                    onPressed: () => _goToNextPage(context)),
                QuizOption(
                    text: "Yes, I learned something new.",
                    onPressed: () => _goToNextPage(context)),
                QuizOption(
                    text: "Yes, I got along well with my friends.",
                    onPressed: () => _goToNextPage(context)),
                QuizOption(
                    text: "I didn't go to school today",
                    onPressed: () => _goToNextPage(context)),
                QuizOption(
                    text: "No, I didn't feel very good at school.",
                    onPressed: () => _goToNextPage(context)),
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
      MaterialPageRoute(builder: (context) => QuizPage5()),
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
