import Flutter
import UIKit
import Persona

public class SwiftPersonaFlutterPlugin: NSObject, FlutterPlugin, InquiryDelegate {
    let channel: FlutterMethodChannel;
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "persona_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftPersonaFlutterPlugin(withChannel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    init(withChannel channel: FlutterMethodChannel) {
        self.channel = channel;
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "start":
                let arguments = call.arguments as! [String: Any]
                
                // Environment
                var environment: Environment?
            
                if let env = arguments["environment"] as? String {
                    environment = Environment.init(rawValue: env)
                }
                
                // Theme
                var theme: InquiryTheme?
                
                if let value = arguments["theme"] as? [String: Any] {
                    theme = themeFromMap(value);
                }
                
                // Configuration
                var config: InquiryConfiguration?
            
                if let value = arguments["inquiryId"] as? String {
                    // Access Token
                    let accessToken = arguments["accessToken"] as? String
                    
                    config = InquiryConfiguration(inquiryId: value,
                                                  accessToken: accessToken,
                                                  theme: theme);
                }
                else if let templateId = arguments["templateId"] as? String {
                    // Note
                    let note = arguments["note"] as? String
                    
                    // Fields
                    var fields: Fields?
                    
                    if let value = arguments["fields"] as? [String: Any] {
                        fields = fieldsFromMap(value)
                    }
                    
                    if let accountId = arguments["accountId"] as? String {
                        config = InquiryConfiguration(templateId: templateId,
                                                      accountId: accountId,
                                                      environment: environment,
                                                      note: note,
                                                      fields: fields,
                                                      theme: theme);
                    }
                    else if let referenceId = arguments["referenceId"] as? String {
                        config = InquiryConfiguration(templateId: templateId,
                                                      referenceId: referenceId,
                                                      environment: environment,
                                                      note: note,
                                                      fields: fields,
                                                      theme: theme);
                    }
                    else {
                        config = InquiryConfiguration(templateId: templateId,
                                                      environment: environment,
                                                      note: note,
                                                      fields: fields,
                                                      theme: theme);
                    }
                }
                
                // Launch Inquiry
                if let configuration = config {
                    let controller = UIApplication.shared.keyWindow!.rootViewController!
                    Inquiry.init(config: configuration, delegate: self).start(from: controller)
                }
            
