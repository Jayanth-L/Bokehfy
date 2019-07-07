import 'dart:io';

import 'package:bokehfyapp/commons/utils/animation_utils.dart';
import 'package:flutter/material.dart';
import 'package:bokehfyapp/commons/artist_images_list.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math.dart' as vectormath;
import 'package:bokehfyapp/commons/platform_channels/image_utils.dart';
import 'package:bokehfyapp/providers/artist_provider.dart';

class ArtistTemplateViewoute extends StatefulWidget {

  var currentImage;
  ArtistTemplateViewoute({@required this.currentImage});

  @override
  _ArtistTemplateViewouteState createState() => _ArtistTemplateViewouteState();
}

class _ArtistTemplateViewouteState extends State<ArtistTemplateViewoute> {

  @override
  Widget build(BuildContext context) {
    final artistAppState = Provider.of<ArtistProviderState>(context);
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Hero(
              tag: "artist_${widget.currentImage}",
              child: Stack(
                children: <Widget>[
                  Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    image: DecorationImage(
                      image: ExactAssetImage(artistImagesList[widget.currentImage]),
                      fit: BoxFit.cover
                    ),
                  ),
                ),
                Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black87],
                  begin: Alignment.center,
                  end: Alignment.bottomCenter
                )
              ),
            ),
                ],
              ),
            ),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, bottom: 10.0),
                      child: Text(artistImageName[widget.currentImage], style: TextStyle(color: Colors.white54, fontSize: 25.0,)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, bottom: 30.0),
                      child: Text(artistImageDescription[widget.currentImage], style: TextStyle(color: Colors.white54)),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 30.0, bottom: 30.0),
                  child: GestureDetector(
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (context, animation1, animation2) {},
                        barrierDismissible: true,
                        barrierColor: Colors.black.withOpacity(0.4),
                        barrierLabel: "",
                        transitionBuilder: (context, animation1, animation2, child) {
                          return Transform.scale(
                            scale: animation1.value,
                            child: Opacity(
                              opacity: animation1.value,
                              child: Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 0.0,
                                backgroundColor: Colors.transparent,
                                child: SafeArea(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.white
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Select source", style: TextStyle(fontSize: 20.0)),
                                          Padding(
                                            padding: const EdgeInsets.all(30.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                                // open the dialog for image picking
                                                ImageUtils().getGalleryImage().then((got_image) {
                                                  print("ImageUtilsGet: " + got_image.toString());

                                                  // here subit for the artist ai
                                                  if(got_image != null) {
                                                    artistAppState.submitForArtist(artistImagesList[widget.currentImage], got_image.path.toString());
                                                  }
                                                }); 
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context).size.width / 2,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [Colors.blue, Colors.green],
                                                  ),
                                                  borderRadius: BorderRadius.circular(30.0)
                                                ),
                                                child: Center(child: Icon(Icons.image_aspect_ratio, color: Colors.white,))
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              // open the dialog for image picking

                                              ImageUtils().getCameraImage().then((got_image) {
                                                  print("ImageUtilsGet: " + got_image.toString());

                                                  if(got_image != null) {
                                                    artistAppState.submitForArtist(artistImagesList[widget.currentImage], got_image.path.toString());
                                                  }
                                              });
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context).size.width / 2,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [Colors.blue, Colors.green],
                                                ),
                                                borderRadius: BorderRadius.circular(30.0)
                                              ),
                                              child: Center(child: Icon(Icons.camera, color: Colors.white,))
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    width: MediaQuery.of(context).size.width - 100,
                                    height: MediaQuery.of(context).size.height - 500,
                                  ),
                                ),
                              )
                            ),
                          );
                        },
                        transitionDuration: Duration(milliseconds: 150)
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.green],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular((30.0)))
                      ),
                      child: Center(child: Text("Use", style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}