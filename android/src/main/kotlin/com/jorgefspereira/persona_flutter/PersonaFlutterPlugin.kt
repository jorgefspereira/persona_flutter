package com.jorgefspereira.persona_flutter

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull;
import com.withpersona.sdk.inquiry.Environment

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import com.withpersona.sdk.inquiry.Inquiry
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry

/** PersonaFlutterPlugin */
public class PersonaFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  private lateinit var channel : MethodChannel
  private var activity: Activity? = null
  private val requestCode = 57

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "persona_flutter")
      val plugin = PersonaFlutterPlugin()
      plugin.activity = registrar.activity()
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
          arguments["attributes"] = "";
          arguments["relationships"] = "";
          channel.invokeMethod("onSuccess", arguments);
          return true;
        }
        is Inquiry.Response.Failure -> {
          val arguments = hashMapOf<String, Any?>();
          arguments["attributes"] = "";
          arguments["relationships"] = "";
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

  /// - ActivityAware interface

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    this.activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    this.activity = null
  }

}
