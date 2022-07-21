import 'dart:convert';

import 'package:app/screens/event_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../data/events.dart' as data;

class ScannedScreen extends StatefulWidget {
  const ScannedScreen({Key? key}) : super(key: key);

  static const routeName = "/scanned";

  @override
  State<ScannedScreen> createState() => _ScannedScreenState();
}

class _ScannedScreenState extends State<ScannedScreen> {
  var _isLoading = false;
  void addAttendance({required int eventId, required int alumniId}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      debugPrint("Here");
      final response = await http.post(
        Uri.https('50year.exun.co', '/api/attend'),
        body: json.encode({
          'eventId': eventId,
          'alumniId': alumniId,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
        },
      );
      setState(() {
        _isLoading = false;
      });
      final res = json.decode(response.body);
      if (res['success']) {
        Navigator.of(context)
            .popUntil(ModalRoute.withName(EventScreen.routeName));
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var numberOfMembersHere = arg['number_of_members'];

    void changeNumberOfMembersHere(int num) {
      setState(() {
        numberOfMembersHere = num;
        print(numberOfMembersHere);
      });
    }

    return Scaffold(
        // backgroundColor: const Color(0xffbe934a),
        // appBar: AppBar(
        //   title: Text(arg["alumni_name"]),
        // ),
        body: Center(
      child: arg['event_id_qr'] - 1 == arg['event_id_our']
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  arg["alumni_name"],
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12.0),
                Text("Event Name: ${data.events[arg['event_id_qr'] - 1]}"),
                Text("Mobile: ${arg['alumni_mobile']}"),
                Text("Passing Year: ${arg['alumni_passing_year']}"),
                Text("Gender: ${arg['alumni_gender']}"),
                Text("Number of Members: $numberOfMembersHere"),
                TextButton(
                  onPressed: () => {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return ChangeNumberMembers(
                          maxNumber: data
                              .eventsMaxNumberOfMembers[arg["event_id_qr"] - 1],
                          eventId: arg["event_id_qr"],
                          alumniId: arg["alumni_id"],
                        );
                      },
                    )
                  },
                  child:
                      const Text("Change Number of Members (includes alumni)"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).popUntil(
                            ModalRoute.withName(EventScreen.routeName));
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => addAttendance(
                        eventId: arg["event_id_qr"],
                        alumniId: arg["alumni_id"],
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Approve"),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "The QR Code shown is for the wrong event.",
                  style: TextStyle(fontSize: 32.0),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName(EventScreen.routeName));
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(fontSize: 24.0),
                  ),
                )
              ],
            ),
    ));
  }
}

class ChangeNumberMembers extends StatefulWidget {
  final int? maxNumber;
  final int eventId;
  final int alumniId;

  const ChangeNumberMembers({
    Key? key,
    this.maxNumber,
    required this.eventId,
    required this.alumniId,
  }) : super(key: key);

  @override
  State<ChangeNumberMembers> createState() => _ChangeNumberMembersState();
}

class _ChangeNumberMembersState extends State<ChangeNumberMembers> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  void changeNumberMaxMembers(
      {required int eventId,
      required int alumniId,
      required int numberOfMembers}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      debugPrint("Here");
      final response = await http.post(
        Uri.https('50year.exun.co', '/api/change-number-of-members'),
        body: json.encode({
          'eventId': eventId,
          'alumniId': alumniId,
          'number_of_members': numberOfMembers,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
        },
      );
      setState(() {
        _isLoading = false;
      });
      final res = json.decode(response.body);
      if (res['success']) {
        Navigator.of(context).pop();
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  TextEditingController _maxNumberEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: SizedBox(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _maxNumberEditingController,
                      decoration: const InputDecoration(
                          labelText: "Number of people (including alumni)"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a value";
                        }
                        if (widget.maxNumber != null) {
                          if (int.parse(value) > widget.maxNumber!) {
                            return 'Only ${widget.maxNumber} number of people allowed.';
                          }
                        }
                        return null;
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          changeNumberMaxMembers(
                            eventId: widget.eventId,
                            alumniId: widget.alumniId,
                            numberOfMembers: int.parse(
                              _maxNumberEditingController.text,
                            ),
                          );
                        }
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Submit"),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
