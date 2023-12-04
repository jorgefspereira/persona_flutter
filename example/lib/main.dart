import 'dart:async';

import 'package:flutter/material.dart';
import 'package:persona_flutter/persona_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late InquiryConfiguration _configuration;

  StreamSubscription<InquiryCanceled>? _streamCanceled;
  StreamSubscription<InquiryError>? _streamError;
  StreamSubscription<InquiryComplete>? _streamComplete;

  @override
  void initState() {
    super.initState();
    _configuration = TemplateIdConfiguration(
      environmentId: "env_YWAFSMCNEoGUB2MYXCh5SAz8",
      templateId: "itmpl_amzaNEALpuAj83AeFp8kwgJV",
      environment: InquiryEnvironment.production,
      theme: InquiryTheme(
        source: InquiryThemeSource.client,
        accentColor: Color(0xff22CB8E),
        primaryColor: Color(0xff22CB8E),
        buttonBackgroundColor: Color(0xff22CB8E),
        darkPrimaryColor: Color(0xff167755),
        buttonCornerRadius: 8,
        textFieldCornerRadius: 0,
      ),
    );

    try {
      PersonaInquiry.init(configuration: _configuration);
      // PersonaInquiry.start();
      PersonaInquiry.onCanceled.listen(_onCanceled);
      PersonaInquiry.onError.listen(_onError);
      PersonaInquiry.onComplete.listen(_onComplete);
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _streamCanceled?.cancel();
    _streamError?.cancel();
    _streamComplete?.cancel();
    super.dispose();
  }

  void _onCanceled(InquiryCanceled event) {
    print("InquiryCanceled");
    print("- inquiryId: ${event.inquiryId}");
    print("- sessionToken: ${event.sessionToken}");
  }

  void _onError(InquiryError event) {
    print("InquiryError");
    print("- error: ${event.error}");
  }

  void _onComplete(InquiryComplete event) {
    print("InquiryComplete");
    print("- inquiryId: ${event.inquiryId}");
    print("- status: ${event.status}");

    print("- fields:");
    for (var key in event.fields.keys) {
      print("-- key: $key, value: ${event.fields[key]}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.grey[200],
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                PersonaInquiry.init(configuration: _configuration);

                PersonaInquiry.start();
              },
              child: Text("Start Inquiry"),
            ),
          ),
        ),
      ),
    );
  }
}
