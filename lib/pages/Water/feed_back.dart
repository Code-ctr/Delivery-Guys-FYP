import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedBack extends StatefulWidget {
  final String userName;
  final String driverName;
  final String deliveryId; // Unique ID for the delivery

  const FeedBack({
    super.key,
    required this.userName,
    required this.driverName,
    required this.deliveryId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    _checkIfFeedbackProvided();
  }

  Future<void> _checkIfFeedbackProvided() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasProvidedFeedback =
        prefs.getBool('feedback_${widget.deliveryId}') ?? false;

    if (hasProvidedFeedback) {
      // If feedback already provided, navigate away from this screen
      Navigator.of(context).pop();
    }
  }
      // Submit feedback to the server or Firebase
  Future<void> _submitFeedback() async {
  if (_rating > 0) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('feedback_${widget.deliveryId}', true);

    final feedbackData = {
      'userName': widget.userName,
      'driverName': widget.driverName,
      'rating': _rating,
      'time': DateTime.now().toIso8601String(),
    };

    // Example: Save feedback to Firebase
    await FirebaseFirestore.instance
        .collection('feedback')
        .doc(widget.deliveryId)
        .set(feedbackData);

    Navigator.of(context).pop();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please provide a rating before submitting.'),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Your Delivery'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Rate the delivery by ${widget.driverName}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating
                      ? Icons.star
                      : Icons.star_border_outlined,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitFeedback,
            child: const Text('Submit Feedback'),
          ),
        ],
      ),
    );
  }
}
