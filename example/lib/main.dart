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

  @override
  void initState() {
    super.initState();

    _configuration = TemplateIdConfiguration(
      templateId: "TEMPLATE_ID",
      environment: InquiryEnvironment.sandbox,
      iOSTheme: InquiryTheme(
        accentColor: Color(0xff22CB8E),
        primaryColor: Color(0xff22CB8E),
        buttonBackgroundColor: Color(0xff22CB8E),
        darkPrimaryColor: Color(0xff167755),
        buttonCornerRadius: 8,
        textFieldCornerRadius: 0,
      ),
    );

    PersonaInquiry.init(configuration: _configuration);
    PersonaInquiry.onComplete(onInquiryComplete);
    PersonaInquiry.onCanceled(onInquiryCanceled);
    PersonaInquiry.onError(onInquiryError);
  }

  void onInquiryComplete(
      String inquiryId, String status, Map<String, dynamic> fields) {
    print("onInquiryComplete");
    print("- inquiryId: $inquiryId");
    print("- status: $status");

    print("- fields:");
    for (var key in fields.keys) {
      print("-- key: $key, value: ${fields[key]}");
    }
  }

  void onInquiryCanceled(String? inquiryId, String? sessionToken) {
    print("onInquiryCanceled");
    print("- inquiryId: $inquiryId");
    print("- sessionToken: $sessionToken");
  }

  void onInquiryError(String? error) {
    print("onInquiryError");
    print("- error: $error");
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
