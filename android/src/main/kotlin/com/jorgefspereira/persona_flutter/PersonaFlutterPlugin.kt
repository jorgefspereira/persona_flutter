package com.jorgefspereira.persona_flutter

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull;
import com.withpersona.sdk.inquiry.Inquiry
import com.withpersona.sdk.inquiry.Attributes
import com.withpersona.sdk.inquiry.Relationships
import com.withpersona.sdk.inquiry.Verification
import com.withpersona.sdk.inquiry.Environment

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.time.format.DateTimeFormatter
import java.util.*
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
      "start" -> start(call.arguments)
      else -> result.notImplemented()
    }
  }

  private fun start(arguments: Any) {
    val activity = this.activity ?: return
    val args = arguments as Map<*, *>

    val templateId = args["templateId"] as String?
    val inquiryId = args["inquiryId"] as String?
    val referenceId = args["referenceId"] as String?
    val accountId = args["accountId"] as String?
    val environment = args["environment"] as String?
    val note = args["note"] as String?

    if (inquiryId != null) {
      Inquiry.fromInquiry(inquiryId)
              .build().start(activity, requestCode);
    }
    else if(templateId != null) {
      val inquiry = Inquiry.fromTemplate(templateId)
              .accountId(accountId)
              .referenceId(referenceId)
              .note(note)

      if (environment != null) {
        inquiry.environment(Environment.valueOf(environment.toUpperCase()));
      }

      inquiry.build().start(activity, requestCode);
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
          arguments["relationships"] = relationshipsToArray(result.relationships);

          channel.invokeMethod("onSuccess", arguments);
          return true;
        }
        is Inquiry.Response.Failure -> {
          val arguments = hashMapOf<String, Any?>();
          arguments["inquiryId"] = result.inquiryId;
          arguments["attributes"] = attributesToMap(result.attributes);
          arguments["relationships"] = relationshipsToArray(result.relationships);
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
    val map = hashMapOf<String, Any?>();

    map["firstName"] = attributes.name?.first;
    map["middleName"] = attributes.name?.middle;
    map["lastName"] = attributes.name?.last;
    map["street1"] = attributes.address?.street1;
    map["street2"] = attributes.address?.street2;
    map["city"] = attributes.address?.city;
    map["subdivision"] = attributes.address?.subdivision;
    map["postalCode"] = attributes.address?.postalCode;
    map["countryCode"] = attributes.address?.countryCode;

    if (attributes.birthdate is Date) {
      val formatter = SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
      formatter.format(attributes.birthdate);
      map["birthdate"] = formatter.format(attributes.birthdate);
    }

    return map;
  }

  private fun relationshipsToArray(relationships: Relationships): ArrayList<HashMap<String, Any?>> {
    val list = arrayListOf<HashMap<String,Any?>>();

    for (verification in relationships.verifications) {
      val item = hashMapOf<String, Any?>();
      item["id"] = verification.id;
      item["status"] = verification.status.name;
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
