




import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class SubscribeFullScreen extends StatefulWidget {
  String url ;
  SubscribeFullScreen(this.url);

  @override
  _SubscribeFullScreenState createState() => _SubscribeFullScreenState();
}

class _SubscribeFullScreenState extends State<SubscribeFullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  backgroundColor: Colors.white,
  leading: GestureDetector(
    onTap: (){
      Navigator.pop(context);
    },
    child: Icon(Icons.arrow_back_ios,color: Colors.black54,),
  ),
),
      backgroundColor: Colors.white,
body:  Container(
    child: PhotoView(
      backgroundDecoration: BoxDecoration(

        color: Colors.white
      ),
    imageProvider: NetworkImage(widget.url),
    )
    ),
    );
  }
}
