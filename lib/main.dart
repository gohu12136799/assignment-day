import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const AssignmentDayApp());
}

class AssignmentDayApp extends StatelessWidget {
  const AssignmentDayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment Day',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
