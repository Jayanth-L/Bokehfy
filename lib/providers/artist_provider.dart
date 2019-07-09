import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bokehfyapp/commons/platform_channels/platform_channels.dart';
import 'package:provider/provider.dart';

class ArtistProviderState with ChangeNotifier {
  ArtistProviderState();

  String _progress = "";
  String _aiImagePath = "";

  void submitForArtist(String ai_template,String image_path) async {
    _progress = "processing";
    notifyListeners();
    var result = await AiPlatformChannel().sendForArtist(ai_template, image_path);
    _progress = result[0].toString();
    notifyListeners();
    _aiImagePath = result[1].toString();
    // notifyListeners();
  }

  void submitForBokehfy(String image_path, String ai_type, String ai_source) async {
    _progress = "processing";
    notifyListeners();
    var result = await AiPlatformChannel().sendImageForBokehfycation(image_path, ai_type, ai_source);
    _progress = result[0].toString();
    notifyListeners();
    _aiImagePath = result[1].toString();
  }

  void resetProgress() {
    _progress = "";
  }

  String get getProgress => _progress;
  String get getAiImage => _aiImagePath;
}