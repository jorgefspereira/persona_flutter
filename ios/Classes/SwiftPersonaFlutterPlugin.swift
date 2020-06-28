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
                let templateId = arguments.value(forKey: "templateId") as? String
                let inquiryId = arguments.value(forKey: "inquiryId") as? String
                let referenceId = arguments.value(forKey: "referenceId") as? String
                let accountId = arguments.value(forKey: "accountId") as? String
                let environment = arguments.value(forKey: "environment") as? String
                let note = arguments.value(forKey: "note") as? String
                
                var config: InquiryConfiguration?
                var env: Environment?
                                
                if environment != nil {
                    env = Environment.init(rawValue: environment!)
                    
                }
                
                if inquiryId != nil {
                    config = InquiryConfiguration(inquiryId: inquiryId!);
                }
                else if templateId != nil {
                    if accountId != nil {
                        config = InquiryConfiguration(templateId: templateId!,
                                                      accountId: accountId!,
                                                      environment: env,
                                                      note: note,
                                                      theme: nil);
                    }
                    else if referenceId != nil {
                        config = InquiryConfiguration(templateId: templateId!,
                                                      referenceId: referenceId!,
                                                      environment: env,
                                                      note: note,
                                                      theme: nil);
                    }
                    else {
                        config = InquiryConfiguration(templateId: templateId!);
                    }
                }
                
                if config != nil {
                    Inquiry.init(config: config!, delegate: self).start(from: controller)
                }
            default:
                result(FlutterMethodNotImplemented)
        }
    }

    public func inquirySuccess(inquiryId: String, attributes: Attributes, relationships:Relationships) {
        let attributesMap = attributesToMap(attributes: attributes);
        let relationshipsArray = relationshipsToArray(relationships: relationships);
        
        self.channel.invokeMethod("onSuccess", arguments: ["attributes" : attributesMap, "relationships": relationshipsArray])
    }

    public func inquiryCancelled() {
        self.channel.invokeMethod("onCancelled", arguments: nil);
    }

    public func inquiryFailed(inquiryId: String, attributes: Attributes, relationships:Relationships) {
        let attributesMap = attributesToMap(attributes: attributes);
        let relationshipsArray = relationshipsToArray(relationships: relationships);
        
        self.channel.invokeMethod("onFailed", arguments: ["attributes" : attributesMap, "relationships": relationshipsArray])
    }

    public func inquiryError(_ error: Error) {
        self.channel.invokeMethod("onError", arguments: ["error" : error.localizedDescription]);
    }
    
    func attributesToMap(attributes: Attributes) -> [String: String?] {
        let name = attributes.name;
        let address = attributes.address;
        
        var result = ["firstName": name?.first, "middleName": name?.middle, "lastName": name?.last,
                      "street1" : address?.street1, "street2" : address?.street2, "city" : address?.city,
                      "subdivision" : address?.subdivision, "postalCode" : address?.postalCode,
                      "countryCode" : address?.countryCode]
        
        if let birthdate = attributes.birthdate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            result["birthdate"] = formatter.string(from: birthdate);
        }
        
        return result
    }
    
    func relationshipsToArray(relationships: Relationships) -> [[String: String?]] {
        var result = [[String:String?]]();
        
        for verification in relationships.verifications {
            result.append(["id": verification.id, "status": "\(verification.status)" ])
        }
        
        return result;
    }
    
}
