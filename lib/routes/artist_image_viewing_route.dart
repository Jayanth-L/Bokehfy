import 'dart:io';

import 'package:bokehfyapp/providers/artist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistImageViewRoute extends StatefulWidget {
  @override
  _ArtistImageViewRouteState createState() => _ArtistImageViewRouteState();
}

class _ArtistImageViewRouteState extends State<ArtistImageViewRoute> {
  @override
  Widget build(BuildContext context) {
    final artistProviderState = Provider.of<ArtistProviderState>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Ai Image View", style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Container(
          color: Colors.black,
          child: Image.file(File(artistProviderState.getAiImage),),
        ),
      ),
    );
  }
}