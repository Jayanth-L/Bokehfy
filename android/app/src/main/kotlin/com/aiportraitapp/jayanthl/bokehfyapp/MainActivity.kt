package com.aiportraitapp.jayanthl.bokehfyapp

import android.os.Bundle
import android.os.Environment
import com.aiportraitapp.jayanthl.bokehfyapp.AiClassDir.ArtistAI

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.opencv.core.Core
import java.io.ObjectInput

class MainActivity: FlutterActivity() {

    // Defining directories
    val initDirectoryPath = Environment.getExternalStorageDirectory().toString()
    val portraitimageDirectory = initDirectoryPath + "/Portrait"
    val portraitImageDirectory = initDirectoryPath + "/Portrait"
    val cameraPortraitDirectory = portraitImageDirectory + "/Camera/"
    val imagePortraitDirectory = portraitImageDirectory + "/Images/"

    val colorHighlightDirectory = initDirectoryPath + "/ColorHighlight"
    val cameraColorHighlightDirectory = colorHighlightDirectory + "/Camera/"
    val imageColorHighlightDirectory = colorHighlightDirectory + "/Images/"


    lateinit var pendingIntentnResult: MethodChannel.Result
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        // Load the open cv native Library
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME)

        //check for permission if given then create directories
        HelperUtils(this).createDirectories()



        // Platform channel starts
        MethodChannel(flutterView, "CHANNEL_BOKEHFY").setMethodCallHandler {methodCall, result ->
            val arguments: Map<String, ObjectInput> = methodCall.arguments()

            if(methodCall.method.equals("aiArtist")) {
                val imagePath = arguments.get("image_path").toString()
                val aiTexture = arguments.get("ai_template").toString()
                ArtistAI(this).aiArtistConvert(imagePath, aiTexture, result)
            }
        }
    }
}
