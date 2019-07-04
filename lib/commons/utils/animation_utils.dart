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

    artistProviderState.addListener(() {});

    var shouldOpenImageViewer = false;

    SchedulerBinding.instance.scheduleFrameCallback((_) {
      shouldOpenImageViewer = false;
      if(shouldOpenImageViewer) {
          Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Temp()
          )
        );
      }
    });

    if(artistProviderState.getProgress == "processing") {
      return Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(child: Text("Hello appam",),),
      );
    } else {
      if(artistProviderState.getProgress == "finished") {
        artistProviderState.resetProgress();
        shouldOpenImageViewer = true;
      }
      return Container();
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