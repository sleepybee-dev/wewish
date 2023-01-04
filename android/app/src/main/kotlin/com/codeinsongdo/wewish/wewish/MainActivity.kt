package com.codeinsongdo.wewish.wewish

import android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.codeinsongdo.wewish/add-wish"
    private var sharedText: String = ""

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)


        var action = intent.action
        var type = intent.type

//        if (action == Intent.ACTION_SEND && type != null) {
//            if ("text/plain".equals(type)) {
//                sharedText = intent.getStringExtra(Intent.EXTRA_TEXT) ?? ""
//            }
//        }
//
//        MethodChannel(flutte, CHANNEL).setMethodCallHandler{ call, result ->
//            if (call.method.contentEquals("getSharedText")) {
//                    result.success(sharedText)
//                    sharedText = ""
//                }
//            }
//        }
    }

}
