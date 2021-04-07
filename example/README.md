## Usage Example

``` dart
import 'package:persona_flutter/persona_flutter.dart';

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
      configuration: TemplateIdConfiguration(
        templateId: "TEMPLATE_ID",
        environment: InquiryEnvironment.sandbox,
        fields: InquiryFields(
          name: InquiryName(first: "John", middle: "Apple", last: "Seed"),
          additionalFields: {"test-1": "test-2", "test-3": 2, "test-4": true},
        ),
        iOSTheme: InquiryTheme(
          accentColor: Color(0xff22CB8E),
          primaryColor: Color(0xff22CB8E),
          buttonBackgroundColor: Color(0xff22CB8E),
          darkPrimaryColor: Color(0xff167755),
          buttonCornerRadius: 8,
          textFieldCornerRadius: 0,
        ),
      ),
      onSuccess: (String inquiryId, InquiryAttributes attributes, InquiryRelationships relationships) {
        print("onSuccess");
        print("- inquiryId: $inquiryId");
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
```