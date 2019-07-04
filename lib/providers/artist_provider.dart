import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bokehfyapp/commons/platform_channels/platform_channels.dart';
import 'package:provider/provider.dart';

class ArtistProviderState with ChangeNotifier {
  ArtistProviderState();

  String _progress = "";

  void submitForArtist(String ai_template,String image_path) async {
    _progress = "processing";
    notifyListeners();
    var result = await AiPlatformChannel().sendForArtist(ai_template, image_path);
    _progress = result.toString();
    notifyListeners();
  }

  void resetProgress() {
    _progress = "";
  }

  String get getProgress => _progress;
}