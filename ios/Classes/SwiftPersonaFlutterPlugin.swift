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
                
                // Environment raw value parse
                if let env = arguments.value(forKey: "environment") as? String {
                    environment = Environment.init(rawValue: env)
                }
                
                // Build Fields
                if let fieldsDict = arguments.value(forKey: "fields") as? Dictionary<String, Any> {
                    
                    var name: Name?
                    var address: Address?
                    var birthdate: Date?
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
                    
                    fields = Fields.init(name: name,
                                         address: address,
                                         birthdate: birthdate,
                                         phoneNumber: phoneNumber,
                                         emailAddress: emailAddress,
                                         additionalFields: nil);
                }
                
                // Configuration
                if let inquiryId = inquiryIdInput {
                    config = InquiryConfiguration(inquiryId: inquiryId,
                                                accessToken: accessTokenInput,
                                                      theme: nil);
                }
                else if let templateId = templateIdInput {
                    if let accountId = accountIdInput {
                        config = InquiryConfiguration(templateId: templateId,
                                                      accountId: accountId,
                                                      environment: environment,
                                                      note: noteInput,
                                                      fields: fields,
                                                      theme: nil);
                    }
                    else if let referenceId = referenceIdInput {
                        config = InquiryConfiguration(templateId: templateId,
                                                      referenceId: referenceId,
                                                      environment: environment,
                                                      note: noteInput,
                                                      fields: fields,
                                                      theme: nil);
                    }
                    else {
                        config = InquiryConfiguration(templateId: templateId,
                                                      environment: environment,
                                                      note: noteInput,
                                                      fields: fields,
                                                      theme: nil);
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
