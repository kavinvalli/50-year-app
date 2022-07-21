import 'package:app/screens/scanned_screen.dart';
import 'package:flutter/material.dart';

import './screens/home_screen.dart';
import './screens/event_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "50 Year Anniversary",
      home: const HomeScreen(title: "50 Year Anniversary"),
      routes: {
        EventScreen.routeName: (ctx) => const EventScreen(),
        ScannedScreen.routeName: (ctx) => const ScannedScreen(),
      },
    );
  }
}
