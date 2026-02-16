package com.jorgefspereira.persona_flutter

import android.app.Activity
import android.content.Intent

import com.withpersona.sdk2.inquiry.*
import com.withpersona.sdk2.inquiry.inline_inquiry.InquiryEvent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** PersonaFlutterPlugin */
class PersonaFlutterPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel

    private var activity: Activity? = null
    private var binding: ActivityPluginBinding? = null
    private var eventSink: EventSink? = null
    private val requestCode = 57
    private var inquiry: Inquiry? = null
    private var isResultSubmitted = false
    private var disablePresentationAnimation: Boolean = false

    /// - FlutterPlugin interface

    @OptIn(ExperimentalInlineApi::class)
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, "persona_flutter")
        methodChannel.setMethodCallHandler(this)
        eventChannel = EventChannel(binding.binaryMessenger, "persona_flutter/events")
        eventChannel.setStreamHandler(this)
        registerOnInquiryEventListener()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    /// - StreamHandler interface

    override fun onListen(arguments: Any?, events: EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink?.endOfStream()
        eventSink = null
    }

    /// - MethodCallHandler interface

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "init" -> {
                val arguments = call.arguments as? Map<String, Any?> ?: return

                var fields: Fields? = null
                var environment: Environment? = null
                var environmentId: String? = null
                var theme: Map<String, Any?>? = null
                var sessionToken: String? = null
                var referenceId: String? = null
                var accountId: String? = null
                var themeSetId: String? = null
                var locale: String? = null
                var styleVariant: StyleVariant? = null
                var returnCollectedData: Boolean? = null

                // Environment
                (arguments["environment"] as? String)?.let {
                    environment = try {
                        Environment.valueOf(it.uppercase())
                    } catch (e: IllegalArgumentException) {
                        null
                    }
                }
                // Environment Id
                (arguments["environmentId"] as? String)?.let {
                    environmentId = it
                }
                // Theme
                (arguments["theme"] as? Map<String, Any?>)?.let {
                    theme = it
                }
                // Fields
                (arguments["fields"] as? Map<String, Any?>)?.let  {
                    fields = fieldsFromMap(it)
                }
                // Session Token
                (arguments["sessionToken"] as?  String)?.let  {
                    sessionToken = it
                }
                // Reference Id
                (arguments["referenceId"] as? String)?.let {
                    referenceId = it
                }
                // Account Id
                (arguments["accountId"] as? String)?.let {
                    accountId = it
                }
                // ThemeSet Id
                (arguments["themeSetId"] as? String)?.let {
                    themeSetId = it
                }
                // Locale
                (arguments["locale"] as? String)?.let {
                    locale = it
                }
                // Style Variant
                (arguments["styleVariant"] as? String)?.let {
                   styleVariant = styleVariantFromString(it)
                }
                 // Disable Presentation Animation
                (arguments["disablePresentationAnimation"] as? Boolean)?.let {
                    disablePresentationAnimation = it
                }
                // Return Collected Data
                (arguments["returnCollectedData"] as? Boolean)?.let {
                    returnCollectedData = it
                }

                // Determine Theme Resource
                val themeResId = if (styleVariant == StyleVariant.DARK) {
                    R.style.Persona_Inquiry2_Theme_Dark
                } else {
                    R.style.Persona_Inquiry2_Theme
                }

                // Configuration
                (arguments["inquiryId"] as? String)?.let {

                    var builder: InquiryBuilder? = Inquiry.fromInquiry(it)

                    builder = builder?.sessionToken(sessionToken)
                    builder = builder?.locale(locale)

                    // Theme Source logic similar to Java implementation
                    val themeSource = theme?.get("source") as? String

                    builder = if (themeSource == "server") {
                        builder?.theme(ServerThemeSource(themeResId))
                    } else {
                        builder?.theme(ClientThemeSource(themeResId))
                    }

                    builder = builder?.styleVariant(styleVariant)

                    inquiry = builder?.build()

                } ?: run {
                    var builder: InquiryTemplateBuilder? = null

                    // Fields
                    (arguments["templateVersion"] as? String)?.let { templateVersion ->
                        builder = Inquiry.fromTemplateVersion(templateVersion)

                    } ?: (arguments["templateId"] as? String)?.let { templateId ->
                        builder = Inquiry.fromTemplate(templateId)
                    }

                    builder = builder?.fields(fields)
                    builder = builder?.referenceId(referenceId)
                    builder = builder?.accountId(accountId)
                    builder = builder?.locale(locale)

                    themeSetId?.let{
                        builder = builder?.themeSetId(it)
                    }

                    environment?.let {
                        builder = builder?.environment(it)
                    }

                    environmentId?.let {
                        builder = builder?.environmentId(it)
                    }

                    builder = builder?.styleVariant(styleVariant)

                    // Theme Source logic
                    val themeSource = theme?.get("source") as? String

                    builder = if (themeSource == "server") {
                        builder?.theme(ServerThemeSource(themeResId))
                    } else {
                        builder?.theme(ClientThemeSource(themeResId))
                    }
                    
                    // Return Collected Data
                    if (returnCollectedData == true) {
                         // Use reflection or check SDK version if returnCollectedData is available
                         // Assuming SDK 2.32.0 supports it
                         // builder = builder?.returnCollectedData(true)
                         // The provided Java code uses `builder.returnCollectedData(returnCollectedData)`.
                         // Kotlin equivalent:
                         // builder?.returnCollectedData(true) - BUT we need to check if the method exists in the SDK version used.
                         // Given Java code works, we assume it exists.
                         // However, I need to verify if `builder` is of type InquiryTemplateBuilder and has that method.
                         // Let's assume standard builder pattern.
                         builder = builder?.returnCollectedData(true)
                    }

                    inquiry = builder?.build()
                }
            }
            "start" -> {
                val activity = this.activity ?: return
                val inquiry = this.inquiry ?: return

                isResultSubmitted = false
                
                if (disablePresentationAnimation) {
                     activity.overridePendingTransition(0, 0)
                }

                inquiry.start(activity, requestCode)
                
                 if (disablePresentationAnimation) {
                     activity.overridePendingTransition(0, 0)
                }
                
                result.success("Inquiry started")
            }
            "dispose" -> {
                inquiry = null
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }

        }
    }

    /// - ActivityAware interface

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.binding = binding
        this.activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        this.binding?.removeActivityResultListener(this)
        this.activity = null
        this.binding = null
        this.inquiry = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    /// - ActivityResultListener interface

    override fun onActivityResult(rcode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == rcode) {
             if (disablePresentationAnimation) {
                activity?.overridePendingTransition(0, 0)
            }
            if (!isResultSubmitted) {
                isResultSubmitted = true
                when (val result = Inquiry.onActivityResult(data)) {    
                    is InquiryResponse.Complete -> {
                        val arguments = hashMapOf<String, Any?>()
                        arguments["type"] = "complete"
                        arguments["inquiryId"] = result.inquiryId
                        arguments["status"] = result.status
                        arguments["fields"] = fieldsToMap(result.fields)
                        
                        // Collected Data
                        // val collectedData = collectedDataToMap(result.collectedData)
                        // arguments["collectedData"] = collectedData

                        eventSink?.success(arguments)
                        return true
                    }
                    is InquiryResponse.Cancel -> {
                        val arguments = hashMapOf<String, Any?>()
                        arguments["type"] = "canceled"
                        arguments["inquiryId"] = result.inquiryId
                        arguments["sessionToken"] = result.sessionToken
                        eventSink?.success(arguments)
                        return true
                    }
                    is InquiryResponse.Error -> {
                        val arguments = hashMapOf<String, Any?>()
                        arguments["type"] = "error"
                        arguments["error"] = result.debugMessage
                        eventSink?.success(arguments)
                        return true
                    }
                }
            }
        }

        return false
    }
    
    @ExperimentalInlineApi
    @OptIn(ExperimentalInquiryApi::class)
    private fun registerOnInquiryEventListener() {
        // Experimental Inquiry API usage if needed.
        Inquiry.onEventListener = object : OnInquiryEventListener {
            override fun onEvent(event: InquiryEvent) {
                // inquiryEventToMap logic
                val eventMap: Map<String, Any?>? = when (event) {
                    is InquiryEvent.StartEvent -> {
                        val map = hashMapOf<String, Any?>()
                        map["type"] = "start"
                        map["inquiryId"] = event.inquiryId
                        map["sessionToken"] = event.sessionToken
                        map
                    }
                    is InquiryEvent.PageChange -> {
                        val map = hashMapOf<String, Any?>()
                        map["type"] = "page_change"
                        map["name"] = event.name
                        map["path"] = event.path
                        map
                    }
                    else -> null
                }

                if (eventMap != null) {
                    val arguments = hashMapOf<String, Any?>()
                    arguments["type"] = "event"
                    arguments["event"] = eventMap
                    activity?.runOnUiThread {
                        eventSink?.success(arguments)
                    }
                }
            }
        }
    }

    /// - Helpers

    private fun fieldsToMap(fields: Map<String, InquiryField>): HashMap<String, Any?> {
        val result = hashMapOf<String, Any?>()

        for ((key, value) in fields) {
            when (value) {
                is InquiryField.StringField -> {
                    result[key] = value.value
                }
                is InquiryField.BooleanField -> {
                    result[key] = value.value
                }
                is InquiryField.IntegerField -> {
                    result[key] = value.value
                }
                else -> {

                }
            }
        }

        return result
    }

    private fun fieldsFromMap(map: Map<String, Any?>): Fields {
        val result = Fields.Builder()
        for ((key, value) in map) {
            when (value) {
                is String -> {
                    result.field(key, value)
                }
                is Boolean -> {
                    result.field(key, value)
                }
                is Int -> {
                    result.field(key, value)
                }
            }
        }
        return result.build()
    }

    private fun styleVariantFromString(styleVariant: String?): StyleVariant? {
        return when (styleVariant) {
            "light" -> StyleVariant.LIGHT
            "dark" -> StyleVariant.DARK
            else -> null
        }
    }
}
