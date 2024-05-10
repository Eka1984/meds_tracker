import 'package:flutter/material.dart';
import 'home.dart'; // Import the home page

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    // Perform any initialization tasks here
    // For example, you can fetch data, load resources, etc.
    // Once initialization is complete, navigate to the home page
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate initialization process with a delay
    await Future.delayed(Duration(seconds: 3));
    // Navigate to the home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Loading indicator
      ),
    );
  }
}