package com.aiportraitapp.jayanthl.bokehfyapp.AiClassDir

import android.content.Context
import android.graphics.Bitmap
import android.util.Log
import org.opencv.core.CvType
import org.opencv.core.Mat
import org.opencv.core.Size
import org.opencv.imgproc.Imgproc
import java.util.Collections.max
import kotlin.math.max

class AiHelpers(mContext: Context) {
    var mContext: Context = mContext
    val RESIZE_SIZE = 720



    fun resizematrix(image: Mat): Mat {
        val width = image.width()
        val height = image.height()

        /*val resizeRatio = 1.0 * RESIZE_SIZE / max(height, width)
        val targetSizeheight = (resizeRatio * height).toInt()
        val targetSizeWidth = (resizeRatio * width).toInt()*/
        val size = Size(RESIZE_SIZE.toDouble(), RESIZE_SIZE.toDouble())
        Imgproc.resize(image, image, size)
        return image
    }

    fun restoreSize(image: Mat, orig_width: Int, orig_height: Int): Mat {
        val size = Size(orig_width.toDouble(), orig_height.toDouble())
        Imgproc.resize(image, image, size)
        return image
    }

    fun paddImage(image: Mat, isPortrait: Boolean): Mat {
        val paddedImage = Mat(RESIZE_SIZE, RESIZE_SIZE, CvType.CV_8UC3)
        for (i in 0..(RESIZE_SIZE -1)) {
            for (j in 0..(RESIZE_SIZE -1)) {
                if(isPortrait) {
                    if(j >= image.width()) {
                        paddedImage.put(i, j, 0.0, 0.0, 0.0)
                    } else {
                        paddedImage.put(i, j, image.get(i, j)[0], image.get(i, j)[1], image.get(i, j)[2])
                    }
                } else {
                    if(i >= image.height()) {
                        paddedImage.put(i, j, 0.0, 0.0, 0.0)
                    } else {
                        paddedImage.put(i, j, image.get(i, j)[0], image.get(i, j)[1], image.get(i, j)[2])
                    }
                }
            }
        }
        return paddedImage
    }

    fun removePaddingOfImage(image: Mat, offset: Int, isPotrait: String): Mat {
        if(isPotrait == "true") {
            Log.i("PaddingOffset", "init 1")
            val unpaddedImage = Mat(RESIZE_SIZE, RESIZE_SIZE - offset, CvType.CV_8UC3)
            for (i in 0..(RESIZE_SIZE -1)) {
                for (j in 0..(RESIZE_SIZE - offset -1)) {
                    unpaddedImage.put(i, j, image.get(i, j)[0], image.get(i, j)[1], image.get(i, j)[2])
                }
            }
            return unpaddedImage
        } else {
            Log.i("PaddingOffset", "init 2")
            val unpaddedImage = Mat(RESIZE_SIZE - offset, RESIZE_SIZE, CvType.CV_8UC3)
            for (i in 0..(RESIZE_SIZE -offset -1)) {
                for (j in 0..(RESIZE_SIZE -1)) {
                    unpaddedImage.put(i, j, image.get(i, j)[0], image.get(i, j)[1], image.get(i, j)[2])
                }
            }
            return unpaddedImage
        }
    }
}