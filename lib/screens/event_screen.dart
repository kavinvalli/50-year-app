import 'dart:convert';

import 'package:app/screens/scanned_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../data/events.dart' as data;

class EventScreen extends StatelessWidget {
  const EventScreen({Key? key}) : super(key: key);
  static const routeName = "/events";

  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(data.events[arg["id"]]),
      ),
      body: Center(
        child: TextButton(
          child: const Text("Scan"),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MobileScanner(
                  allowDuplicates: false,
                  onDetect: (barcode, args) {
                    if (barcode.rawValue == null) {
                      Navigator.of(context).pop();
                    } else {
                      final String code = barcode.rawValue!;
                      final response =
                          Map<String, dynamic>.from(json.decode(code));
                      debugPrint(")(()()()()(()()()()()()()()()");
                      print(response);
                      debugPrint(")(()()()()(()()()()()()()()()");
                      Navigator.of(context)
                          .pushNamed(ScannedScreen.routeName, arguments: {
                        'alumni_id': response['id'],
                        'alumni_name': response['name'],
                        'alumni_gender': response['gender'],
                        'alumni_passing_year': response['passing_year'],
                        'alumni_mobile': response['mobile'],
                        'number_of_members': response['number_of_members'],
                        'event_id_qr': response['event_id'],
                        'event_id_our': arg["id"],
                      });
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
