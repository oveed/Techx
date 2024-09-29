import 'package:camera/camera.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  Timer? _timer;
  List<Map<String, dynamic>> _resultsCache =
      []; // Cache to store results and timestamps

  Future<void> initialize() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      _isCameraInitialized = true;
    }
  }

  void startPictureTaking({required Function(String) onPictureTaken}) {
    if (_isCameraInitialized) {
      _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) async {
        String result = await _takePicture();
        _resultsCache.add({'result': result, 'timestamp': DateTime.now()});
        onPictureTaken(result);
      });

      Timer(const Duration(seconds: 10), () async {
        stopPictureTaking();
        String finalResult = _getMostFrequentResult();
        await _saveResultsToFirestore(
            finalResult); // Save all results and final result
      });
    }
  }

  Future<String> _takePicture() async {
    if (!_controller!.value.isInitialized) {
      return 'Error: Camera is not initialized.';
    }
    if (_controller!.value.isTakingPicture) {
      return 'Error: A picture is already being taken.';
    }

    try {
      XFile file = await _controller!.takePicture();
      final String filePath = file.path;
      print('Picture saved to $filePath');

      // Send the picture to the API and return the result
      String result = await _sendPictureToApi(filePath);
      return result;
    } catch (e) {
      return 'Error taking picture: $e';
    }
  }

  Future<String> _sendPictureToApi(String filePath) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.26.12.191:5000/predict'));
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        print('Response from API: ${res.body}');
        return res.body; // Return API response (e.g., 'happy', 'sad')
      } else {
        return 'Error: Failed to upload picture';
      }
    } catch (e) {
      return 'Error sending picture to API: $e';
    }
  }

  String _getMostFrequentResult() {
    // Count occurrences of each result
    Map<String, int> resultCount = {};
    for (var resultEntry in _resultsCache) {
      String result = resultEntry['result']!;
      if (resultCount.containsKey(result)) {
        resultCount[result] = resultCount[result]! + 1;
      } else {
        resultCount[result] = 1;
      }
    }

    // Find the result that occurred the most
    String mostFrequentResult = '';
    int maxCount = 0;
    resultCount.forEach((result, count) {
      if (count > maxCount) {
        mostFrequentResult = result;
        maxCount = count;
      }
    });

    print('Most frequent result: $mostFrequentResult');
    return mostFrequentResult;
  }

  Future<void> _saveResultsToFirestore(String finalResult) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Save all the picture results and final result to Firestore
        await FirebaseFirestore.instance
            .collection('final_picture_results')
            .add({
          'userId': user.uid,
          'results': _resultsCache, // Save the list of results with timestamps
          'finalResult': finalResult,
          'timestamp': FieldValue.serverTimestamp(),
        });

        print('All results and final result saved to Firestore');
      } else {
        print('Error: User is not logged in');
      }
    } catch (e) {
      print('Error saving final result to Firestore: $e');
    }
  }

  void stopPictureTaking() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
  }
}
