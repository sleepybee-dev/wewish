package com.codeinsongdo.wewish.wewish

import android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.codeinsongdo.wewish/add-wish"
    private val METHOD_GET_SHARED_TEXT = "getSharedText"
    private var sharedText: String = ""

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)

    }

    override fun onResume() {
        super.onResume()
        val action = intent.action
        val type = intent.type

        if (action == Intent.ACTION_SEND && type != null) {
            if ("text/plain" == type) {
            sharedText = intent.getStringExtra(Intent.EXTRA_TEXT) ?: ""
                if (sharedText.contains("http")) {
                    val reg = Regex("https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#()?&//=]*)")
                    reg.find(sharedText)?.apply {
                        sharedText = value
                    }
                }
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{ call, result ->
            if (call.method!!.contentEquals(METHOD_GET_SHARED_TEXT)) {
                result.success(sharedText)
                sharedText = ""
            }
        }
    }

}

