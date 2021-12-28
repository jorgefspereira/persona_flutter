package com.jorgefspereira.persona_flutter

import android.app.Activity
import android.content.Intent
import android.os.AsyncTask
import androidx.annotation.NonNull
import com.withpersona.sdk.inquiry.*

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import kotlin.collections.HashMap

/** PersonaFlutterPlugin */
public class PersonaFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  private lateinit var channel : MethodChannel
  private var activity: Activity? = null
  private var binding: ActivityPluginBinding? = null
  private val requestCode = 57

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "persona_flutter")
      val plugin = PersonaFlutterPlugin()
      plugin.activity = registrar.activity()
      registrar.addActivityResultListener(plugin);
      channel.setMethodCallHandler(plugin)
    }
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "persona_flutter")
    channel.setMethodCallHandler(this);
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "start" -> {
        val activity = this.activity ?: return

        val inquiryId = call.argument<String>("inquiryId")
        val accessToken = call.argument<String>("accessToken")
        val templateId = call.argument<String>("templateId")
        val referenceId = call.argument<String>("referenceId")
        val accountId = call.argument<String>("accountId")
        val environment = call.argument<String>("environment")
        val fieldsMap = call.argument<Map<String, Any>>("fields")

        if (inquiryId != null) {
          Inquiry.fromInquiry(inquiryId)
                  .sessionToken(accessToken)
                  .build().start(activity, requestCode);

          result.success("Inquiry started with inquiryId")
        }
        else if(templateId != null) {

          val fieldsBuilder = Fields.Builder()

          if (fieldsMap != null) {
            val nameMap = fieldsMap["name"] as? Map<*, *>
            val addressMap = fieldsMap["address"] as? Map<*, *>
            val emailAddress = fieldsMap["emailAddress"] as? String
            val phoneNumber = fieldsMap["phoneNumber"] as? String
            val birthdate = fieldsMap["birthdate"] as? String
            val additionalFields = fieldsMap["additionalFields"] as? Map<String, *>

            if(nameMap != null) {
              val first = nameMap["first"] as String?
              val middle = nameMap["middle"] as String?
              val last = nameMap["last"] as String?

              if (first != null)
               fieldsBuilder.field("nameFirst", first)
              if (middle != null)
                fieldsBuilder.field("nameMiddle", middle)
              if (last != null)
                fieldsBuilder.field("nameLast", last)
            }

            if(addressMap != null ) {
              val street1 = addressMap["street1"] as? String
              val street2 = addressMap["street2"] as? String
              val city = addressMap["city"] as? String
              val subdivision = addressMap["subdivision"] as? String
              val postalCode = addressMap["postalCode"] as? String
              val countryCode = addressMap["countryCode"] as? String

              if (street1 != null)
                fieldsBuilder.field("addressStreet1", street1)
              if (street2 != null)
                fieldsBuilder.field("addressStreet2", street2)
              if (city != null)
                fieldsBuilder.field("addressCity", city)
              if (subdivision != null)
                fieldsBuilder.field("addressSubdivision", subdivision)
              if (postalCode != null)
                fieldsBuilder.field("addressPostalCode", postalCode)
              if (countryCode != null)
                fieldsBuilder.field("addressCountryCode", countryCode)
            }

            if (emailAddress != null) {
              fieldsBuilder.field("emailAddress", emailAddress)
            }

            if (phoneNumber != null) {
              fieldsBuilder.field("phoneNumber", phoneNumber)
            }

            if(birthdate != null) {
              fieldsBuilder.field("birthDate", birthdate);
            }

            if(additionalFields != null) {
              for ((key, value) in additionalFields) {
                when(value) {
                  is Int -> fieldsBuilder.field(key, value)
                  is String -> fieldsBuilder.field(key, value)
                  is Boolean -> fieldsBuilder.field(key, value)
                }
              }
            }
          }

          val inquiry = Inquiry.fromTemplate(templateId)
                  .accountId(accountId)
                  .referenceId(referenceId)
                  .fields(fieldsBuilder.build())

          if (environment != null) {
            inquiry.environment(Environment.valueOf(environment.toUpperCase()));
          }

          inquiry.build().start(activity, requestCode)
          result.success("Inquiry started with templateId")
        }
      }
      else -> result.notImplemented()
    }
  }

  /// - ActivityResultListener interface

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    if (requestCode == requestCode) {
      when(val result = Inquiry.onActivityResult(data)) {
        is InquiryResponse.Complete -> {
          val arguments = hashMapOf<String, Any?>()
          arguments["inquiryId"] = result.inquiryId
          arguments["attributes"] = fieldsToMap(result.fields)
          if (result.status == "completed") {
            channel.invokeMethod("onSuccess", arguments)
          } else if (result.status == "failed") {
            channel.invokeMethod("onFailed", arguments)
          }
          return true
        }
        is InquiryResponse.Cancel -> {
          channel.invokeMethod("onCancelled", null)
          return true
        }
        is InquiryResponse.Error -> {
          val arguments = hashMapOf<String, Any?>()
          arguments["error"] = result.debugMessage
          channel.invokeMethod("onError", arguments)
          return true
        }
      }
    }

    return false
  }

  /// - Helpers

  private fun fieldsToMap(fields: Map<String, InquiryField>): HashMap<String, Any?> {
    val result = hashMapOf<String, Any?>();
    val nameMap = hashMapOf<String, Any?>();
    val addressMap = hashMapOf<String, Any?>();

    nameMap["first"] = (fields["nameFirst"] as? InquiryField.StringField)?.value
    nameMap["middle"] = (fields["nameMiddle"] as? InquiryField.StringField)?.value
    nameMap["last"] = fields["nameLast"];

    addressMap["street1"] = (fields["addressStreet1"] as? InquiryField.StringField)?.value
    addressMap["street2"] = (fields["addressStreet2"] as? InquiryField.StringField)?.value
    addressMap["city"] = (fields["addressCity"] as? InquiryField.StringField)?.value
    addressMap["subdivision"] = (fields["addressSubdivision"] as? InquiryField.StringField)?.value
    addressMap["subdivisionAbbr"] = (fields["addressSubdivisionAbbr"] as? InquiryField.StringField)?.value
    addressMap["postalCode"] = (fields["addressPostalCode"] as? InquiryField.StringField)?.value
    addressMap["countryCode"] = (fields["addressCountryCode"] as? InquiryField.StringField)?.value

    result["name"] = nameMap
    result["address"] = addressMap

    result["birthdate"] = (fields["birthdate"] as? InquiryField.StringField)?.value

    return result
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
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }
}
