import 'package:app/screens/event_screen.dart';
import 'package:flutter/material.dart';
import '../data/events.dart' as data;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);
  static const routeName = "/";

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 42.0),
              child: Image(
                image: AssetImage('images/logo.png'),
                width: 200.0,
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (ctx, index) {
                return TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      EventScreen.routeName,
                      arguments: {"id": index},
                    );
                  },
                  child: Text(
                    data.events[index],
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                );
              },
              itemCount: data.events.length,
            ))
          ],
        ),
      ),
    );
  }
}
