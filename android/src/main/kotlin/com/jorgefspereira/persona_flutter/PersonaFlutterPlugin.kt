package com.jorgefspereira.persona_flutter

import android.app.Activity
import android.content.Intent

import com.withpersona.sdk2.inquiry.*
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
    private var isResultSubmitted = false;
    /// - FlutterPlugin interface

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, "persona_flutter")
        methodChannel.setMethodCallHandler(this)
        eventChannel = EventChannel(binding.binaryMessenger, "persona_flutter/events")
        eventChannel.setStreamHandler(this)
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
                var routingCountry: String? = null
                var sessionToken: String? = null
                var referenceId: String? = null

                // Environment
                (arguments["environment"] as? String)?.let {
                    environment = Environment.valueOf(it.uppercase())
                }
                // Environment Id
                (arguments["environmentId"] as? String)?.let {
                    environmentId = it
                }
                // Theme
                (arguments["theme"] as?  Map<String, Any?>)?.let {
                    theme = it
                }
                // Fields
                (arguments["fields"] as?  Map<String, Any?>)?.let  {
                    fields = fieldsFromMap(it)
                }
                // Routing Country
                (arguments["routingCountry"] as? String)?.let {
                    routingCountry = it
                }
                // Session Token
                (arguments["sessionToken"] as?  String)?.let  {
                    sessionToken = it
                }
                // Reference Id
                (arguments["referenceId"] as? String)?.let {
                    referenceId = it
                }

                // Configuration
                (arguments["inquiryId"] as? String)?.let {

                    var builder: InquiryBuilder? = Inquiry.fromInquiry(it)

                    builder = builder?.sessionToken(sessionToken)
                    builder = builder?.routingCountry(routingCountry)

                    theme?.let {
                        when(it["source"]) {
                            "server" -> builder = builder?.theme(ServerThemeSource(R.style.Persona_Inquiry_Theme))
                            "client" -> builder = builder?.theme(ClientThemeSource(R.style.Persona_Inquiry_Theme))
                        }
                    }

                    inquiry = builder?.build()

                } ?: run {
                    var builder: InquiryTemplateBuilder? = null

                    // Fields
                    (arguments["templateVersion"] as? String)?.let { templateVersion ->
                        builder = Inquiry.fromTemplateVersion(templateVersion)

                    } ?: (arguments["templateId"] as? String)?.let { templateId ->
                        builder = Inquiry.fromTemplate(templateId)
                    }

                    builder = builder?.routingCountry(routingCountry)
                    builder = builder?.fields(fields)
                    builder = builder?.referenceId(referenceId)

                    environment?.let {
                        builder = builder?.environment(it)
                    }

                    environmentId?.let {
                        builder = builder?.environmentId(it)
                    }

                    theme?.let {
                        when(it["source"]) {
                            "server" -> builder = builder?.theme(ServerThemeSource(R.style.Persona_Inquiry_Theme))
                            "client" -> builder = builder?.theme(ClientThemeSource(R.style.Persona_Inquiry_Theme))
                        }
                    }

                    inquiry = builder?.build()
                }
            }
            "start" -> {
                val activity = this.activity ?: return
                val inquiry = this.inquiry ?: return

                inquiry.start(activity, requestCode)
                result.success("Inquiry started with templateId")
            }
            else -> result.notImplemented()

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
            if (!isResultSubmitted) {
                isResultSubmitted = true;
                when (val result = Inquiry.onActivityResult(data)) {    
                    is InquiryResponse.Complete -> {
                        val arguments = hashMapOf<String, Any?>()
                        arguments["type"] = "complete"
                        arguments["inquiryId"] = result.inquiryId
                        arguments["status"] = result.status
                        arguments["fields"] = fieldsToMap(result.fields)
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
}
