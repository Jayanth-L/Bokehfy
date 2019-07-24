import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/**
 * author: Jayanrh L
 * email: jayanthl@protonmail.com
 */

class AllChromyViewer extends StatefulWidget {
  @override
  _AllChromyViewerState createState() =>
      _AllChromyViewerState();
}

class _AllChromyViewerState extends State<AllChromyViewer> {
  static final platform = MethodChannel("CHANNEL_BOKEHFY");
  List bokehImagesList = List<String>();

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
        title: Text("Chromy Images"),
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

              if (bokehImagesList.length != 0) {
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
                          child: Text("yes", style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            Navigator.of(context).pop();
                            var reversedList = [];
                            for (var images in bokehImagesList.reversed) {
                              reversedList.add(images);
                            }
                            print("Deleting ${reversedList[_currentPageIndex]}");
                            File(reversedList[_currentPageIndex]).delete();
                            setState(() {
                              var setting_state  = true;
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
        future: _getAllImagesChromify(),
        builder: (BuildContext context, AsyncSnapshot asyncshapshot) {
          var opt = <Widget>[];
          //print(bokehImagesList);
          bokehImagesList.sort();
          var reversedBokehImagesList = bokehImagesList.reversed;
          if (bokehImagesList.length > 0) {
            for (var images in reversedBokehImagesList) {
              opt.add(Container(
                child: Image(image: FileImage(File(images)),),
              ));
            }
            return PageView(
              controller: _pageController,
              children: opt,
              onPageChanged: (index) {
                print("page changedto $index");
                _currentPageIndex = index;
              },
            );
          } else {
            return Container(
              color: Colors.white,
              child: Center(
                  child: Text("You don't have any portrait image, Add one :)")),
            );
          }
        },
      ),
    );
  }

  Future<List> _getAllImagesChromify() async {

    bokehImagesList = await platform.invokeMethod("getAllChromifyImages", {"images": "images"});
    bokehImagesList.sort();
    var reversedBokehImagesList = bokehImagesList.reversed;
    return reversedBokehImagesList.toList();
  }

  Future<String> _shareImageFile(imagepath) async {
    var res = await platform.invokeMethod("shareImageFile", {"imagepath": imagepath});
    return res;
  }
}