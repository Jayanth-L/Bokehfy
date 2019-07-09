package com.aiportraitapp.jayanthl.bokehfyapp.AiClassDir

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Color
import android.os.Build
import android.util.Log
import android.widget.Toast
import com.aiportraitapp.jayanthl.bokehfyapp.HelperUtils
import com.aiportraitapp.jayanthl.bokehfyapp.HelperUtilsJava
import com.google.firebase.ml.common.modeldownload.FirebaseModelDownloadConditions
import com.google.firebase.ml.common.modeldownload.FirebaseModelManager
import com.google.firebase.ml.common.modeldownload.FirebaseRemoteModel
import com.google.firebase.ml.custom.*
import io.flutter.plugin.common.MethodChannel
import org.opencv.android.Utils
import org.opencv.core.CvType
import org.opencv.core.Mat
import org.opencv.core.Size
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc
import java.util.*
import kotlin.collections.ArrayList

class BokehfyAI(mContext: Context) {
    var mContext: Context;

    init {
        this.mContext = mContext
    }

    val IMAGE_HEIGHT = 720
    val IMAGE_WIDTH = 720
    val CHANNELS = 3
    var paddingOffset = 0

    var REAL_HEIGHT = 0
    var REAL_WIDTH = 0

    lateinit var isPortrait: String

    lateinit var conditions: FirebaseModelDownloadConditions
    lateinit var cloudSourcePaint: FirebaseRemoteModel

    fun aiConvertToPortrait(imagePath: String, pendingIntentResult: MethodChannel.Result, ai_source: String) {
        var conditionsBuilder: FirebaseModelDownloadConditions.Builder = FirebaseModelDownloadConditions
                .Builder()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            conditionsBuilder = conditionsBuilder.requireCharging().requireDeviceIdle()
        }

        conditions = conditionsBuilder.build()

        cloudSourcePaint = FirebaseRemoteModel.Builder("bokehfy")
                .enableModelUpdates(true)
                .setUpdatesDownloadConditions(conditions)
                .build()

