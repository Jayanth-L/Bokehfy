package com.aiportraitapp.jayanthl.bokehfyapp

import android.app.Activity
import android.content.Intent
import android.content.Context
import android.content.pm.PackageManager
import android.content.res.AssetFileDescriptor
import android.graphics.*
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import android.widget.Toast
import com.google.firebase.ml.common.modeldownload.FirebaseModelDownloadConditions
import com.google.firebase.ml.common.modeldownload.FirebaseModelManager
import com.google.firebase.ml.common.modeldownload.FirebaseRemoteModel
import com.google.firebase.ml.custom.*

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.opencv.android.Utils
import org.opencv.core.Core
import org.opencv.core.CvType
import org.opencv.core.Mat
import org.opencv.core.Size
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc
import java.lang.reflect.Array

class MainActivity: FlutterActivity() {


    lateinit var pendingIntentnResult: MethodChannel.Result
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        var conditionsBuilder: FirebaseModelDownloadConditions.Builder = FirebaseModelDownloadConditions
                .Builder()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            conditionsBuilder = conditionsBuilder.requireCharging().requireDeviceIdle()
        }

        val conditions = conditionsBuilder.build()

        val cloudSourcePaint = FirebaseRemoteModel.Builder("paint_artist")
                .enableModelUpdates(true)
                .setUpdatesDownloadConditions(conditions)
                .build()

        FirebaseModelManager.getInstance().registerRemoteModel(cloudSourcePaint)
        Log.i("TensorflowInit", "Paint Tensorflow model registered successfully")
        FirebaseModelManager.getInstance().downloadRemoteModelIfNeeded(cloudSourcePaint)
                .addOnSuccessListener {
                    Log.i("TensorflowInit", "Paint model downloaded successfully")
                }
                .addOnFailureListener {
                    Log.i("TensorflowInit", "Paint model couldn't de downloaded")
                }

        System.loadLibrary(Core.NATIVE_LIBRARY_NAME)


        // Platform channel starts
        MethodChannel(flutterView, "CHANNEL_BOKEHFY").setMethodCallHandler {methodCall, result ->

        }
    }
}
