import 'dart:math';
import 'package:bokehfyapp/providers/artist_provider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bokehfyapp/routes/artist_template_view_route.dart';
import 'package:provider/provider.dart';
import 'commons/artist_images_list.dart';
import 'commons/utils/animation_utils.dart';
import 'package:flutter/scheduler.dart';

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
        theme: ThemeData(primarySwatch: Colors.blue),
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
                        onPressed: () {},
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
                        icon: Icon(Icons.donut_large, size: 24.0),
                        onPressed: () {},
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
                      Text("5+ textures!", style: TextStyle(color: Colors.blueAccent),)
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
                      Text("Portrait Mode", style: TextStyle(
                        fontSize: 30.0,
                        letterSpacing: 1.0
                      ),),
                      IconButton(
                        icon: Icon(Icons.donut_large, size: 24.0),
                        onPressed: () {},
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

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CarouselSlider(
                    height: 200.0,
                    aspectRatio: 16/9,
                    viewportFraction: 0.8,
                    enableInfiniteScroll: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 1),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    items: [1, 2].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                        
                            width: MediaQuery.of(context).size.width / 2 + 60,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.amber
                            ),
                            child: Text("position"),
                          );
                        },
                      );
                    }).toList()
                  ),
                ),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
                Text("Appam", style: TextStyle(fontSize: 30.0),),
              ],
            ),
          ),
          Consumer<ArtistProviderState>(
            builder: (context, data, _) {
              print("Data" + data.toString());

              return  Center(child: ProgressAnimation());
            },
          )
        ],
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