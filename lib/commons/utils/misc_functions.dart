import 'package:bokehfyapp/routes/privacy_policy_route.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MiscFunctions {
  Widget showDocs(BuildContext context, title, text) {
    showDialog(
      context: (context),
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontSize: 20.0),),
          content: Text(text),
        );
      }
    );
  }

  Widget openDrawer(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.home, color: Colors.green,),
          title: Text("About", style: TextStyle(fontWeight: FontWeight.bold),),
          onTap: () {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  title: Text("Magically convert your pics to Portrait pics!", style: TextStyle(fontSize: 17.0),),
                  content: Text("Let the AI convert your pic to bokeh images :)"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Wow!"),
                      onPressed: () => Navigator.of(context).pop()
                    ),
                    FlatButton(
                      child: Text("Good"),
                      onPressed: () => Navigator.of(context).pop()
                    )
                  ],
                );
              }
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.security, color: Colors.orange,),
          title: Text("Privacy Policy", style: TextStyle(fontWeight: FontWeight.bold),),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => PrivacyPolicyPage()
              )
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.share, color: Colors.blue,),
          title: Text("Share App", style: TextStyle(fontWeight: FontWeight.bold),),
          onTap: () {
            Navigator.of(context).pop();
            Share.share("Have your ever wondered having a dual camera on your phone and taking Portrait Mode Pictures ?\nIf so then you are at the right Place, this app helps you with that having only a Single Camera, Yes single Camera, You don't need to have a dual camera setup\n\nhttps://play.google.com/store/apps/details?id=com.aiportraitapp.jayanthl.bokehfyapp");
            // Old Share Share.share("Checkout the AI Powered Bokeh converter app");
            // TODO:// Implement share app.
          },
        ),
        ListTile(
          leading: Icon(Icons.thumb_up, color: Colors.deepPurple),
          title: Text("Rate us :)", style: TextStyle(fontWeight: FontWeight.bold),),
          onTap: () {
            Navigator.of(context).pop();
            _launchUrl("market://details?id=com.aiportraitapp.jayanthl.bokehfyapp");
          },
        )
      ],
    );
  }

   void _launchUrl(url) async {
    try {
      if(await canLaunch(url)) {
        await launch(url);
      }
    } catch(exception, stacktrace) {
      print(exception);
      print(stacktrace);
    }
}

}