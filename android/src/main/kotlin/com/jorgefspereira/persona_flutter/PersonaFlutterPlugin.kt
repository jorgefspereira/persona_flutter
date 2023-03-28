package com.jorgefspereira.persona_flutter

import android.app.Activity
import android.content.Intent
<<<<<<< HEAD
import androidx.annotation.NonNull
import com.withpersona.sdk.inquiry.*
=======
>>>>>>> v2

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
<<<<<<< HEAD

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
=======
>>>>>>> v2
import io.flutter.plugin.common.PluginRegistry

/** PersonaFlutterPlugin */
class PersonaFlutterPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel

<<<<<<< HEAD
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "persona_flutter")
    channel.setMethodCallHandler(this);
  }
=======
    private var activity: Activity? = null
    private var binding: ActivityPluginBinding? = null
    private var eventSink: EventSink? = null
    private val requestCode = 57
    private var inquiry: Inquiry? = null

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
>>>>>>> v2

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

                // Fields
                var fields: Fields? = null

<<<<<<< HEAD
          if (fieldsMap != null) {
            val nameMap = fieldsMap["name"] as? Map<*, *>
            val addressMap = fieldsMap["address"] as? Map<*, *>
            val emailAddress = fieldsMap["emailAddress"] as? String
            val phoneNumber = fieldsMap["phoneNumber"] as? String
            val birthdate = fieldsMap["birthdate"] as? String
            val additionalFields = fieldsMap["additionalFields"] as? Map<*, *>

            if(nameMap != null) {
              val first = nameMap["first"] as String?
              val middle = nameMap["middle"] as String?
              val last = nameMap["last"] as String?

              fieldsBuilder.name(first, middle, last)
            }

            if(addressMap != null ) {
              val street1 = addressMap["street1"] as? String
              val street2 = addressMap["street2"] as? String
              val city = addressMap["city"] as? String
              val subdivision = addressMap["subdivision"] as? String
              val postalCode = addressMap["postalCode"] as? String
              val countryCode = addressMap["countryCode"] as? String

              fieldsBuilder.address(street1, street2, city, subdivision, postalCode, countryCode)
            }

            if (emailAddress != null) {
              fieldsBuilder.emailAddress(emailAddress)
            }

            if (phoneNumber != null) {
              fieldsBuilder.phoneNumber(phoneNumber)
            }

            if(birthdate != null) {
              val formatter = SimpleDateFormat("yyyy-MM-dd hh:mm:ss")
              formatter.format(birthdate);
              fieldsBuilder.birthdate(formatter.calendar)
            }

            if(additionalFields != null) {
              for ((key, value) in additionalFields) {
                if (key is String) {
                  when(value) {
                    is Int -> fieldsBuilder.field(key, value)
                    is String -> fieldsBuilder.field(key, value)
                    is Boolean -> fieldsBuilder.field(key, value)
                  }
=======
                (arguments["fields"] as?  Map<String, Any?>)?.let  {
                    fields = fieldsFromMap(it)
                }

                // Configuration
                (arguments["inquiryId"] as? String)?.let {
                    inquiry = Inquiry
                            .fromInquiry(it)
                            .sessionToken(arguments["sessionToken"] as? String).build()
                } ?: run {
                    var environment: Environment? = null

                    // Environment
                    (arguments["environment"] as? String)?.let {
                        environment = Environment.valueOf(it.uppercase())
                    }

                    var theme: Map<String, Any?>? = null

                    // Theme
                    (arguments["theme"] as?  Map<String, Any?>)?.let {
                        theme = it
                    }

                    var builder: InquiryTemplateBuilder? = null

                    // Fields
                    (arguments["templateVersion"] as? String)?.let { templateVersion ->
                        (arguments["accountId"] as? String)?.let { accountId ->
                            builder = Inquiry
                                    .fromTemplateVersion(templateVersion)
                                    .accountId(accountId)
                        } ?: (arguments["referenceId"] as? String)?.let { referenceId ->
                            builder = Inquiry
                                    .fromTemplateVersion(templateVersion)
                                    .referenceId(referenceId)
                        } ?: run {
                            builder = Inquiry.fromTemplateVersion(templateVersion)
                        }
                    } ?: (arguments["templateId"] as? String)?.let { templateId ->
                        (arguments["accountId"] as? String)?.let { accountId ->
                            builder = Inquiry
                                    .fromTemplate(templateId)
                                    .accountId(accountId)
                        } ?: (arguments["referenceId"] as? String)?.let { referenceId ->
                            builder = Inquiry
                                    .fromTemplate(templateId)
                                    .referenceId(referenceId)
                        } ?: run {
                            builder = Inquiry.fromTemplate(templateId)
                        }
                    }

                    environment?.let {
                        builder = builder?.environment(it)
                    }

                    fields?.let {
                        builder = builder?.fields(it)
                    }

                    theme?.let {
                        when(it["source"]) {
                            "server" -> builder = builder?.theme(ServerThemeSource(R.style.Persona_Inquiry_Theme))
                            "client" -> builder = builder?.theme(ClientThemeSource(R.style.Persona_Inquiry_Theme))
                        }
                    }

                    inquiry = builder?.build()
>>>>>>> v2
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

<<<<<<< HEAD
  /// - Helpers

  private fun attributesToMap(attributes: Attributes): HashMap<String, Any?> {
    val result = hashMapOf<String, Any?>();
    val nameMap = hashMapOf<String, Any?>();
    val addressMap = hashMapOf<String, Any?>();

    nameMap["first"] = attributes.name?.first;
    nameMap["middle"] = attributes.name?.middle;
    nameMap["last"] = attributes.name?.last;

    addressMap["street1"] = attributes.address?.street1;
    addressMap["street2"] = attributes.address?.street2;
    addressMap["city"] = attributes.address?.city;
    addressMap["subdivision"] = attributes.address?.subdivision;
    addressMap["subdivisionAbbr"] = attributes.address?.subdivisionAbbr;
    addressMap["postalCode"] = attributes.address?.postalCode;
    addressMap["countryCode"] = attributes.address?.countryCode;

    result["name"] = nameMap;
    result["address"] = addressMap;

    val birthdate = attributes.birthdate

    if (birthdate != null) {
      val formatter = SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
      result["birthdate"] = formatter.format(birthdate);
=======
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.binding = binding
        this.activity = binding.activity
        binding.addActivityResultListener(this)
>>>>>>> v2
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
