import 'dart:math';
import 'package:bokehfyapp/commons/final_gallery_image_viewers/ai_artist_viewer.dart';
import 'package:bokehfyapp/commons/final_gallery_image_viewers/all_chromy_viewer.dart';
import 'package:bokehfyapp/commons/final_gallery_image_viewers/chromy_camera_viewer.dart';
import 'package:bokehfyapp/commons/final_gallery_image_viewers/chromy_image_viewer.dart';
import 'package:bokehfyapp/commons/platform_channels/image_utils.dart';
import 'package:bokehfyapp/commons/platform_channels/platform_channels.dart';
import 'package:bokehfyapp/commons/utils/misc_functions.dart';
import 'package:bokehfyapp/providers/artist_provider.dart';
import 'package:bokehfyapp/routes/privacy_policy_route.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bokehfyapp/routes/artist_template_view_route.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'commons/artist_images_list.dart';
import 'commons/utils/animation_utils.dart';
import 'package:bokehfyapp/commons/display_images_list_data.dart';
import 'commons/final_gallery_image_viewers/portrait_image_viewer.dart';
import 'commons/final_gallery_image_viewers/portrait_camera_viewer.dart';
import 'commons/final_gallery_image_viewers/all_portrait_viewer.dart';
import 'miscs/strings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (BuildContext context) => ArtistProviderState(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Raleway"),
        darkTheme: ThemeData.light(),
        home: MainPage()
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  var numberOfPaintImages = artistImagesList.length;
  var currentPage;
  var artistPageAfterChanged = 10;

  // misc
  var bokehfyImagePosition = 0;
  var chromifyImagePosition = 0;

  @override
  void initState() {
    
    currentPage = numberOfPaintImages.toDouble() - 1.0;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    PageController controller = PageController(initialPage: 10);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

    final artistAppState = Provider.of<ArtistProviderState>(context);


    

    return Scaffold(
      // backgroundColor: Color(0xFF2d3447),
      // backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, top: 30.0, bottom: 8.0
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          size: 30.0,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) => MiscFunctions().openDrawer(context)
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Bokehfy", style: TextStyle(
                        fontSize: 46.0,
                        letterSpacing: 1.0
                      ),),
                      IconButton(
                        icon: Icon(Icons.info_outline, size: 24.0),
                        onPressed: () {
                          MiscFunctions().showDocs(context, "Bokehfy", bokehfy_explain);
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFff6e6e),
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 22.0, vertical: 6.0
                            ),
                            child: Text("Paint Artist", style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.0,),
                      Text("${bokehfyListImages.length}+ textures!", style: TextStyle(color: Colors.blueAccent),)
                    ],
                  ),
                ),
                Container(
                  height: 30,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.blueAccent
                  ),
                  child: Center(child: Text("New Feature!!!", style: TextStyle(color: Colors.white),)),
                ),

                GestureDetector(
                  onTap: () {
                    print("tapped: $currentPage");
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ArtistTemplateViewoute(currentImage: artistPageAfterChanged,)
                      )
                    );
                  } ,
                  child: Stack(
                    children: <Widget>[
                      CardScrollWidget(currentPage),
                      Positioned.fill(
                        child: PageView.builder(
                          onPageChanged: (page) {
                            print("Page changed: $page");
                            artistPageAfterChanged = page;
                          },
                          itemCount: numberOfPaintImages,
                          controller: controller,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return Container();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Ai Artist Gallery", style: TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 1.0
                      ),),
                      IconButton(
                        icon: Icon(Icons.info_outline, size: 24.0),
                        onPressed: () {
                          MiscFunctions().showDocs(context, "Ai Artist", ai_artist_explain);
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => AiArtistViewer()
                          )
                        );
                      },
                      child: Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          gradient: LinearGradient(
                            colors: [
                              Colors.green, Colors.blue
                            ]
                          ),
                        ),
                        child: Center(
                          child: Text("Ai Paint Gallery", style: TextStyle(fontSize: 20.0, color: Colors.white),),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Portrait Mode", style: TextStyle(
                        fontSize: 30.0,
                        letterSpacing: 1.0
                      ),),
                      IconButton(
                        icon: Icon(Icons.info_outline, size: 24.0),
                        onPressed: () {
                          MiscFunctions().showDocs(context, "Portrait Mode", bokehfy_explain);
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 22.0, vertical: 6.0
                            ),
                            child: Text("Bokeh pics", style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.0,),
                      Text("25+ Stories", style: TextStyle(color: Colors.blueAccent),)
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
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
                                          color: Colors.transparent
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Select source", style: TextStyle(fontSize: 20.0, color: Colors.white)),
                                              Padding(
                                                padding: const EdgeInsets.all(30.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    //Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    // open the dialog for image picking
                                                    ImageUtils().getGalleryImage().then((gotImage) {
                                                      print("ImageUtilsGet: " + gotImage.toString());

                                                      if(gotImage != null) {
                                                        artistAppState.submitForBokehfy(gotImage.path, "bokehfy", "gallery");
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
                                                  //Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  // open the dialog for image picking

                                                  ImageUtils().getCameraImage().then((gotImage) {
                                                      print("ImageUtilsGet: " + gotImage.toString());

                                                     if(gotImage != null) {
                                                        artistAppState.submitForBokehfy(gotImage.path, "bokehfy", "camera");
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
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: () {
                      print("Tapped on current: ${bokehfyImagePosition}");
                      var nextRoute;
                      if(bokehfyImagePosition == 0) {
                        nextRoute = PortraitImageViewPage();
                      } else if(bokehfyImagePosition == 1) {
                        nextRoute = PortraitCameraViewPage();
                      } else {
                        nextRoute = AllPortraitViewer();
                      }
                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => nextRoute
                          )
                        );
                    },
                    child: CarouselSlider(
                      height: 200.0,
                      aspectRatio: 16/9,
                      autoPlayAnimationDuration: Duration(milliseconds: 500),
                      viewportFraction: 0.8,
                      enableInfiniteScroll: false,
                      autoPlay: false,
                      autoPlayInterval: Duration(seconds: 4),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      onPageChanged: (_) {
                        print("changed image: ${_}");
                        bokehfyImagePosition = _;
                      },
                      items: [0, 1, 2].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Stack(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width / 2 + 60,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    image: DecorationImage(image: ExactAssetImage(bokehfyListImages[i]), fit: BoxFit.fill)
                                  )
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2 + 60,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    gradient: LinearGradient(
                                      colors: [Colors.transparent, Colors.black45],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter
                                    )
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12.0, bottom: 12.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(bokehfyListImagesInfo[i], style: TextStyle(color: Colors.white70),)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      }).toList()
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Mono Color", style: TextStyle(
                        fontSize: 30.0,
                        letterSpacing: 1.0
                      ),),
                      IconButton(
                        icon: Icon(Icons.info_outline, size: 24.0),
                        onPressed: () {
                          MiscFunctions().showDocs(context, "Mono Color", monochrome_background_explain);
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 22.0, vertical: 6.0
                            ),
                            child: Text("Chromy pics", style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.0,),
                      Text("25+ Stories", style: TextStyle(color: Colors.blueAccent),)
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
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
                                          color: Colors.transparent
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Select source", style: TextStyle(fontSize: 20.0, color: Colors.white)),
                                              Padding(
                                                padding: const EdgeInsets.all(30.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    //Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    // open the dialog for image picking
                                                    ImageUtils().getGalleryImage().then((gotImage) {
                                                      print("ImageUtilsGet: " + gotImage.toString());

                                                      if(gotImage != null) {
                                                        artistAppState.submitForBokehfy(gotImage.path, "chromy", "gallery");
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
                                                  //Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  // open the dialog for image picking

                                                  ImageUtils().getCameraImage().then((gotImage) {
                                                      print("ImageUtilsGet: " + gotImage.toString());

                                                      if(gotImage != null) {
                                                        artistAppState.submitForBokehfy(gotImage.path, "chromy", "camera");
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
                              colors: [Colors.red, Colors.amber],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular((30.0)))
                          ),
                          child: Center(child: Text("Use", style: TextStyle(color: Colors.white),)),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: () {
                       print("Tapped on current: ${bokehfyImagePosition}");
                        var nextRoute;
                        if(chromifyImagePosition == 0) {
                          nextRoute = ChromyImageViewer();
                        } else if(chromifyImagePosition == 1) {
                          nextRoute = ChromyCameraViewer();
                        } else {
                          nextRoute = AllChromyViewer();
                        }
                        Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => nextRoute
                            )
                          );
                    },
                    child: CarouselSlider(
                      onPageChanged: (_) {
                        chromifyImagePosition = _;
                      },
                      height: 200.0,
                      aspectRatio: 16/9,
                      viewportFraction: 0.8,
                      enableInfiniteScroll: false,
                      autoPlay: false,
                      autoPlayInterval: Duration(seconds: 4),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      items: [0, 1, 2].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Stack(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width / 2 + 60,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    image: DecorationImage(image: ExactAssetImage(chromyListImages[i]), fit: BoxFit.fill)
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2 + 60,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    gradient: LinearGradient(
                                      colors: [Colors.transparent, Colors.black45],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter
                                    )
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12.0, bottom: 12.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(chromyListImagesInfo[i], style: TextStyle(color: Colors.white70),)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      }).toList()
                    ),
                  ),
                ),
              ],
            ),
          ),
          Consumer<ArtistProviderState>(
            builder: (context, data, _) {
              print("Data" + data.toString());

              return  Center(child: ProgressAnimation2());
            },
          )
        ],
      ),
    );
  }

  Widget _renderArtistImageListView() {
    return Container(
      height: 150,
      child: ListView.builder(
        itemCount: 5,
        padding: EdgeInsets.only(left: 16.0),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => _renderItems(context, index),
      ),
    );
  }

  Widget _renderItems(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        margin: EdgeInsets.only(right: 20.0),
        width: 150,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
              image: AssetImage("assets/artist/paint.jpg"),
              fit: BoxFit.cover
            )
          ),
          height: 150,
        )
      ),
    );
  }
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectratio = cardAspectRatio * 1.19;