        FirebaseModelManager.getInstance().registerRemoteModel(cloudSourcePaint)
        Log.i("TensorflowInit", "Paint Tensorflow model registered successfully")
        try {
            FirebaseModelManager.getInstance().downloadRemoteModelIfNeeded(cloudSourcePaint)
                    .addOnSuccessListener {


                        try {
                            Log.i("TensorflowInit", "Paint model downloaded successfully")
                            val options = FirebaseModelOptions.Builder()
                                    .setRemoteModelName("bokehfy")
                                    .build()
                            val interpreter = FirebaseModelInterpreter.getInstance(options)

                            val inputOutputOptions = FirebaseModelInputOutputOptions.Builder()
                                    .setInputFormat(0, FirebaseModelDataType.FLOAT32, intArrayOf(1, IMAGE_HEIGHT, IMAGE_WIDTH, CHANNELS))
                                    .setOutputFormat(0, FirebaseModelDataType.FLOAT32, intArrayOf(IMAGE_HEIGHT, IMAGE_WIDTH))
                                    .build()

                            var image = Imgcodecs.imread(imagePath)
                            this.REAL_WIDTH = image.width()
                            this.REAL_HEIGHT = image.height()
                            image = AiHelpers(mContext).resizematrix(image)

                            /*if(image.width() < image.height()) {
                                this.paddingOffset = image.height() - image.width()
                                image = AiHelpers(mContext).paddImage(image, true)
                                isPortrait = "true"
                            } else {
                                this.paddingOffset = image.width() - image.height()
                                image = AiHelpers(mContext).paddImage(image, false)
                                isPortrait = "false"
                            }*/


                            val interpreterBitmap: Bitmap = Bitmap.createBitmap(IMAGE_HEIGHT, IMAGE_WIDTH, Bitmap.Config.RGB_565)
                            Utils.matToBitmap(image, interpreterBitmap)

                            // val bitmap = Bitmap.createScaledBitmap(interpreterBitmap, IMAGE_HEIGHT, IMAGE_WIDTH, true)

                            val batchNum = 0
                            val input = Array(1)  {Array(IMAGE_HEIGHT) {Array(IMAGE_WIDTH) {FloatArray(CHANNELS)}}}

                            for (x in 0..(IMAGE_HEIGHT -1)) {
                                for (y in 0..(IMAGE_WIDTH -1)) {
                                    val pixel = interpreterBitmap.getPixel(x, y)
                                    // Normalize channel values to [-1.0, 1.0]. This requirement varies by
                                    // model. For example, some models might require values to be normalized
                                    // to the range [0.0, 1.0] instead.
                                    input[batchNum][y][x][2] = Color.red(pixel).toFloat()
                                    input[batchNum][y][x][1] = Color.green(pixel).toFloat()
                                    input[batchNum][y][x][0] = Color.blue(pixel).toFloat()
                                }
                            }

                            val inputs = FirebaseModelInputs.Builder()
                                    .add(input) // add() as many input arrays as your model requires
                                    .build()
                            interpreter!!.run(inputs, inputOutputOptions)
                                    .addOnSuccessListener { result ->
                                        Log.i("TensorflowInference","Success in running inference")
                                        val output = result.getOutput<Array<FloatArray>>(0)

                                        // Process image
                                        var aiImageSegmentation = Mat(IMAGE_HEIGHT, IMAGE_WIDTH, CvType.CV_8UC3)

                                        for(i in 0..(IMAGE_HEIGHT -1)) {
                                            for(j in 0..(IMAGE_WIDTH -1)) {
                                                if(output[i][j] != 0.toFloat()) {
                                                    aiImageSegmentation.put(i, j, 1.0, 1.0, 1.0)
                                                } else {
                                                    aiImageSegmentation.put(i, j, 0.0, 0.0, 0.0)
                                                }
                                            }
                                        }

                                        val finalCroppedImage = aiImageSegmentation.mul(image)
                                        Imgproc.GaussianBlur(image, image, Size(55.0, 55.0), 3.0) // Originally it was 2.0


                                        var finalBokehImageWithoutCrop = Mat(IMAGE_HEIGHT, IMAGE_WIDTH, CvType.CV_8UC3)
                                        for (i in 0..(finalCroppedImage.height() -1)) {
                                            for (j in 0..(finalCroppedImage.width() -1)) {
                                                if((finalCroppedImage.get(i, j)[0] == 0.0) && (finalCroppedImage.get(i, j)[1] == 0.0) && (finalCroppedImage.get(i, j)[2] == 0.0)) {
                                                    finalBokehImageWithoutCrop.put(i, j, image.get(i, j)[0], image.get(i, j)[1], image.get(i, j)[2])
                                                } else {
                                                    finalBokehImageWithoutCrop.put(i, j, finalCroppedImage.get(i, j)[0], finalCroppedImage.get(i, j)[1], finalCroppedImage.get(i, j)[2])
                                                }
                                            }
                                        }

                                        // Imgproc.cvtColor(finalBokehImageWithoutCrop, finalBokehImageWithoutCrop, Imgproc.COLOR_BGR2RGB)
                                        finalBokehImageWithoutCrop = AiHelpers(mContext).restoreSize(finalBokehImageWithoutCrop, REAL_WIDTH, REAL_HEIGHT)
                                        //aiImage = AiHelpers(mContext).removePaddingOfImage(aiImage, this.paddingOffset, isPortrait)
                                        finalBokehImageWithoutCrop = HelperUtilsJava().applyWatermarkToImage(finalBokehImageWithoutCrop)

                                        var saveFileName: String
                                        if(ai_source.equals("gallery")) {
                                            saveFileName = HelperUtils(mContext).imagePortraitDirectory + ai_source + "_" + Date().time.toShort() + ".png"
                                        } else {
                                            saveFileName = HelperUtils(mContext).cameraPortraitDirectory + ai_source + "_" + Date().time.toShort() + ".png"
                                        }
                                        Imgcodecs.imwrite(saveFileName, finalBokehImageWithoutCrop)

                                        Toast.makeText(mContext, "Success in running inferenc: ${output[0][0]}", Toast.LENGTH_LONG).show()

                                        val resultList = ArrayList<String>()
                                        resultList.add("finished")
                                        resultList.add(saveFileName)

                                        pendingIntentResult.success(resultList)
                                    }
                                    .addOnFailureListener {
                                        Log.i("TensorflowInference","Failure in running inference")
                                        Toast.makeText(mContext, "Failure in running inferenc: ${it.printStackTrace()}", Toast.LENGTH_LONG).show()
                                        val resultList = ArrayList<String>()
                                        resultList.add("failure")
                                        resultList.add("null")
                                        pendingIntentResult.success(resultList)
                                    }
                        } catch (e: Exception) {
                            val resultList = ArrayList<String>()
                            resultList.add("failure")
                            resultList.add("null")
                            pendingIntentResult.success(resultList)
                            Toast.makeText(mContext, "Looks like image is corrupted or invalid file", Toast.LENGTH_LONG).show()
                        }

                    }
                    .addOnFailureListener {
                        Log.i("TensorflowInit", "Paint model couldn't de downloaded")
                        Toast.makeText(mContext, "Please make sure the network is available, we need to download dependencies", Toast.LENGTH_LONG).show()
                        val resultList = ArrayList<String>()
                        resultList.add("failure")
                        resultList.add("null")
                        pendingIntentResult.success(resultList)
                    }
        } catch (e: Exception) {
            val resultList = ArrayList<String>()
            resultList.add("failure")
            resultList.add("null")
            pendingIntentResult.success(resultList)
            Toast.makeText(mContext, "Looks like image is corrupted or invalid file", Toast.LENGTH_LONG).show()
        }
    }

    fun aiConvertToChrome(imagePath: String, pendingIntentResult: MethodChannel.Result, ai_source: String) {
        var conditionsBuilder: FirebaseModelDownloadConditions.Builder = FirebaseModelDownloadConditions
                .Builder()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            conditionsBuilder = conditionsBuilder.requireCharging().requireDeviceIdle()
        }

        conditions = conditionsBuilder.build()

        cloudSourcePaint = FirebaseRemoteModel.Builder("bokehfy")
                .enableModelUpdates(true)
                .setUpdatesDownloadConditions(conditions)
                .build()

        FirebaseModelManager.getInstance().registerRemoteModel(cloudSourcePaint)
        Log.i("TensorflowInit", "Paint Tensorflow model registered successfully")
        FirebaseModelManager.getInstance().downloadRemoteModelIfNeeded(cloudSourcePaint)
                .addOnSuccessListener {
                    try {
                        Log.i("TensorflowInit", "Paint model downloaded successfully")
                        val options = FirebaseModelOptions.Builder()
                                .setRemoteModelName("bokehfy")
                                .build()
                        val interpreter = FirebaseModelInterpreter.getInstance(options)

                        val inputOutputOptions = FirebaseModelInputOutputOptions.Builder()
                                .setInputFormat(0, FirebaseModelDataType.FLOAT32, intArrayOf(1, IMAGE_HEIGHT, IMAGE_WIDTH, CHANNELS))
                                .setOutputFormat(0, FirebaseModelDataType.FLOAT32, intArrayOf(IMAGE_HEIGHT, IMAGE_WIDTH))
                                .build()

                        var image = Imgcodecs.imread(imagePath)
                        this.REAL_WIDTH = image.width()
                        this.REAL_HEIGHT = image.height()
                        image = AiHelpers(mContext).resizematrix(image)

                        /*if(image.width() < image.height()) {
                            this.paddingOffset = image.height() - image.width()
                            image = AiHelpers(mContext).paddImage(image, true)
                            isPortrait = "true"
                        } else {
                            this.paddingOffset = image.width() - image.height()
                            image = AiHelpers(mContext).paddImage(image, false)
                            isPortrait = "false"
                        }*/


                        val interpreterBitmap: Bitmap = Bitmap.createBitmap(IMAGE_HEIGHT, IMAGE_WIDTH, Bitmap.Config.RGB_565)
                        Utils.matToBitmap(image, interpreterBitmap)

                        // val bitmap = Bitmap.createScaledBitmap(interpreterBitmap, IMAGE_HEIGHT, IMAGE_WIDTH, true)

                        val batchNum = 0
                        val input = Array(1)  {Array(IMAGE_HEIGHT) {Array(IMAGE_WIDTH) {FloatArray(CHANNELS)}}}

                        for (x in 0..(IMAGE_HEIGHT -1)) {
                            for (y in 0..(IMAGE_WIDTH -1)) {
                                val pixel = interpreterBitmap.getPixel(x, y)
                                // Normalize channel values to [-1.0, 1.0]. This requirement varies by
                                // model. For example, some models might require values to be normalized
                                // to the range [0.0, 1.0] instead.
                                input[batchNum][y][x][2] = Color.red(pixel).toFloat()
                                input[batchNum][y][x][1] = Color.green(pixel).toFloat()
                                input[batchNum][y][x][0] = Color.blue(pixel).toFloat()
                            }
                        }

                        val inputs = FirebaseModelInputs.Builder()
                                .add(input) // add() as many input arrays as your model requires
                                .build()
                        interpreter!!.run(inputs, inputOutputOptions)
                                .addOnSuccessListener { result ->
                                    Log.i("TensorflowInference","Success in running inference")
                                    val output = result.getOutput<Array<FloatArray>>(0)

                                    // Process image
                                    var aiImageSegmentation = Mat(IMAGE_HEIGHT, IMAGE_WIDTH, CvType.CV_8UC3)

                                    for(i in 0..(IMAGE_HEIGHT -1)) {
                                        for(j in 0..(IMAGE_WIDTH -1)) {
                                            if(output[i][j] != 0.toFloat()) {
                                                aiImageSegmentation.put(i, j, 1.0, 1.0, 1.0)
                                            } else {
                                                aiImageSegmentation.put(i, j, 0.0, 0.0, 0.0)
                                            }
                                        }
                                    }

                                    val finalCroppedImage = aiImageSegmentation.mul(image)


                                    Imgproc.cvtColor(image, image, Imgproc.COLOR_BGR2GRAY)
                                    Imgproc.cvtColor(image, image, Imgproc.COLOR_GRAY2BGR)


                                    var finalBokehImageWithoutCrop = Mat(IMAGE_HEIGHT, IMAGE_WIDTH, CvType.CV_8UC3)
                                    for (i in 0..(finalCroppedImage.height() -1)) {
                                        for (j in 0..(finalCroppedImage.width() -1)) {
                                            if((finalCroppedImage.get(i, j)[0] == 0.0) && (finalCroppedImage.get(i, j)[1] == 0.0) && (finalCroppedImage.get(i, j)[2] == 0.0)) {
                                                finalBokehImageWithoutCrop.put(i, j, image.get(i, j)[0], image.get(i, j)[1], image.get(i, j)[2])
                                            } else {
                                                finalBokehImageWithoutCrop.put(i, j, finalCroppedImage.get(i, j)[0], finalCroppedImage.get(i, j)[1], finalCroppedImage.get(i, j)[2])
                                            }
                                        }
                                    }

                                    // Imgproc.cvtColor(finalBokehImageWithoutCrop, finalBokehImageWithoutCrop, Imgproc.COLOR_BGR2RGB)
                                    finalBokehImageWithoutCrop = AiHelpers(mContext).restoreSize(finalBokehImageWithoutCrop, REAL_WIDTH, REAL_HEIGHT)
                                    //aiImage = AiHelpers(mContext).removePaddingOfImage(aiImage, this.paddingOffset, isPortrait)
                                    finalBokehImageWithoutCrop = HelperUtilsJava().applyWatermarkToImage(finalBokehImageWithoutCrop)

                                    var saveFileName: String
                                    if(ai_source.equals("image")) {
                                        saveFileName = HelperUtils(mContext).imageColorHighlightDirectory + ai_source + "_" + Date().time.toShort() + ".png"
                                    } else {
                                        saveFileName = HelperUtils(mContext).cameraColorHighlightDirectory + ai_source + "_" + Date().time.toShort() + ".png"
                                    }
                                    Imgcodecs.imwrite(saveFileName, finalBokehImageWithoutCrop)

                                    Toast.makeText(mContext, "Success in running inferenc: ${output[0][0]}", Toast.LENGTH_LONG).show()

                                    val resultList = ArrayList<String>()
                                    resultList.add("finished")
                                    resultList.add(saveFileName)

                                    pendingIntentResult.success(resultList)
                                }
                                .addOnFailureListener {
                                    Log.i("TensorflowInference","Failure in running inference")
                                    Toast.makeText(mContext, "Failure in running inferenc: ${it.printStackTrace()}", Toast.LENGTH_LONG).show()
                                    val resultList = ArrayList<String>()
                                    resultList.add("failure")
                                    resultList.add("null")
                                    pendingIntentResult.success(resultList)
                                }
                    } catch (e: Exception) {
                        val resultList = ArrayList<String>()
                        resultList.add("failure")
                        resultList.add("null")
                        pendingIntentResult.success(resultList)
                        Toast.makeText(mContext, "Looks like image is corrupted or invalid file", Toast.LENGTH_LONG).show()
                    }

                }
                .addOnFailureListener {
                    Log.i("TensorflowInit", "Paint model couldn't de downloaded")
                    Toast.makeText(mContext, "Please make sure the network is available, we need to download dependencies", Toast.LENGTH_LONG).show()
                    val resultList = ArrayList<String>()
                    resultList.add("failure")
                    resultList.add("null")
                    pendingIntentResult.success(resultList)
                }
    }
}