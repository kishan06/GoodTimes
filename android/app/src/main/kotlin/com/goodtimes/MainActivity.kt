package com.goodtimes

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.core.content.FileProvider
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "appinio_social_share"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val flutterEngine = flutterEngine
        if (flutterEngine != null) {
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler { call, result ->
                    when (call.method) {
                        "shareToFacebook" -> {
                            val text = call.argument<String>("text")
                            val filePath = call.argument<String>("filePath")
                            shareToFacebook(text, filePath)
                            result.success(null)
                        }
                        "shareToTwitter" -> {
                            val text = call.argument<String>("text")
                            val filePath = call.argument<String>("filePath")
                            shareToTwitter(text, filePath)
                            result.success(null)
                        }
                        "shareToInstagram" -> {
                            val text = call.argument<String>("text")
                            val filePath = call.argument<String>("filePath")
                            shareToInstagram(text, filePath)
                            result.success(null)
                        }
                        else -> result.notImplemented()
                    }
                }
        }
    }

    private fun shareToFacebook(text: String?, filePath: String?) {
        val intent = Intent(Intent.ACTION_SEND)
        intent.type = "image/*"

        intent.putExtra(Intent.EXTRA_TEXT, text)

        val imageUri: Uri? = filePath?.let {
            val file = File(it)
            Log.d("ShareToFacebook", "File path: $filePath")
            if (file.exists()) {
                FileProvider.getUriForFile(this, "$packageName.fileprovider", file)
            } else {
                Log.e("ShareToFacebook", "File does not exist: $filePath")
                null
            }
        }

        intent.putExtra(Intent.EXTRA_STREAM, imageUri)
        intent.setPackage("com.facebook.katana")

        if (intent.resolveActivity(packageManager) != null) {
            startActivity(intent)
        } else {
            Log.e("ShareToFacebook", "Facebook app not found.")
        }
    }

    private fun shareToTwitter(text: String?, filePath: String?) {
        val intent = Intent(Intent.ACTION_SEND)
        intent.type = "image/*"

        intent.putExtra(Intent.EXTRA_TEXT, text)

        val imageUri: Uri? = filePath?.let {
            val file = File(it)
            Log.d("ShareToTwitter", "File path: $filePath")
            if (file.exists()) {
                FileProvider.getUriForFile(this, "$packageName.fileprovider", file)
            } else {
                Log.e("ShareToTwitter", "File does not exist: $filePath")
                null
            }
        }

        intent.putExtra(Intent.EXTRA_STREAM, imageUri)
        intent.setPackage("com.twitter.android")

        if (intent.resolveActivity(packageManager) != null) {
            startActivity(intent)
        } else {
            Log.e("ShareToTwitter", "Twitter app not found.")
        }
    }

    private fun shareToInstagram(text: String?, filePath: String?) {
        val intent = Intent(Intent.ACTION_SEND)
        intent.type = "image/*"

        intent.putExtra(Intent.EXTRA_TEXT, text)

        val imageUri: Uri? = filePath?.let {
            val file = File(it)
            Log.d("ShareToInstagram", "File path: $filePath")
            if (file.exists()) {
                FileProvider.getUriForFile(this, "$packageName.fileprovider", file)
            } else {
                Log.e("ShareToInstagram", "File does not exist: $filePath")
                null
            }
        }

        intent.putExtra(Intent.EXTRA_STREAM, imageUri)
        intent.setPackage("com.instagram.android")

        if (intent.resolveActivity(packageManager) != null) {
            startActivity(intent)
        } else {
            Log.e("ShareToInstagram", "Instagram app not found.")
        }
    }
}

