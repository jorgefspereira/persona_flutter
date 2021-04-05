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
  Inquiry _inquiry;

  @override
  void initState() {
    super.initState();

    _inquiry = Inquiry(
      templateId: "TEMPLATE_ID",
      environment: InquiryEnvironment.sandbox,
      fields: InquiryFields(
        name: InquiryName(first: "John", middle: "Apple", last: "Seed"),
        additionalFields: {"test-1": "test-2", "test-3": 2, "test-4": true},
      ),
      onSuccess: (String inquiryId, InquiryAttributes attributes, InquiryRelationships relationships) {
        print("onSuccess");
        print("- inquiryId: $inquiryId");
        print("- attributes:");
        print("--- name_first: ${attributes.name.first}");
        print("--- name_middle: ${attributes.name.middle}");
        print("--- name_last: ${attributes.name.last}");
        print("--- address_street1: ${attributes.address.street1}");
        print("--- address_street2: ${attributes.address.street2}");
        print("--- address_city: ${attributes.address.city}");
        print("--- address_postalCode: ${attributes.address.postalCode}");
        print("--- address_countryCode: ${attributes.address.countryCode}");
        print("--- address_subdivision: ${attributes.address.subdivision}");
        print("--- address_subdivisionAbbr: ${attributes.address.subdivisionAbbr}");
        print("--- birthdate: ${attributes.birthdate.toString()}");
        print("- relationships:");

        for (var item in relationships.verifications) {
          print("--- id: ${item.id}");
          print("--- status: ${item.status}");
          print("--- type: ${item.type}");
        }
      },
      iOSTheme: InquiryTheme(
        accentColor: Color(0xff22CB8E),
        primaryColor: Color(0xff22CB8E),
        buttonBackgroundColor: Color(0xff22CB8E),
        darkPrimaryColor: Color(0xff167755),
        buttonCornerRadius: 8,
        textFieldCornerRadius: 0,
      ),
      onCancelled: () {
        print("onCancelled");
      },
      onFailed: (String inquiryId, InquiryAttributes attributes, InquiryRelationships relationships) {
        print("onFailed");
        print("- inquiryId: $inquiryId");
      },
      onError: (String error) {
        print("onError");
        print("- $error");
      },
    );
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
                _inquiry.start();
              },
              child: Text("Start Inquiry"),
            ),
          ),
        ),
      ),
    );
  }
}
