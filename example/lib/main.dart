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
      fields: InquiryFields(name: InquiryName(first: "John", middle: "Apple" ,last: "Seed")),
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
        print("- relationships:");

        for(var item in relationships.verifications) {
          print("--- id: ${item.id}");
          print("--- status: ${item.status}");
          print("--- type: ${item.type}");
        }
      },
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
          color: Colors.lightBlue,
          child: Center(
            child: RaisedButton(
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
