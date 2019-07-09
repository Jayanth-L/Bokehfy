import 'dart:async';

import 'package:flutter/services.dart';

class AiPlatformChannel {

  final platform = MethodChannel("CHANNEL_BOKEHFY");

  Future sendForArtist(String ai_template, String image_path) async {
    var result = await platform.invokeMethod("aiArtist", {"ai_template": ai_template, "image_path": image_path});
    //var result = "finished";
    //await Future.delayed(Duration(seconds: 2));
    return result;
  }

  Future sendImageForBokehfycation(String image_path, String ai_type, String ai_source) async {
    var result = await platform.invokeMethod("aiBokehfy", {"image_path": image_path, "ai_type": ai_type, "ai_source": ai_source});
    return result;
  }


  /// ************************************************************************************** */

  // Get final Images
  Future getFinalImagesList(String source) async {
    var result = await platform.invokeMethod("finalImages", {"source": source});
    return result;
  }
}