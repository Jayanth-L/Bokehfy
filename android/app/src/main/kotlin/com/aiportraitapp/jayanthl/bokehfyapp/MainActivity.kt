package com.aiportraitapp.jayanthl.bokehfyapp

import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import android.content.Context
import android.widget.Toast
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import androidx.core.content.FileProvider
import com.aiportraitapp.jayanthl.bokehfyapp.AiClassDir.ArtistAI
import com.aiportraitapp.jayanthl.bokehfyapp.AiClassDir.BokehfyAI
import com.google.android.gms.tasks.Tasks

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.opencv.core.Core
import java.io.File
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
                AsyncHandler({
                    try {
                        ArtistAI(this).aiArtistConvert(imagePath, aiTexture, result)
                        return@AsyncHandler true

                    } catch (e: java.lang.Exception) {
                        return@AsyncHandler false
                    }
                }, this, result).execute()
            }

            else if(methodCall.method.equals("aiBokehfy")) {
                val imagePath = arguments.get("image_path").toString()
                val aiType = arguments.get("ai_type").toString()
                val aiSource = arguments.get("ai_source").toString()

                if(aiType == "bokehfy") {
                    BokehfyAI(this).aiConvertToPortrait(imagePath, result, aiSource)

                } else if(aiType == "chromy") {
                    BokehfyAI(this).aiConvertToChrome(imagePath, result, aiSource)
                }
            }

            /// ************************************************************************************** */

            // Get final Images

            else if(methodCall.method.equals("getBokehImages")) {
                val bokehImagesList:  ArrayList<String> = arrayListOf()
                File(HelperUtils(this).imagePortraitDirectory).walk().forEach {
                    bokehImagesList.add(it.toString())
                }
                bokehImagesList.removeAt(0)
                result.success(bokehImagesList)
            } else if (methodCall.method.equals("getChromifyImages")) {
                val chromifyImagesList:  ArrayList<String> = arrayListOf()
                File(HelperUtils(this).imageColorHighlightDirectory).walk().forEach {
                    chromifyImagesList.add(it.toString())
                }
                chromifyImagesList.removeAt(0)
                result.success(chromifyImagesList)
            } else if(methodCall.method.equals("getBokehImagesCamera")) {
                val bokehImagesList:  ArrayList<String> = arrayListOf()
                File(HelperUtils(this).cameraPortraitDirectory).walk().forEach {
                    bokehImagesList.add(it.toString())
                }
                bokehImagesList.removeAt(0)
                result.success(bokehImagesList)
            } else if(methodCall.method.equals("getChromifyImagesCamera")) {
                val chromifyImagesList:  ArrayList<String> = arrayListOf()
                File(HelperUtils(this).cameraColorHighlightDirectory).walk().forEach {
                    chromifyImagesList.add(it.toString())
                }
                chromifyImagesList.removeAt(0)
                result.success(chromifyImagesList)
            }
            else if(methodCall.method.equals("getAllPortraitImages")) {
                val bokehImagesList:  ArrayList<String> = arrayListOf()
                val bokehImageList2: ArrayList<String> = arrayListOf()
                File(HelperUtils(this).imagePortraitDirectory).walk().forEach {
                    bokehImagesList.add(it.toString())
                }
                var count = 0
                File(HelperUtils(this).cameraPortraitDirectory).walk().forEach {
                    bokehImageList2.add(it.toString())
                }
                bokehImageList2.removeAt(0)
                bokehImagesList.removeAt(0)


                result.success(bokehImageList2 + bokehImagesList)
            } else if (methodCall.method.equals("getAllChromifyImages")) {
                val chromifyImagesList:  ArrayList<String> = arrayListOf()
                val chromifyImageList2: ArrayList<String> = arrayListOf()
                File(HelperUtils(this).imageColorHighlightDirectory).walk().forEach {
                    chromifyImagesList.add(it.toString())
                }
                var count = 0
                File(HelperUtils(this).cameraColorHighlightDirectory).walk().forEach {
                    chromifyImageList2.add(it.toString())
                }
                chromifyImageList2.removeAt(0)
                chromifyImagesList.removeAt(0)


                result.success(chromifyImageList2 + chromifyImagesList)
            } else if(methodCall.method.equals("getAiArtistImages")) {
                val bokehImagesList:  ArrayList<String> = arrayListOf()
                File(HelperUtils(this).aiArtistDirectory).walk().forEach {
                    bokehImagesList.add(it.toString())
                }
                bokehImagesList.removeAt(0)
                result.success(bokehImagesList)
            }

            else if(methodCall.method.equals("shareImageFile")) {
                val shareImagePath = arguments.get("imagepath").toString()
                var shareImageFile = Intent()
                shareImageFile.setAction(Intent.ACTION_SEND)
                shareImageFile.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                val photoURI: Uri = FileProvider.getUriForFile(this,this.applicationContext.packageName + ".com.aiportraitapp.jayanthl.bokehfyapp.provider",File(shareImagePath))
                shareImageFile.setType("image/*")
                shareImageFile.putExtra(Intent.EXTRA_STREAM, photoURI)
                try {
                    startActivity(shareImageFile)
                    result.success("success")
                } catch(e: Exception) {
                    result.success("failure")
                }
            }

            else if(methodCall.method.equals("getStoragePermission")) {
                if (checkSelfPermission(android.Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                    requestPermissions(arrayOf(android.Manifest.permission.WRITE_EXTERNAL_STORAGE), 1001)
                }
                this.pendingIntentnResult = result
            } else if(methodCall.method.equals("checkStoragePermission")) {
                if (checkSelfPermission(android.Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
                    result.success("true")
                } else {
                    result.success("false")
                    Toast.makeText(this, "Please provide storage permission to be able to save photos", Toast.LENGTH_LONG).show()
                }
            }

             else if(methodCall.method.equals("isFirstTimeAndCheckPermission")) {
                var firstTime: Boolean
                var isPermissionNotGranted: Boolean
                val sharedPreferences = getSharedPreferences(packageName, Context.MODE_PRIVATE)
                val notFirst = sharedPreferences.getBoolean("first", false)
                if(notFirst) {
                    Log.i("Init.this", "Not first time")
                    firstTime = false
                } else {
                    Log.i("Init.this", "First Time")
                    sharedPreferences.edit().putBoolean("first", true).commit()
                    firstTime = true
                }
                if (checkSelfPermission(android.Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                    isPermissionNotGranted = true
                } else {
                    isPermissionNotGranted = false
                }

                var finalStartUpResult: String = ""
                if(firstTime || isPermissionNotGranted) {
                    finalStartUpResult = "true"
                } else {
                    finalStartUpResult = "false"
                }

                result.success(finalStartUpResult)
            }
        }
    }
}
