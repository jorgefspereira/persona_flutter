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
import java.text.SimpleDateFormat
import java.util.Date
import kotlin.collections.ArrayList
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
        val note = call.argument<String>("note")

        if (inquiryId != null) {
          Inquiry.fromInquiry(inquiryId)
                  .accessToken(accessToken)
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
                  .note(note)

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
        is Inquiry.Response.Success -> {
          val arguments = hashMapOf<String, Any?>();
          arguments["inquiryId"] = result.inquiryId;
          arguments["attributes"] = attributesToMap(result.attributes);
          arguments["relationships"] = relationshipsToArrayMap(result.relationships);

          channel.invokeMethod("onSuccess", arguments);
          return true;
        }
        is Inquiry.Response.Failure -> {
          val arguments = hashMapOf<String, Any?>();
          arguments["inquiryId"] = result.inquiryId;
          arguments["attributes"] = attributesToMap(result.attributes);
          arguments["relationships"] = relationshipsToArrayMap(result.relationships);
          channel.invokeMethod("onFailed", arguments);
          return true;
        }
        Inquiry.Response.Cancel -> {
          channel.invokeMethod("onCancelled", null);
          return true;
        }
        is Inquiry.Response.Error -> {
          val arguments = hashMapOf<String, Any?>();
          arguments["error"] = result.debugMessage;
          channel.invokeMethod("onError", arguments);
          return true;
        }
      }
    }

    return false;
  }

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

    if (attributes.birthdate is Date) {
      val formatter = SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
      result["birthdate"] = formatter.format(attributes.birthdate);
    }

    return result;
  }

  private fun relationshipsToArrayMap(relationships: Relationships): ArrayList<HashMap<String, Any?>> {
    val list = arrayListOf<HashMap<String,Any?>>();

    for (verification in relationships.verifications) {
      val item = hashMapOf<String, Any?>();
      item["id"] = verification.id;

      when (verification.status) {
        Verification.Status.PASSED -> item["status"] = "passed"
        Verification.Status.FAILED -> item["status"] = "failed"
        Verification.Status.REQUIRES_RETRY -> item["status"] = "requiresRetry"
      }

      when (verification) {
        is Verification.GovernmentId -> item["type"] = "governmentId"
        is Verification.Database -> item["type"] = "database"
        is Verification.PhoneNumber -> item["type"] = "phoneNumber"
        is Verification.Document -> item["type"] = "document"
        is Verification.Selfie -> item["type"] = "selfie"
      }

      list.add(item);
    }

    return list;
  }

  /// - ActivityAware interface

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.binding = binding;
    this.activity = binding.activity;
    binding.addActivityResultListener(this);
  }

  override fun onDetachedFromActivity() {
    this.binding?.removeActivityResultListener(this);
    this.activity = null;
    this.binding = null;
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding);
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }
}
