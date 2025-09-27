import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:delivery_guys_fyp/pages/FireBase/fire_registeration.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  final String name;
  final String role;

  const History({super.key, required this.name, required this.role});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final AuthService authService = AuthService();
  String? show;
  @override
  void initState() {
    super.initState();
    setdata();
  }

  void setdata() {
    if (widget.role == 'driverName') {
      show = 'userName';
    } else {
      show = 'driverName';
    }
  }

  Widget buildStarRating(int rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 105, 164, 211),
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Colors.blueAccent,
        actions: const [ManageProfilePage()],
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: authService.getUserFeedbackHistory(
              widget.role, widget.name), // Call the method from AuthService
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading feedback'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No feedback available'));
            } else {
              final feedbackList = snapshot.data!;
              final latestFeedback = feedbackList.first;
              final otherFeedback = feedbackList.sublist(1);

              return Center(
                child: Container(
                  height: 550,
                  width: 390,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 0),
                      Image.asset("lib/images/Tank.png"),
                      Text(
                        latestFeedback[show],
                        style: const TextStyle(
                          color: Color.fromARGB(255, 39, 67, 90),
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 135.0), // Add some padding if needed
                          child: buildStarRating(latestFeedback['rating']),
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: otherFeedback.map((feedback) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        feedback[show],
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 39, 67, 90),
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      buildStarRating(feedback['rating']),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
