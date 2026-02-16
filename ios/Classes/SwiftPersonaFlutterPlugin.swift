import Flutter
import UIKit
import Persona2

private let kTypeKey = "type";
private let kInquiryIdKey = "inquiryId";
private let kSessionTokenKey = "sessionToken";
private let kStatusKey = "status";
private let kFieldsKey = "fields";
private let kErrorKey = "error";
private let kCollectedDataKey = "collectedData";

@MainActor
public class SwiftPersonaFlutterPlugin: NSObject, FlutterPlugin, InquiryDelegate, InquiryCollectionDelegate, FlutterStreamHandler {
    var _eventSink: FlutterEventSink?
    var _inquiry: Inquiry?
    var _collectedData: InquiryData?
    var _disablePresentationAnimation: Bool = false
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "persona_flutter", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "persona_flutter/events", binaryMessenger: registrar.messenger())
        
        let instance = SwiftPersonaFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
    }
    
    // MARK: Method Channel
    
    /// Description
    /// - Parameters:
    ///   - call: <#call description#>
    ///   - result: <#result description#>
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            let arguments = call.arguments as! [String: Any]
            
            // Core identifiers
            let inquiryId = arguments["inquiryId"] as? String
            let templateId = arguments["templateId"] as? String
            let templateVersion = arguments["templateVersion"] as? String
            
            // Optional configuration
            let referenceId = arguments["referenceId"] as? String
            let accountId = arguments["accountId"] as? String
            let environmentId = arguments["environmentId"] as? String
            let environmentString = arguments["environment"] as? String
            let sessionToken = arguments["sessionToken"] as? String
            let themeSetId = arguments["themeSetId"] as? String
            let locale = arguments["locale"] as? String
            
            // Flags
            let returnCollectedData = arguments["returnCollectedData"] as? Bool ?? false
            _disablePresentationAnimation = arguments["disablePresentationAnimation"] as? Bool ?? false
            
            // Models
            var theme: InquiryTheme?
            var fields: [String: InquiryField]?
            var styleVariant: StyleVariant?
            
            /// Theme
            if let map = arguments["theme"] as? [String: Any] {
                if let source = map["source"] as? String {
                    let themeSource = themeSourceFromString(source)
                    theme = themeFromMap(map, source: themeSource)
                }
            }
            
            /// Fields
            if let value = arguments["fields"] as? [String: Any] {
                fields = fieldsFromMap(value)
            }
            
            /// Style Variant
            if let variantString = arguments["styleVariant"] as? String {
                styleVariant = StyleVariant(rawValue: variantString)
            }
            
            var builder: InquiryTemplateBuilder?
            var inquiryBuilder: InquiryBuilder?
            
            // Initialize the appropriate builder
            if let inquiryId = inquiryId {
                inquiryBuilder = Inquiry.from(inquiryId: inquiryId, delegate: self)
            } else if let templateVersion = templateVersion {
                builder = Inquiry.from(templateVersion: templateVersion, delegate: self)
            } else if let templateId = templateId {
                builder = Inquiry.from(templateId: templateId, delegate: self)
            }
            
            // Apply common configurations to builder (template/version based)
            if var builder = builder { // Use var to allow modification
                if let referenceId = referenceId { builder = builder.referenceId(referenceId) }
                if let accountId = accountId { builder = builder.accountId(accountId) }
                if let environmentId = environmentId { builder = builder.environmentId(environmentId) }
                if let fields = fields { builder = builder.fields(fields) }
                if let theme = theme { builder = builder.theme(theme) }
                if let themeSetId = themeSetId { builder = builder.themeSetId(themeSetId) }
                if let locale = locale { builder = builder.locale(locale) }
                if let styleVariant = styleVariant { builder = builder.styleVariant(styleVariant) }
                
                if let envString = environmentString,
                   let env = Environment(rawValue: envString) {
                    builder = builder.environment(env)
                }
                
                if returnCollectedData {
                    builder = builder.collectionDelegate(self)
                }
                
                // Add conditional adapters here if needed (NFC, SNA, WebRTC)
                
                _inquiry = builder.build()
            }
            
            // Apply common configurations to inquiryBuilder (inquiryId based)
            if var inquiryBuilder = inquiryBuilder { // Use var to allow modification
                if let sessionToken = sessionToken { inquiryBuilder = inquiryBuilder.sessionToken(sessionToken) }
                if let theme = theme { inquiryBuilder = inquiryBuilder.theme(theme) }
                if let locale = locale { inquiryBuilder.locale(locale) }
                if let styleVariant = styleVariant { inquiryBuilder = inquiryBuilder.styleVariant(styleVariant) }
                
                if returnCollectedData {
                    inquiryBuilder = inquiryBuilder.collectionDelegate(self)
                }
                
                // Add conditional adapters here if needed (NFC, SNA, WebRTC)
                
                _inquiry = inquiryBuilder.build()
            }
            
            // Reset collected data
            _collectedData = nil
            
            result(nil)
            
        case "start":
            if let inquiry = _inquiry, let controller = UIApplication.shared.delegate?.window??.rootViewController {
                inquiry.start(from: controller, animated: !_disablePresentationAnimation)
            } else {
                result(FlutterError(code: "not_initialized", message: "Inquiry not initialized", details: nil))
            }
            
        case "dispose":
            if let inquiry = _inquiry {
                // Dismiss if currently presented
                if let controller = UIApplication.shared.delegate?.window??.rootViewController {
                    controller.dismiss(animated: true, completion: nil)
                }
                _inquiry = nil
            }
            result(nil)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: Stream Handler
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        _eventSink = events;
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _eventSink = nil;
        return nil
    }
    
    // MARK: Inquiry Delegate
    
    public func inquiryComplete(inquiryId: String, status: String, fields: [String : InquiryField]) {
        guard let events = _eventSink else {
            return
        }
        
        let fieldsArray = mapFromFields(fields)
        
        var eventData: [String: Any] = [
            kTypeKey: "complete",
            kInquiryIdKey: inquiryId,
            kStatusKey: status,
            kFieldsKey: fieldsArray
        ]
        
        if let collectedData = _collectedData {
            eventData[kCollectedDataKey] = collectedData.toDictionary()
        }
        
        events(eventData)
    }
    
    public func inquiryCanceled(inquiryId: String?, sessionToken: String?) {
        guard let events = _eventSink else {
            return
        }
        
        events([kTypeKey: "canceled", kInquiryIdKey: inquiryId, kSessionTokenKey: sessionToken])
    }
    
    public func inquiryError(_ error: Error) {
        guard let events = _eventSink else {
            return
        }
        
        events([kTypeKey: "error", kErrorKey: error.localizedDescription])
    }
    
    public func inquiryEventOccurred(event: InquiryEvent) {
        let canProcessEvent = switch event {
        case .start, .pageChange:
            true
        @unknown default:
            false
        }
        
        guard canProcessEvent, let events = _eventSink else { return }
        
        events([
            kTypeKey: "event",
            "event": inquiryEventToDictionary(event: event)
        ])
    }
    
    // MARK: InquiryCollectionDelegate

    public func collectionComplete(data: InquiryData) {
        _collectedData = data
    }
    
    // MARK: Convert Functions
    
    func inquiryEventToDictionary(event: InquiryEvent) -> [String: String] {
        switch event {
            case .start(let value):
                return [
                    "type": "start",
                    "inquiryId": value.inquiryId,
                    "sessionToken": value.sessionToken,
                ]
            case .pageChange(let value):
                return [
                    "type": "page_change",
                    "name": value.name,
                    "path": value.path,
                ]
            @unknown default:
                return [
                    "type": "unknown",
                    "value": "unknown"
                ]
        }
    }
    
    func mapFromFields(_ fields: [String: InquiryField]) -> [String: Any] {
        var result : [String : Any] = [:]
        
        for (key, field) in fields {
            
            switch field {
            case .bool(let value):
                result[key] = value
            case .string(let value):
                result[key] = value
            case .int(let value):
                result[key] = value
            case .float(let value):
                result[key] = value
            case .date(let value):
                if let aux = value {
                    result[key] = dateFormatter().string(from: aux)
                }
            case .datetime(let value):
                if let aux = value {
                    result[key] = dateFormatter().string(from: aux)
                }
            default:
                break
            }
        }
        
        return result
    }
    
    func fieldsFromMap(_ map: [String: Any]) -> [String: InquiryField] {
        var result : [String : InquiryField] = [:]
        
        for (key, value) in map {
            
            switch value {
            case is Bool:
                result[key] = InquiryField.bool(value as? Bool)
            case is String:
                result[key] = InquiryField.string(value as? String)
            case is Int:
                result[key] = InquiryField.int(value as? Int)
            case is Float:
                result[key] = InquiryField.float(value as? Float)
            case is Date:
                if let dateString = value as? String {
                    result[key] = InquiryField.date(dateFormatter().date(from: dateString))
                }
            default:
                break
            }
        }
        
        return result
    }
    
    func themeSourceFromString(_ value: String) -> ThemeSource {
        switch value {
            case "client":
                return ThemeSource.client
            case "server":
                return ThemeSource.server
            default:
                return ThemeSource.server
        }
    }
    
    func themeFromMap(_ map: [String: Any], source: ThemeSource) -> InquiryTheme {
        var theme = InquiryTheme(themeSource: source);
        
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
        /// Footer
        ///////////////////////////////////////////////////////////////////////////
        if let footerBackgroundColor = map["footerBackgroundColor"] as? String {
            theme.footerBackgroundColor = UIColor.init(hex: footerBackgroundColor);
        }
        if let footerBorderColor = map["footerBorderColor"] as? String {
            theme.footerBorderColor = UIColor.init(hex: footerBorderColor);
        }
        if let footerBorderWidth = map["footerBorderWidth"] as? CGFloat {
            theme.footerBorderWidth = footerBorderWidth;
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
    
    // MARK: Helpers
    
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
            } else if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1.0)
                    return
                }
            }
        }
        
        self.init(red: 0, green: 0, blue: 0, alpha: 1)
    }
}

