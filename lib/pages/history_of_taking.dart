import 'package:flutter/material.dart';

class HistoryOfTakingPage extends StatefulWidget {
  const HistoryOfTakingPage({super.key});

  @override
  State<HistoryOfTakingPage> createState() => _HistoryOfTakingPageState();
}

class _HistoryOfTakingPageState extends State<HistoryOfTakingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "History of Taking",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 25,
            //fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
