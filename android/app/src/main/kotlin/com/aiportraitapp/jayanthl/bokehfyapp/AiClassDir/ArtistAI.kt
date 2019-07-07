package com.aiportraitapp.jayanthl.bokehfyapp.AiClassDir

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Color
import android.os.Build
import android.util.Log
import android.widget.Toast
import com.google.android.gms.tasks.OnFailureListener
import com.google.firebase.ml.common.modeldownload.FirebaseModelDownloadConditions
import com.google.firebase.ml.common.modeldownload.FirebaseModelManager
import com.google.firebase.ml.common.modeldownload.FirebaseRemoteModel
import com.google.firebase.ml.custom.*
import io.flutter.plugin.common.MethodChannel
import org.opencv.android.Utils
import org.opencv.core.CvType
import org.opencv.core.Mat
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc

class ArtistAI(mContext: Context) {
    var mContext: Context = mContext

    val IMAGE_HEIGHT = 720
    val IMAGE_WIDTH = 720
    val CHANNELS = 3
    var paddingOffset = 0

    lateinit var isPortrait: String

    lateinit var conditions: FirebaseModelDownloadConditions
    lateinit var cloudSourcePaint: FirebaseRemoteModel


    fun aiArtistConvert(imagePath: String, aiTexture: String, pendingIntentResult: MethodChannel.Result) {
        var conditionsBuilder: FirebaseModelDownloadConditions.Builder = FirebaseModelDownloadConditions
                .Builder()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            conditionsBuilder = conditionsBuilder.requireCharging().requireDeviceIdle()
        }

        conditions = conditionsBuilder.build()

        cloudSourcePaint = FirebaseRemoteModel.Builder("${aiTexture.replace(".jpg", "").replace("assets/artist/", "")}_artist")
                .enableModelUpdates(true)
                .setUpdatesDownloadConditions(conditions)
                .build()

        FirebaseModelManager.getInstance().registerRemoteModel(cloudSourcePaint)
        Log.i("TensorflowInit", "Paint Tensorflow model registered successfully")
        FirebaseModelManager.getInstance().downloadRemoteModelIfNeeded(cloudSourcePaint)
                .addOnSuccessListener {
                    Log.i("TensorflowInit", "Paint model downloaded successfully")
                    val options = FirebaseModelOptions.Builder()
                            .setRemoteModelName("${aiTexture.replace(".jpg", "").replace("assets/artist/", "")}_artist")
                            .build()
                    val interpreter = FirebaseModelInterpreter.getInstance(options)

                    val inputOutputOptions = FirebaseModelInputOutputOptions.Builder()
                            .setInputFormat(0, FirebaseModelDataType.FLOAT32, intArrayOf(1, IMAGE_HEIGHT, IMAGE_WIDTH, CHANNELS))
                            .setOutputFormat(0, FirebaseModelDataType.FLOAT32, intArrayOf(1, IMAGE_HEIGHT, IMAGE_WIDTH, CHANNELS))
                            .build()

                    var image = Imgcodecs.imread(imagePath)
                    image = AiHelpers(mContext).resizematrix(image)

                    if(image.width() < image.height()) {
                        this.paddingOffset = image.height() - image.width()
                        image = AiHelpers(mContext).paddImage(image, true)
                        isPortrait = "true"
                    } else {
                        this.paddingOffset = image.width() - image.height()
                        image = AiHelpers(mContext).paddImage(image, false)
                        isPortrait = "false"
                    }


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
                                val output = result.getOutput<Array<Array<Array<FloatArray>>>>(0)

                                // Process image
                                var aiImage = Mat(IMAGE_HEIGHT, IMAGE_WIDTH, CvType.CV_8UC3)

                                for(i in 0..(IMAGE_HEIGHT -1)) {
                                    for(j in 0..(IMAGE_WIDTH -1)) {
                                        aiImage.put(i, j, output[0][i][j][0].toDouble(), output[0][i][j][1].toDouble(), output[0][i][j][2].toDouble())
                                    }
                                }

                                Imgproc.cvtColor(aiImage, aiImage, Imgproc.COLOR_BGR2RGB)
                                aiImage = AiHelpers(mContext).removePaddingOfImage(aiImage, this.paddingOffset, isPortrait)
                                Imgcodecs.imwrite("/sdcard/fin_p.png", aiImage)

                                Toast.makeText(mContext, "Success in running inferenc: ${output[0][0][0][0]}", Toast.LENGTH_LONG).show()

                                pendingIntentResult.success("finished")
                            }
                            .addOnFailureListener {
                                Log.i("TensorflowInference","Failure in running inference")
                                Toast.makeText(mContext, "Failure in running inferenc: ${it.printStackTrace()}", Toast.LENGTH_LONG).show()
                                pendingIntentResult.success("failure")
                            }

                }
                .addOnFailureListener {
                    Log.i("TensorflowInit", "Paint model couldn't de downloaded")
                    Toast.makeText(mContext, "Please make sure the network is available, we need to download dependencies", Toast.LENGTH_LONG).show()
                }
    }
}