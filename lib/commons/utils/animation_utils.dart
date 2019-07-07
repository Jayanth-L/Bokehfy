import 'package:bokehfyapp/providers/artist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class ProgressAnimation extends StatefulWidget {
  @override
  _ProgressAnimationState createState() => _ProgressAnimationState();
}

class _ProgressAnimationState extends State<ProgressAnimation> {
  @override
  Widget build(BuildContext context) {
    final artistProviderState = Provider.of<ArtistProviderState>(context);

    var shouldOpenImageViewer = false;


    if(artistProviderState.getProgress == "processing") {
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
            builder: (BuildContext context) => Temp()
          )
        );
        break;
      } catch (e, s) {}
    }
  }
}
class Temp extends StatefulWidget {
  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}