class CardScrollWidget extends StatelessWidget {

  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;

  var numberOfPaintImages = artistImagesList.length;
  CardScrollWidget(this.currentPage);
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widgetAspectratio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          var width = constraints.maxWidth;
          var height = constraints.maxHeight;

          var safeWidth = width - 2 * padding;
          var safeHeight = height - 2 * padding;

          var heightOfPrimaryCard = safeHeight;
          var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

          var primaryCardLeft = safeWidth - widthOfPrimaryCard;
          var horizontalInset = primaryCardLeft / 2;


          List<Widget> cardList = List();

          for (var i=0; i < numberOfPaintImages;  i++) {
            var delta = i - currentPage;
            bool isOnRight = delta > 0;

            var start = padding + max(primaryCardLeft - horizontalInset * -delta * (isOnRight ? 15 : 1), 0.0);
            
            var image;
            if(i%2 == 0) {
              image = DecorationImage(image: ExactAssetImage("assets/artist/paint.jpg"), fit: BoxFit.cover);
            } else {
              image = DecorationImage(image: ExactAssetImage("assets/artist/notre.jpg"), fit: BoxFit.cover);
            }

            var cardItem = Positioned.directional(
              top: padding + verticalInset * max(-delta, 0.0),
              bottom: padding * verticalInset * max(-delta, 0.0),
              start: start,
              textDirection:  TextDirection.rtl,
              child: Hero(
                tag: "artist_$i",
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          image: DecorationImage(
                            image: ExactAssetImage(artistImagesList[i]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black54],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            cardList.add(cardItem); 
          }

          return Stack(
            children: cardList,
          );
        },
      ),
    );
  }
}