extension Environment {
    public static func from(rawValue: String?) -> Environment {
        // If nil, return default: production
        guard let rawValue = rawValue else {
            return .production
        }
        
        // If garbage passed in and can't be converted to Environment, then return default: production
        if let environment = Environment(rawValue: rawValue) {
            return environment
        } else {
            return .production
        }
    }
}

extension StyleVariant {
    public static func from(rawValue: String?) -> StyleVariant? {
        guard let rawValue = rawValue else {
            return nil
        }
        
        if let styleVariant = StyleVariant(rawValue: rawValue) {
            return styleVariant
        } else {
            return nil
        }
    }
}

extension InquiryData {
    func toDictionary() -> [String: Any?] {
        var inquiryData = [[String: Any?]]()
        for data in self.stepData {
            var currentStepData = [String: Any?]()

            switch data {
            case .ui(let uiData):
                currentStepData["type"] = "UiStepData"
                currentStepData["stepName"] = uiData.name
                currentStepData["componentParams"] = uiData.componentData.reduce(into: [[String: Any?]]()) { partial, element in
                    switch element {
                    case .int(let key, let value):
                        partial.append([key: value])
                    case .bool(let key, let value):
                        partial.append([key: value])
                    case .string(let key, let value):
                        partial.append([key: value])
                    case .strings(let key, let value):
                        partial.append([key: value])
                    case .double(let key, let value):
                        partial.append([key: value])
                    case .address(let key, let value):
                        partial.append([key: value])
                    default:
                        return
                    }
                }
            case .selfie(let selfieData):
                currentStepData["type"] = "SelfieStepData"
                currentStepData["stepName"] = selfieData.name
                if let centerPhoto = selfieData.centerPhoto {
                    currentStepData["centerCapture"] = [
                        "captureMethod": centerPhoto.captureMethod,
                        "absoluteFilePath": centerPhoto.filePath
                    ]
                }

                if let leftPhoto = selfieData.leftPhoto {
                    currentStepData["leftCapture"] = [
                        "captureMethod": leftPhoto.captureMethod,
                        "absoluteFilePath": leftPhoto.filePath
                    ]
                }

                if let rightPhoto = selfieData.rightPhoto {
                    currentStepData["rightCapture"] = [
                        "captureMethod": rightPhoto.captureMethod,
                        "absoluteFilePath": rightPhoto.filePath
                    ]
                }

            case .governmentId(let govIdData):
                currentStepData["type"] = "GovernmentIdStepData"
                currentStepData["stepName"] = govIdData.name

                var captures = [[String: Any]]()
                for file in govIdData.files {
                    captures.append([
                        "idClass": govIdData.idClass,
                        "captureMethod": file.captureMethod,
                        "side": file.page,
                        "frames": file.frames.map {
                            ["absoluteFilePath": $0.filePath]
                        }
                    ])
                }
                currentStepData["captures"] = captures
            case .document(let docData):
                currentStepData["type"] = "DocumentStepData"
                currentStepData["stepName"] = docData.name

                var documents = [[String: String]]()
                for file in docData.files {
                    documents.append(["absoluteFilePath": file.filePath])
                }
                currentStepData["documents"] = documents
            default:
                continue
            }
            inquiryData.append(currentStepData)
        }
        return ["stepData": inquiryData]
    }
}
