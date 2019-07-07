package com.aiportraitapp.jayanthl.bokehfyapp

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Environment
import androidx.core.content.ContextCompat.checkSelfPermission
import java.io.File

class HelperUtils(mContext: Context) {

    var mContext: Context = mContext

    val initDirectoryPath = Environment.getExternalStorageDirectory().toString()
    val portraitimageDirectory = initDirectoryPath + "/Portrait"
    val portraitImageDirectory = initDirectoryPath + "/Portrait"
    val cameraPortraitDirectory = portraitImageDirectory + "/Camera/"
    val imagePortraitDirectory = portraitImageDirectory + "/Images/"

    val colorHighlightDirectory = initDirectoryPath + "/ColorHighlight"
    val cameraColorHighlightDirectory = colorHighlightDirectory + "/Camera/"
    val imageColorHighlightDirectory = colorHighlightDirectory + "/Images/"


    fun createDirectories() {
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(mContext, android.Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                // requestPermissions(arrayOf(android.Manifest.permission.WRITE_EXTERNAL_STORAGE), 1001)
            } else {
                // Check for the directories
                if (!File(initDirectoryPath).exists()) {
                    File(initDirectoryPath).mkdir()
                }
                if(!File(portraitImageDirectory).exists()) {
                    File(portraitImageDirectory).mkdir()
                }

                if(!File(cameraPortraitDirectory).exists()) {
                    File(cameraPortraitDirectory).mkdir()
                }

                if(!File(imagePortraitDirectory).exists()) {
                    File(imagePortraitDirectory).mkdir()
                }

                if(!File(colorHighlightDirectory).exists()) {
                    File(colorHighlightDirectory).mkdir()
                }

                if(!File(imageColorHighlightDirectory).exists()) {
                    File(imageColorHighlightDirectory).mkdir()
                }

                if(!File(cameraColorHighlightDirectory).exists()) {
                    File(cameraColorHighlightDirectory).mkdir()
                }
            }
        }
    }
}