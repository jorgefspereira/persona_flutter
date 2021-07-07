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
            let controller = UIApplication.shared.keyWindow!.rootViewController!
            let arguments = call.arguments as! NSDictionary
            
            // input values
            let templateIdInput = arguments.value(forKey: "templateId") as? String
            let inquiryIdInput = arguments.value(forKey: "inquiryId") as? String
            let accessTokenInput = arguments.value(forKey: "accessToken") as? String
            let referenceIdInput = arguments.value(forKey: "referenceId") as? String
            let accountIdInput = arguments.value(forKey: "accountId") as? String
            let noteInput = arguments.value(forKey: "note") as? String
            
            var config: InquiryConfiguration?
            var environment: Environment?
            var fields: Fields?
            var theme: InquiryTheme?
            
            // Environment raw value parse
            if let env = arguments.value(forKey: "environment") as? String {
                environment = Environment.init(rawValue: env)
            }
            
            // Build Fields
            if let fieldsDict = arguments.value(forKey: "fields") as? Dictionary<String, Any> {
                
                var name: Name?
                var address: Address?
                var birthdate: Date?
                var additionalFields: [String : InquiryField]?
                let phoneNumber = fieldsDict["phoneNumber"] as? String;
                let emailAddress = fieldsDict["emailAddress"] as? String;
                
                if let birthdateString = fieldsDict["birthdate"] as? String {
                    birthdate = dateFormatter().date(from: birthdateString);
                }
                
                if let nameDict = fieldsDict["name"] as? Dictionary<String, String> {
                    name = Name.init(first: nameDict["first"],
                                     middle: nameDict["middle"],
                                     last: nameDict["last"]);
                }
                
                if let addressDict = fieldsDict["address"] as? Dictionary<String, String> {
                    address = Address.init(street1: addressDict["street1"],
                                           street2: addressDict["street2"],
                                           city: addressDict["city"],
                                           subdivision: addressDict["subdivision"],
                                           subdivisionAbbr: addressDict["subdivisionAbbr"],
                                           postalCode: addressDict["postalCode"],
                                           countryCode: addressDict["countryCode"]);
                }
                
                if let additionalFieldsDict = fieldsDict["additionalFields"] as? Dictionary<String, Any> {
                    var auxFields = [String : InquiryField]();
                    
                    for (key, value) in additionalFieldsDict{
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
                
                fields = Fields.init(name: name,
                                     address: address,
                                     birthdate: birthdate,
                                     phoneNumber: phoneNumber,
                                     emailAddress: emailAddress,
                                     additionalFields: additionalFields);
            }
            
            // Build Theme
            if let themeDict = arguments.value(forKey: "theme") as? Dictionary<String, Any> {
                
                theme = InquiryTheme();
                
                // Booleans
                if let showGovernmentIdIcons = themeDict["showGovernmentIdIcons"] as? Bool {
                    theme?.showGovernmentIdIcons = showGovernmentIdIcons;
                }
                
                // Colors
                if let backgroundColor = themeDict["backgroundColor"] as? String {
                    theme?.backgroundColor = UIColor.init(hex: backgroundColor);
                }
                if let textFieldBorderColor = themeDict["textFieldBorderColor"] as? String {
                    theme?.textFieldBorderColor = UIColor.init(hex: textFieldBorderColor);
                }
                if let buttonBackgroundColor = themeDict["buttonBackgroundColor"] as? String {
                    theme?.buttonBackgroundColor = UIColor.init(hex: buttonBackgroundColor);
                }
                if let buttonTouchedBackgroundColor = themeDict["buttonTouchedBackgroundColor"] as? String {
                    theme?.buttonTouchedBackgroundColor = UIColor.init(hex: buttonTouchedBackgroundColor);
                }
                if let buttonDisabledBackgroundColor = themeDict["buttonDisabledBackgroundColor"] as? String {
                    theme?.buttonDisabledBackgroundColor = UIColor.init(hex: buttonDisabledBackgroundColor);
                }
                if let closeButtonTintColor = themeDict["closeButtonTintColor"] as? String {
                    theme?.closeButtonTintColor = UIColor.init(hex: closeButtonTintColor);
                }
                if let cancelButtonBackgroundColor = themeDict["cancelButtonBackgroundColor"] as? String {
                    theme?.cancelButtonBackgroundColor = UIColor.init(hex: cancelButtonBackgroundColor);
                }
                if let selectedCellBackgroundColor = themeDict["selectedCellBackgroundColor"] as? String {
                    theme?.selectedCellBackgroundColor = UIColor.init(hex: selectedCellBackgroundColor);
                }
                if let accentColor = themeDict["accentColor"] as? String {
                    theme?.accentColor = UIColor.init(hex: accentColor);
                }
                if let darkPrimaryColor = themeDict["darkPrimaryColor"] as? String {
                    theme?.darkPrimaryColor = UIColor.init(hex: darkPrimaryColor);
                }
                if let primaryColor = themeDict["primaryColor"] as? String {
                    theme?.primaryColor = UIColor.init(hex: primaryColor);
                }
                if let titleTextColor = themeDict["titleTextColor"] as? String {
                    theme?.titleTextColor = UIColor.init(hex: titleTextColor);
                }
                if let bodyTextColor = themeDict["bodyTextColor"] as? String {
                    theme?.bodyTextColor = UIColor.init(hex: bodyTextColor);
                }
                if let formLabelTextColor = themeDict["formLabelTextColor"] as? String {
                    theme?.formLabelTextColor = UIColor.init(hex: formLabelTextColor);
                }
                if let buttonTextColor = themeDict["buttonTextColor"] as? String {
                    theme?.buttonTextColor = UIColor.init(hex: buttonTextColor);
                }
                if let pickerTextColor = themeDict["pickerTextColor"] as? String {
                    theme?.pickerTextColor = UIColor.init(hex: pickerTextColor);
                }
                if let textFieldTextColor = themeDict["textFieldTextColor"] as? String {
                    theme?.textFieldTextColor = UIColor.init(hex: textFieldTextColor);
                }
                if let footnoteTextColor = themeDict["footnoteTextColor"] as? String {
                    theme?.footnoteTextColor = UIColor.init(hex: footnoteTextColor);
                }
                if let errorColor = themeDict["errorColor"] as? String {
                    theme?.errorColor = UIColor.init(hex: errorColor);
                }
                if let overlayBackgroundColor = themeDict["overlayBackgroundColor"] as? String {
                    theme?.overlayBackgroundColor = UIColor.init(hex: overlayBackgroundColor);
                }
                if let textFieldBackgroundColor = themeDict["textFieldBackgroundColor"] as? String {
                    theme?.textFieldBackgroundColor = UIColor.init(hex: textFieldBackgroundColor);
                }
                if let buttonDisabledTextColor = themeDict["buttonDisabledTextColor"] as? String {
                    theme?.buttonDisabledTextColor = UIColor.init(hex: buttonDisabledTextColor);
                }
                if let checkboxBackgroundColor = themeDict["checkboxBackgroundColor"] as? String {
                    theme?.checkboxBackgroundColor = UIColor.init(hex: checkboxBackgroundColor);
                }
                if let checkboxForegroundColor = themeDict["checkboxForegroundColor"] as? String {
                    theme?.checkboxForegroundColor = UIColor.init(hex: checkboxForegroundColor);
                }
                if let cancelButtonTextColor = themeDict["cancelButtonTextColor"] as? String {
                    theme?.cancelButtonTextColor = UIColor.init(hex: cancelButtonTextColor);
                }
                if let cancelButtonAlternateBackgroundColor = themeDict["cancelButtonAlternateBackgroundColor"] as? String {
                    theme?.cancelButtonAlternateBackgroundColor = UIColor.init(hex: cancelButtonAlternateBackgroundColor);
                }
                if let cancelButtonAlternateTextColor = themeDict["cancelButtonAlternateTextColor"] as? String {
                    theme?.cancelButtonAlternateTextColor = UIColor.init(hex: cancelButtonAlternateTextColor);
                }
                if let cancelButtonTextColor = themeDict["cancelButtonTextColor"] as? String {
                    theme?.cancelButtonTextColor = UIColor.init(hex: cancelButtonTextColor);
                }
                if let cancelButtonShadowColor = themeDict["cancelButtonShadowColor"] as? String {
                    theme?.cancelButtonShadowColor = UIColor.init(hex: cancelButtonShadowColor);
                }
                if let separatorColor = themeDict["separatorColor"] as? String {
                    theme?.separatorColor = UIColor.init(hex: separatorColor);
                }
                if let navigationBarTextColor = themeDict["navigationBarTextColor"] as? String {
                    theme?.navigationBarTextColor = UIColor.init(hex: navigationBarTextColor);
                }
                if let cameraInstructionsTextColor = themeDict["cameraInstructionsTextColor"] as? String {
                    theme?.cameraInstructionsTextColor = UIColor.init(hex: cameraInstructionsTextColor);
                }
                if let cameraButtonBackgroundColor = themeDict["cameraButtonBackgroundColor"] as? String {
                    theme?.cameraButtonBackgroundColor = UIColor.init(hex: cameraButtonBackgroundColor);
                }
                if let cameraButtonTextColor = themeDict["cameraButtonTextColor"] as? String {
                    theme?.cameraButtonTextColor = UIColor.init(hex: cameraButtonTextColor);
                }
                if let cameraButtonAlternateBackgroundColor = themeDict["cameraButtonAlternateBackgroundColor"] as? String {
                    theme?.cameraButtonAlternateBackgroundColor = UIColor.init(hex: cameraButtonAlternateBackgroundColor);
                }
                if let cameraButtonAlternateTextColor = themeDict["cameraButtonAlternateTextColor"] as? String {
                    theme?.cameraButtonAlternateTextColor = UIColor.init(hex: cameraButtonAlternateTextColor);
                }
                if let cameraHintTextColor = themeDict["cameraHintTextColor"] as? String {
                    theme?.cameraHintTextColor = UIColor.init(hex: cameraHintTextColor);
                }
                if let cameraGuideHintTextColor = themeDict["cameraGuideHintTextColor"] as? String {
                    theme?.cameraGuideHintTextColor = UIColor.init(hex: cameraGuideHintTextColor);
                }
                if let cameraGuideCornersColor = themeDict["cameraGuideCornersColor"] as? String {
                    theme?.cameraGuideCornersColor = UIColor.init(hex: cameraGuideCornersColor);
                }
                
                // Shadows
                if let buttonShadowColor = themeDict["buttonShadowColor"] as? String {
                    let buttonShadowAlpha = themeDict["buttonShadowAlpha"] as? CGFloat;
                    theme?.buttonShadowColor = UIColor.init(hex: buttonShadowColor).withAlphaComponent(buttonShadowAlpha ?? 0.5); 
                }

                let buttonShadowWidth = themeDict["buttonShadowWidth"] as? CGFloat;
                let buttonShadowHeight = themeDict["buttonShadowHeight"] as? CGFloat;

                theme?.buttonShadowOffset = CGSize(width:buttonShadowWidth ?? 0, height:buttonShadowHeight ?? 0);
                
                if let buttonShadowRadius = themeDict["buttonShadowRadius"] as? CGFloat {
                    theme?.buttonShadowRadius = buttonShadowRadius;
                }
                if let cancelButtonShadowRadius = themeDict["cancelButtonShadowRadius"] as? CGFloat {
                    theme?.cancelButtonShadowRadius = cancelButtonShadowRadius;
                }
            
                // Corner Radius
                if let buttonCornerRadius = themeDict["buttonCornerRadius"] as? CGFloat {
                    theme?.buttonCornerRadius = buttonCornerRadius;
                }
                
                if let textFieldCornerRadius = themeDict["textFieldCornerRadius"] as? CGFloat {
                    theme?.textFieldCornerRadius = textFieldCornerRadius;
                }

                // Fonts
                if let titleFontFamily = themeDict["titleFontFamily"] as? String {
                    if let titleFont = UIFont(name: titleFontFamily, size: themeDict["titleFontSize"] as? CGFloat ?? 24) {
                        theme?.titleTextFont = titleFont;
                    } 
                }

                if let bodyFontFamily = themeDict["bodyFontFamily"] as? String {
                    if let bodyFont = UIFont(name: bodyFontFamily, size: themeDict["bodyFontSize"] as? CGFloat ?? 14) {
                        theme?.bodyTextFont = bodyFont;
                    } 
                }

                if let errorFontFamily = themeDict["errorFontFamily"] as? String {
                    if let errorFont = UIFont(name: errorFontFamily, size: themeDict["errorFontSize"] as? CGFloat ?? 18) {
                        theme?.errorTextFont = errorFont;
                    } 
                }
                
                if let navigationBarTextFontFamily = themeDict["navigationBarTextFontFamily"] as? String {
                    if let navigationBarTextFont = UIFont(name: navigationBarTextFontFamily, size: themeDict["navigationBarTextFontSize"] as? CGFloat ?? 18) {
                        theme?.navigationBarTextFont = navigationBarTextFont;
                    }
                }
                
                if let textFieldFontFamily = themeDict["textFieldFontFamily"] as? String {
                    if let textFieldFont = UIFont(name: textFieldFontFamily, size: themeDict["textFieldFontSize"] as? CGFloat ?? 18) {
                        theme?.textFieldFont = textFieldFont;
                    }
                }
                
                if let textFieldPlaceholderFontFamily = themeDict["textFieldPlaceholderFontFamily"] as? String {
                    if let textFieldPlaceholderFont = UIFont(name: textFieldPlaceholderFontFamily, size: themeDict["textFieldPlaceholderFontSize"] as? CGFloat ?? 18) {
                        theme?.textFieldPlaceholderFont = textFieldPlaceholderFont;
                    }
                }
                
                if let textFieldPlaceholderFontFamily = themeDict["textFieldPlaceholderFontFamily"] as? String {
                    if let textFieldPlaceholderFont = UIFont(name: textFieldPlaceholderFontFamily, size: themeDict["textFieldPlaceholderFontSize"] as? CGFloat ?? 18) {
                        theme?.textFieldPlaceholderFont = textFieldPlaceholderFont;
                    }
                }
                
                if let pickerFontFamily = themeDict["pickerFontFamily"] as? String {
                    if let pickerFont = UIFont(name: pickerFontFamily, size: themeDict["pickerFontSize"] as? CGFloat ?? 18) {
                        theme?.pickerTextFont = pickerFont;
                    }
                }
                
            }
            
            // Configuration
            if let inquiryId = inquiryIdInput {
                config = InquiryConfiguration(inquiryId: inquiryId,
                                              accessToken: accessTokenInput,
                                              theme: theme);
            }
            else if let templateId = templateIdInput {
                if let accountId = accountIdInput {
                    config = InquiryConfiguration(templateId: templateId,
                                                  accountId: accountId,
                                                  environment: environment,
                                                  note: noteInput,
                                                  fields: fields,
                                                  theme: theme);
                }
                else if let referenceId = referenceIdInput {
                    config = InquiryConfiguration(templateId: templateId,
                                                  referenceId: referenceId,
                                                  environment: environment,
                                                  note: noteInput,
                                                  fields: fields,
                                                  theme: theme);
                }
                else {
                    config = InquiryConfiguration(templateId: templateId,
                                                  environment: environment,
                                                  note: noteInput,
                                                  fields: fields,
                                                  theme: theme);
                }
            }
            
            // Launch Inquiry
            if let configuration = config {
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
        
        self.channel.invokeMethod("onSuccess", arguments: ["inquiryId": inquiryId,
                                                           "attributes" : attributesMap,
                                                           "relationships": relationshipsArray])
    }
    
    public func inquiryCancelled() {
        self.channel.invokeMethod("onCancelled", arguments: nil);
    }
    
    public func inquiryFailed(inquiryId: String, attributes: Attributes, relationships:Relationships) {
        let attributesMap = attributesToMap(attributes: attributes);
        let relationshipsArray = relationshipsToArrayMap(relationships: relationships);
        
        self.channel.invokeMethod("onFailed", arguments: ["inquiryId": inquiryId,
                                                          "attributes" : attributesMap,
                                                          "relationships": relationshipsArray])
    }
    
    public func inquiryError(_ error: Error) {
        self.channel.invokeMethod("onError", arguments: ["error" : error.localizedDescription]);
    }
    
    //MARK:- Convert Functions
    
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
