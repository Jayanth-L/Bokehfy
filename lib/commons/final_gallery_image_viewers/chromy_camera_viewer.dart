import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/**
 * author: Jayanrh L
 * email: jayanthl@protonmail.com
 */

class ChromyCameraViewer extends StatefulWidget {
  @override
  _ChromyCameraViewerState createState() => _ChromyCameraViewerState();
}

class _ChromyCameraViewerState extends State<ChromyCameraViewer> {
  static final platform = MethodChannel("CHANNEL_BOKEHFY");
  List bokehImagesList = List<String>();
  var image = <Widget>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var _currentPageIndex = 0;  
    PageController _pageController = PageController(initialPage: _currentPageIndex);  

    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Mono Images"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              var reversedList = [];
              for (var images in bokehImagesList.reversed) {
                reversedList.add(images);
              }
              _shareImageFile(reversedList[_currentPageIndex]);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {

              if(bokehImagesList.length != 0) {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Delete ?"),
                      content: Text("Delete the pic ?"),
                      actions: <Widget>[
                        
                        FlatButton(
                          child: Text("No"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }
                        ),
                        MaterialButton(
                          color: Colors.blueAccent,
                          child: Text("yes", style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            var reversedList = [];
                            for(var images in bokehImagesList.reversed) {
                              reversedList.add(images);
                            }
                            print("Deleting ${reversedList[_currentPageIndex]}");
                            File(reversedList[_currentPageIndex]).delete();
                            setState(() {
                              var setting_state = true;
                              _pageController = PageController(initialPage: _currentPageIndex -1);
                            });
                          },
                        ),
                      ],
                    );
                  }
                );
              }
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
        body: FutureBuilder(
      future: _getChromifyImages(),
      builder: (BuildContext context, AsyncSnapshot asyncshapshot) {
        var opt = <Widget>[];
        bokehImagesList.sort();
        Iterable reversedImagesList = bokehImagesList.reversed;
        if (bokehImagesList.length > 0) {
          for (var images in reversedImagesList) {
            opt.add(Container(child: Image(image: FileImage(File(images)),),));
          }
          return PageView(
            controller: _pageController,
            children: opt,
            onPageChanged: (index) {
              _currentPageIndex = index;
            },
          );
        } else {
          return Container(
            color: Colors.white,
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
    bokehImagesList.sort();
    Iterable reversedImagesList = bokehImagesList.reversed;
    return reversedImagesList.toList();
  }

  Future<String> _shareImageFile(imagepath) async {
    var res = await platform.invokeMethod("shareImageFile", {"imagepath": imagepath});
    return res;
  }
}

