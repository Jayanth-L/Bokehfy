import 'package:bokehfyapp/providers/artist_provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:bokehfyapp/routes/artist_image_viewing_route.dart';

class ProgressAnimation extends StatefulWidget {
  @override
  _ProgressAnimationState createState() => _ProgressAnimationState();
}

class _ProgressAnimationState extends State<ProgressAnimation> {
  @override
  Widget build(BuildContext context) {
    final artistProviderState = Provider.of<ArtistProviderState>(context);

    var shouldOpenImageViewer = false;

    var state = artistProviderState.getProgress == "processing";

    if(state) {
      return Container(
        color: Colors.transparent.withOpacity(0.6),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width/2,
            height: MediaQuery.of(context).size.height/2,
            color: Colors.white,
            child: Center(child: Text("Hello Appam"),),
          ),
        )
      );
    } else {
      print("LoggingOff");
      if(artistProviderState.getProgress == "finished") {
        artistProviderState.resetProgress();
        shouldOpenImageViewer = true;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _openNextPage();
        });
      }
      return Container();
    }
  }

  Future _openNextPage() async {
    while(true) {
      try {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ArtistImageViewRoute()
          )
        );
        break;
      } catch (e, s) {}
    }
  }
}













class ProgressAnimation2 extends StatefulWidget {
  @override
  _ProgressAnimation2State createState() => _ProgressAnimation2State();
}

class _ProgressAnimation2State extends State<ProgressAnimation2> {

  bool successAnimate = false;

  @override
  Widget build(BuildContext context) {

    final artistProviderState = Provider.of<ArtistProviderState>(context);

    var shouldOpenImageViewer = false;

    var state = artistProviderState.getProgress == "processing";

    if(state) {
      successAnimate = true;
      return Container(
        color: Colors.transparent.withOpacity(0.6),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: FlareActor(
            'assets/flare/line_circles.flr',
            alignment: Alignment.center,
            animation: "Loading",
            callback: (_) {
              print("The animation has completed");
            },
          )
        )
      );
    } else {
      
      print("LoggingOff");
      if(artistProviderState.getProgress == "finished") {
        artistProviderState.resetProgress();
        shouldOpenImageViewer = true;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _openNextPage();
        });
      }
      
      return Container();
    } 
  }
  Future _openNextPage() async {
    while(true) {
      try {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ArtistImageViewRoute()
          )
        );
        break;
      } catch (e, s) {}
    }
  }
}