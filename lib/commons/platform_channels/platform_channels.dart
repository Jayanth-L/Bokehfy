import 'dart:async';

import 'package:flutter/services.dart';

class AiPlatformChannel {

  final platform = MethodChannel("aiPlatformChannel");

  Future sendForArtist(String ai_template, String image_path) async {
    // var result = await platform.invokeMethod("aiArtist", {"ai_template": ai_template, "image_path": image_path});
    var result = "finished";
    await Future.delayed(Duration(seconds: 2));
    return result;
  }
}