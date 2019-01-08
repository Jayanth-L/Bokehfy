import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view_gallery.dart';

class CameraChromifyImageViewPage extends StatefulWidget {
  @override
  _CameraChromifyImageViewPageState createState() => _CameraChromifyImageViewPageState();
}

class _CameraChromifyImageViewPageState extends State<CameraChromifyImageViewPage> {
  static final platform = MethodChannel("BokehfyImage");
  List bokehImagesList = [];
  var image = <PhotoViewGalleryPageOptions>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var image = <PhotoViewGalleryPageOptions>[];

    return Scaffold(
      backgroundColor: Colors.black,
        body: FutureBuilder(
      future: _getChromifyImages(),
      builder: (BuildContext context, AsyncSnapshot asyncshapshot) {
        var opt = <PhotoViewGalleryPageOptions>[];
        if (bokehImagesList.length > 0) {
          for (var images in bokehImagesList) {
            opt.add(PhotoViewGalleryPageOptions(
                imageProvider: FileImage(File(images))));
          }
          return PhotoViewGallery(
            pageOptions: opt,
          );
        } else {
          return Container(
            child: Center(
              child: Text("You don't have any portrait image, Add one :)")
            ),
          );
        }
      },
    ));
  }

  Future<List> _getChromifyImages() async {
    bokehImagesList =
        await platform.invokeMethod("getChromifyImagesCamera", {"images": "images"});
    return bokehImagesList;
  }
}
