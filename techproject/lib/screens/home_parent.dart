import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

class ParentHomePage extends StatefulWidget {
  @override
  _ParentHomePageState createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  String? parentEmail; // To hold the parent's email
  String? kidId; // To hold the kid's ID
  List<Map<String, dynamic>> kidsResults = []; // To hold kid's results

  @override
  void initState() {
    super.initState();
    _fetchParentData();
  }

  Future<void> _fetchParentData() async {
    // Fetch the parent's email from the authenticated user
    User? user = FirebaseAuth.instance.currentUser;
    parentEmail = user?.email;
    print("aaaaaaaaaahouwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww");
    print(parentEmail);
    if (parentEmail != null) {
      await _fetchKidId(parentEmail!);
    }
  }

  Future<void> _fetchKidId(String parentEmail) async {
    // Query Firestore to get the kid ID associated with the parent's email
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('parentEmail', isEqualTo: parentEmail)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        kidId = querySnapshot.docs.first.id;
        print(
            "llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll");
        print(kidId);
      });

      if (kidId != null) {
        await _fetchKidsResults(kidId!);
      }
    } else {
      setState(() {
        print(
            "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  ");
        kidsResults = [];
      });
    }
  }

  Future<void> _fetchKidsResults(String kidId) async {
    try {
      // Query Firestore for the kid's results
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('final_picture_results')
          .where('userId', isEqualTo: kidId)
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        kidsResults = querySnapshot.docs.map((doc) {
          print('Fetched result: ${doc['finalResult']}');
          return {
            'finalResult': doc['finalResult'],
            'timestamp': (doc['timestamp'] as Timestamp).toDate(),
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching kid\'s results: $e');
    }
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
                  Colors.blue.shade700,
                  Colors.blue.shade300,
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

          // Content in the Center
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome message
                  Text(
                    "Hello Parent!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Display last test result
                  if (kidsResults.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Last Kid's Test Result:",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Result: ${kidsResults[0]['finalResult']}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Date: ${kidsResults[0]['timestamp']}",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      "No results available yet.",
                      style: TextStyle(color: Colors.white),
                    ),

                  SizedBox(height: 40),

                  // Chart Title
                  Text(
                    "Emotional Health Trend:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 10),

                  // Trend Chart
                  if (kidsResults.isNotEmpty)
                    Container(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.white),
                          ),
                          titlesData: FlTitlesData(show: false),
                          gridData: FlGridData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _getChartSpots(),
                              isCurved: true,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Back Button
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
        ],
      ),
    );
  }

  // Convert the test results into data points for the chart
  List<FlSpot> _getChartSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < kidsResults.length; i++) {
      String result = kidsResults[i]['finalResult'];
      double yValue = _convertResultToY(result);
      spots.add(FlSpot(i.toDouble(), yValue));
    }
    return spots;
  }

  // Convert result string into numerical value for the chart
  double _convertResultToY(String result) {
    switch (result.toLowerCase()) {
      case 'happy':
        return 5.0;
      case 'neutral':
        return 3.0;
      case 'sad':
        return 1.0;
      default:
        return 0.0; // Unknown result
    }
  }
}
