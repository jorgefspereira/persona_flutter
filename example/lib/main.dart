import 'dart:async';

import 'package:flutter/material.dart';
import 'package:persona_flutter/persona_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late InquiryConfiguration _configuration;

  late StreamSubscription<InquiryCanceled> _streamCanceled;
  late StreamSubscription<InquiryError> _streamError;
  late StreamSubscription<InquiryComplete> _streamComplete;
  late StreamSubscription<InquiryEventOccurred> _streamEvent;

  @override
  void initState() {
    super.initState();

    _configuration = TemplateIdConfiguration(
      templateId: "itmpl_Q6ymLRwKfY8PGEjqsCjhUUfu",
      environment: InquiryEnvironment.sandbox,
      returnCollectedData: true,
    );

    _streamCanceled = PersonaInquiry.onCanceled.listen(_onCanceled);
    _streamError = PersonaInquiry.onError.listen(_onError);
    _streamComplete = PersonaInquiry.onComplete.listen(_onComplete);
    _streamEvent = PersonaInquiry.onEvent.listen(_onEvent);
  }

  @override
  void dispose() {
    _streamCanceled.cancel();
    _streamError.cancel();
    _streamComplete.cancel();
    _streamEvent.cancel();
    super.dispose();
  }

  void _onCanceled(InquiryCanceled event) {
    debugPrint("InquiryCanceled");
    debugPrint("- inquiryId: ${event.inquiryId}");
    debugPrint("- sessionToken: ${event.sessionToken}");
  }

  void _onError(InquiryError event) {
    debugPrint("InquiryError");
    debugPrint("- error: ${event.error}");
  }

  void _onComplete(InquiryComplete event) {
    debugPrint("InquiryComplete");
    debugPrint("- inquiryId: ${event.inquiryId}");
    debugPrint("- status: ${event.status}");

    debugPrint("- fields:");
    for (var key in event.fields.keys) {
      debugPrint("-- key: $key, value: ${event.fields[key]}");
    }

    if (event.collectedData != null) {
      debugPrint("- collectedData:");
      debugPrint(event.collectedData.toString());
    }
  }

  void _onEvent(InquiryEventOccurred event) {
    debugPrint("InquiryEventOccurred");
    debugPrint("- type: ${event.type}");
    if (event.inquiryId != null) debugPrint("- inquiryId: ${event.inquiryId}");
    if (event.sessionToken != null)
      debugPrint("- sessionToken: ${event.sessionToken}");
    if (event.name != null) debugPrint("- name: ${event.name}");
    if (event.path != null) debugPrint("- path: ${event.path}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.grey[200],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    PersonaInquiry.init(configuration: _configuration);
                    PersonaInquiry.start();
                  },
                  child: const Text("Start Inquiry"),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    PersonaInquiry.dispose();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Dispose Inquiry"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
