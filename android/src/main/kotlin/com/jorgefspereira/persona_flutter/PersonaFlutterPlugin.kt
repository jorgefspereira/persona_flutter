package com.jorgefspereira.persona_flutter

import android.app.Activity
import android.content.Intent
import android.os.AsyncTask
import androidx.annotation.NonNull
import com.withpersona.sdk2.inquiry.*

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import java.util.*
import kotlin.collections.HashMap

/** PersonaFlutterPlugin */
public class PersonaFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var binding: ActivityPluginBinding? = null
    private val requestCode = 57
    private var inquiry: Inquiry? = null

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
            "init" -> {
                val arguments = call.arguments as? Map<String, Any?> ?: return

                // Fields
                var fields: Fields? = null

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
                        environment = Environment.valueOf(it.toUpperCase(Locale.getDefault()))
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

    /// - ActivityResultListener interface

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == requestCode) {
            when (val result = Inquiry.onActivityResult(data)) {
                is InquiryResponse.Complete -> {
                    val arguments = hashMapOf<String, Any?>()
                    arguments["inquiryId"] = result.inquiryId
                    arguments["status"] = result.status
                    arguments["fields"] = fieldsToMap(result.fields)
                    channel.invokeMethod("onComplete", arguments)
                    return true
                }
                is InquiryResponse.Cancel -> {
                    val arguments = hashMapOf<String, Any?>()
                    arguments["inquiryId"] = result.inquiryId
                    arguments["sessionToken"] = result.sessionToken
                    channel.invokeMethod("onCanceled", arguments)
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
}