            default:
                result(FlutterMethodNotImplemented)
        }
    }
    
    //MARK:- InquiryDelegate
    
    public func inquirySuccess(inquiryId: String, attributes: Attributes, relationships:Relationships) {
        let attributesMap = attributesToMap(attributes: attributes);
        let relationshipsArray = relationshipsToArrayMap(relationships: relationships);
        
        self.channel.invokeMethod("onSuccess", arguments: ["inquiryId": inquiryId, "attributes" : attributesMap, "relationships": relationshipsArray])
    }
    
    public func inquiryCancelled() {
        self.channel.invokeMethod("onCancelled", arguments: nil);
    }
    
    public func inquiryFailed(inquiryId: String, attributes: Attributes, relationships:Relationships) {
        let attributesMap = attributesToMap(attributes: attributes);
        let relationshipsArray = relationshipsToArrayMap(relationships: relationships);
        
        self.channel.invokeMethod("onFailed", arguments: ["inquiryId": inquiryId, "attributes" : attributesMap, "relationships": relationshipsArray])
    }
    
    public func inquiryError(_ error: Error) {
        self.channel.invokeMethod("onError", arguments: ["error" : error.localizedDescription]);
    }
    
    //MARK:- Convert Functions
    
    func fieldsFromMap(_ map: [String: Any]) -> Fields {
        var name: Name?
        var address: Address?
        var birthdate: Date?
        var additionalFields: [String : InquiryField]?
        let phoneNumber = map["phoneNumber"] as? String;
        let emailAddress = map["emailAddress"] as? String;
        
        if let birthdateString = map["birthdate"] as? String {
            birthdate = dateFormatter().date(from: birthdateString);
        }
        
        if let values = map["name"] as? [String: Any] {
            name = Name.init(first: values["first"] as? String,
                             middle: values["middle"] as? String,
                             last: values["last"] as? String);
        }
        
        if let values = map["address"] as? [String: Any] {
            address = Address.init(street1: values["street1"] as? String,
                                   street2: values["street2"] as? String,
                                   city: values["city"] as? String,
                                   subdivision: values["subdivision"] as? String,
                                   subdivisionAbbr: values["subdivisionAbbr"] as? String,
                                   postalCode: values["postalCode"] as? String,
                                   countryCode: values["countryCode"] as? String);
        }
        
        if let values = map["additionalFields"] as? [String: Any] {
            var auxFields = [String : InquiryField]();
            
            for (key, value) in values {
                switch value {
                    case is Int:
                        auxFields[key] = InquiryField.int(value as! Int);
                    case is String:
                        auxFields[key] = InquiryField.string(value as! String);
                    case is Bool:
                        auxFields[key] = InquiryField.bool(value as! Bool);
                    default:
                        break;
                }
            }
            
            additionalFields = auxFields;
        }
        
        return Fields.init(name: name,
                           address: address,
                           birthdate: birthdate,
                           phoneNumber: phoneNumber,
                           emailAddress: emailAddress,
                           additionalFields: additionalFields);
    }
    
    func themeFromMap(_ map: [String : Any]) -> InquiryTheme {
        var theme = InquiryTheme();
        ///////////////////////////////////////////////////////////////////////////
        /// General Colors
        ///////////////////////////////////////////////////////////////////////////
        if let backgroundColor = map["backgroundColor"] as? String {
            theme.backgroundColor = UIColor.init(hex: backgroundColor);
        }
        if let primaryColor = map["primaryColor"] as? String {
            theme.primaryColor = UIColor.init(hex: primaryColor);
        }
        if let darkPrimaryColor = map["darkPrimaryColor"] as? String {
            theme.darkPrimaryColor = UIColor.init(hex: darkPrimaryColor);
        }
        if let accentColor = map["accentColor"] as? String {
            theme.accentColor = UIColor.init(hex: accentColor);
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Errors
        ///////////////////////////////////////////////////////////////////////////
        if let errorColor = map["errorColor"] as? String {
            theme.errorColor = UIColor.init(hex: errorColor);
        }
        if let errorFontFamily = map["errorTextFontFamily"] as? String {
            if let errorFont = UIFont(name: errorFontFamily, size: map["errorTextFontSize"] as? CGFloat ?? 18) {
                theme.errorTextFont = errorFont;
            }
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Overlay
        ///////////////////////////////////////////////////////////////////////////
        if let overlayBackgroundColor = map["overlayBackgroundColor"] as? String {
            theme.overlayBackgroundColor = UIColor.init(hex: overlayBackgroundColor);
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Navigation Bar
        ///////////////////////////////////////////////////////////////////////////
        if let navigationBarTextColor = map["navigationBarTextColor"] as? String {
            theme.navigationBarTextColor = UIColor.init(hex: navigationBarTextColor);
        }
        if let navigationBarTextFontFamily = map["navigationBarTextFontFamily"] as? String {
            if let navigationBarTextFont = UIFont(name: navigationBarTextFontFamily, size: map["navigationBarTextFontSize"] as? CGFloat ?? 18) {
                theme.navigationBarTextFont = navigationBarTextFont;
            }
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Title text
        ///////////////////////////////////////////////////////////////////////////
        if let titleTextColor = map["titleTextColor"] as? String {
            theme.titleTextColor = UIColor.init(hex: titleTextColor);
        }
        if let titleTextFontFamily = map["titleTextFontFamily"] as? String {
            if let titleFont = UIFont(name: titleTextFontFamily, size: map["titleTextFontSize"] as? CGFloat ?? 24) {
                theme.titleTextFont = titleFont;
            }
        }
        
        // Body text
        if let bodyTextColor = map["bodyTextColor"] as? String {
            theme.bodyTextColor = UIColor.init(hex: bodyTextColor);
        }
        if let bodyFontFamily = map["bodyTextFontFamily"] as? String {
            if let bodyFont = UIFont(name: bodyFontFamily, size: map["bodyTextFontSize"] as? CGFloat ?? 14) {
                theme.bodyTextFont = bodyFont;
            }
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Footnote
        ///////////////////////////////////////////////////////////////////////////
        if let footnoteTextColor = map["footnoteTextColor"] as? String {
            theme.footnoteTextColor = UIColor.init(hex: footnoteTextColor);
        }
        if let footnoteTextFontFamily = map["footnoteTextFontFamily"] as? String {
            if let footnoteTextFont = UIFont(name: footnoteTextFontFamily, size: map["footnoteTextFontSize"] as? CGFloat ?? 14) {
                theme.footnoteTextFont = footnoteTextFont;
            }
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Form label
        ///////////////////////////////////////////////////////////////////////////
        if let formLabelTextColor = map["formLabelTextColor"] as? String {
            theme.formLabelTextColor = UIColor.init(hex: formLabelTextColor);
        }
        if let formLabelTextFontFamily = map["formLabelTextFontFamily"] as? String {
            if let formLabelTextFont = UIFont(name: formLabelTextFontFamily, size: map["formLabelTextFontSize"] as? CGFloat ?? 14) {
                theme.formLabelTextFont = formLabelTextFont;
            }
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Text field
        ///////////////////////////////////////////////////////////////////////////
        if let textFieldBorderColor = map["textFieldBorderColor"] as? String {
            theme.textFieldBorderColor = UIColor.init(hex: textFieldBorderColor);
        }
        if let textFieldTextColor = map["textFieldTextColor"] as? String {
            theme.textFieldTextColor = UIColor.init(hex: textFieldTextColor);
        }
        if let textFieldBackgroundColor = map["textFieldBackgroundColor"] as? String {
            theme.textFieldBackgroundColor = UIColor.init(hex: textFieldBackgroundColor);
        }
        if let textFieldCornerRadius = map["textFieldCornerRadius"] as? CGFloat {
            theme.textFieldCornerRadius = textFieldCornerRadius;
        }
        if let textFieldFontFamily = map["textFieldFontFamily"] as? String {
            if let textFieldFont = UIFont(name: textFieldFontFamily, size: map["textFieldFontSize"] as? CGFloat ?? 18) {
                theme.textFieldFont = textFieldFont;
            }
        }
        if let textFieldPlaceholderFontFamily = map["textFieldPlaceholderFontFamily"] as? String {
            if let textFieldPlaceholderFont = UIFont(name: textFieldPlaceholderFontFamily, size: map["textFieldPlaceholderFontSize"] as? CGFloat ?? 18) {
                theme.textFieldPlaceholderFont = textFieldPlaceholderFont;
            }
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Picker
        ///////////////////////////////////////////////////////////////////////////
        if let pickerTextColor = map["pickerTextColor"] as? String {
            theme.pickerTextColor = UIColor.init(hex: pickerTextColor);
        }
        if let pickerFontFamily = map["pickerTextFontFamily"] as? String {
            if let pickerFont = UIFont(name: pickerFontFamily, size: map["pickerTextFontSize"] as? CGFloat ?? 18) {
                theme.pickerTextFont = pickerFont;
            }
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Primary Button Properties
        ///////////////////////////////////////////////////////////////////////////
        if let buttonBackgroundColor = map["buttonBackgroundColor"] as? String {
            theme.buttonBackgroundColor = UIColor.init(hex: buttonBackgroundColor);
        }
        if let buttonTouchedBackgroundColor = map["buttonTouchedBackgroundColor"] as? String {
            theme.buttonTouchedBackgroundColor = UIColor.init(hex: buttonTouchedBackgroundColor);
        }
        if let buttonDisabledBackgroundColor = map["buttonDisabledBackgroundColor"] as? String {
            theme.buttonDisabledBackgroundColor = UIColor.init(hex: buttonDisabledBackgroundColor);
        }
        if let buttonTextColor = map["buttonTextColor"] as? String {
            theme.buttonTextColor = UIColor.init(hex: buttonTextColor);
        }
        if let buttonFontFamily = map["buttonFontFamily"] as? String {
            if let buttonFont = UIFont(name: buttonFontFamily, size: map["buttonFontSize"] as? CGFloat ?? 18) {
                theme.buttonFont = buttonFont;
            }
        }
        if let buttonDisabledTextColor = map["buttonDisabledTextColor"] as? String {
            theme.buttonDisabledTextColor = UIColor.init(hex: buttonDisabledTextColor);
        }
        if let buttonShadowColor = map["buttonShadowColor"] as? String {
            let buttonShadowAlpha = map["buttonShadowAlpha"] as? CGFloat;
            theme.buttonShadowColor = UIColor.init(hex: buttonShadowColor).withAlphaComponent(buttonShadowAlpha ?? 0.5);
        }

        let buttonShadowWidth = map["buttonShadowWidth"] as? CGFloat;
        let buttonShadowHeight = map["buttonShadowHeight"] as? CGFloat;

        theme.buttonShadowOffset = CGSize(width:buttonShadowWidth ?? 0, height:buttonShadowHeight ?? 0);
        
        if let buttonShadowRadius = map["buttonShadowRadius"] as? CGFloat {
            theme.buttonShadowRadius = buttonShadowRadius;
        }
        if let buttonCornerRadius = map["buttonCornerRadius"] as? CGFloat {
            theme.buttonCornerRadius = buttonCornerRadius;
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Secondary Button Properties
        ///////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////
        /// Checkbox
        ///////////////////////////////////////////////////////////////////////////
        if let checkboxBackgroundColor = map["checkboxBackgroundColor"] as? String {
            theme.checkboxBackgroundColor = UIColor.init(hex: checkboxBackgroundColor);
        }
        if let checkboxForegroundColor = map["checkboxForegroundColor"] as? String {
            theme.checkboxForegroundColor = UIColor.init(hex: checkboxForegroundColor);
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Table view cell
        ///////////////////////////////////////////////////////////////////////////
        if let selectedCellBackgroundColor = map["selectedCellBackgroundColor"] as? String {
            theme.selectedCellBackgroundColor = UIColor.init(hex: selectedCellBackgroundColor);
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Close button
        ///////////////////////////////////////////////////////////////////////////
        if let closeButtonTintColor = map["closeButtonTintColor"] as? String {
            theme.closeButtonTintColor = UIColor.init(hex: closeButtonTintColor);
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Cancel Button
        ///////////////////////////////////////////////////////////////////////////
        if let cancelButtonBackgroundColor = map["cancelButtonBackgroundColor"] as? String {
            theme.cancelButtonBackgroundColor = UIColor.init(hex: cancelButtonBackgroundColor);
        }
        if let cancelButtonTextColor = map["cancelButtonTextColor"] as? String {
            theme.cancelButtonTextColor = UIColor.init(hex: cancelButtonTextColor);
        }
        if let cancelButtonAlternateBackgroundColor = map["cancelButtonAlternateBackgroundColor"] as? String {
            theme.cancelButtonAlternateBackgroundColor = UIColor.init(hex: cancelButtonAlternateBackgroundColor);
        }
        if let cancelButtonAlternateTextColor = map["cancelButtonAlternateTextColor"] as? String {
            theme.cancelButtonAlternateTextColor = UIColor.init(hex: cancelButtonAlternateTextColor);
        }
        if let cancelButtonTextColor = map["cancelButtonTextColor"] as? String {
            theme.cancelButtonTextColor = UIColor.init(hex: cancelButtonTextColor);
        }
        if let cancelButtonShadowColor = map["cancelButtonShadowColor"] as? String {
            theme.cancelButtonShadowColor = UIColor.init(hex: cancelButtonShadowColor);
        }
        if let cancelButtonShadowRadius = map["cancelButtonShadowRadius"] as? CGFloat {
            theme.cancelButtonShadowRadius = cancelButtonShadowRadius;
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Separator
        ///////////////////////////////////////////////////////////////////////////
        if let separatorColor = map["separatorColor"] as? String {
            theme.separatorColor = UIColor.init(hex: separatorColor);
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Miscellaneous
        ///////////////////////////////////////////////////////////////////////////
        if let showGovernmentIdIcons = map["showGovernmentIdIcons"] as? Bool {
            theme.showGovernmentIdIcons = showGovernmentIdIcons;
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Camera
        ///////////////////////////////////////////////////////////////////////////
        if let cameraInstructionsTextColor = map["cameraInstructionsTextColor"] as? String {
            theme.cameraInstructionsTextColor = UIColor.init(hex: cameraInstructionsTextColor);
        }
        if let cameraButtonBackgroundColor = map["cameraButtonBackgroundColor"] as? String {
            theme.cameraButtonBackgroundColor = UIColor.init(hex: cameraButtonBackgroundColor);
        }
        if let cameraButtonTextColor = map["cameraButtonTextColor"] as? String {
            theme.cameraButtonTextColor = UIColor.init(hex: cameraButtonTextColor);
        }
        if let cameraButtonAlternateBackgroundColor = map["cameraButtonAlternateBackgroundColor"] as? String {
            theme.cameraButtonAlternateBackgroundColor = UIColor.init(hex: cameraButtonAlternateBackgroundColor);
        }
        if let cameraButtonAlternateTextColor = map["cameraButtonAlternateTextColor"] as? String {
            theme.cameraButtonAlternateTextColor = UIColor.init(hex: cameraButtonAlternateTextColor);
        }
        if let cameraHintTextColor = map["cameraHintTextColor"] as? String {
            theme.cameraHintTextColor = UIColor.init(hex: cameraHintTextColor);
        }
        if let cameraGuideHintTextColor = map["cameraGuideHintTextColor"] as? String {
            theme.cameraGuideHintTextColor = UIColor.init(hex: cameraGuideHintTextColor);
        }
        if let cameraGuideCornersColor = map["cameraGuideCornersColor"] as? String {
            theme.cameraGuideCornersColor = UIColor.init(hex: cameraGuideCornersColor);
        }
        
        return theme;
    }
    
    func attributesToMap(attributes: Attributes) -> [String: Any] {
        let name = attributes.name;
        let address = attributes.address;
        
        let resultName = ["first": name?.first, "middle": name?.middle, "last": name?.last];
        let resultAddress = ["street1" : address?.street1, "street2" : address?.street2, "city" : address?.city,
                             "subdivision" : address?.subdivision, "subdivisionAbbr": address?.subdivisionAbbr, "postalCode" : address?.postalCode,
                             "countryCode" : address?.countryCode]
        
        var result: [String: Any] = ["name": resultName, "address" : resultAddress];
        
        if let birthdate = attributes.birthdate {
            result["birthdate"] = dateFormatter().string(from: birthdate);
        }
        
        return result
    }
    
    func relationshipsToArrayMap(relationships: Relationships) -> [[String: Any?]] {
        var result = [[String:Any?]]();
        
        for verification in relationships.verifications {
            var type: String?
            
            switch(verification) {
            case is GovernmentIdVerification:
                type = "governmentId";
            case is SelfieVerification:
                type = "selfie";
            case is PhoneNumberVerification:
                type = "phoneNumber";
            case is DatabaseVerification:
                type = "database";
            case is DocumentVerification:
                type = "document";
            default:
                break;
                
            }
            
            result.append(["id": verification.id, "status": "\(verification.status)", "type": type ])
        }
        
        return result;
    }
    
    //MARK:- Helpers
    
    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return formatter;
    }
}

extension UIColor {
    public convenience init(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    a = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        self.init()
    }
}
