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
      templateId: "TEMPLATE_ID",
      environment: PersonaEnvironment.sandbox,
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
```