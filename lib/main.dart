import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:food_tray/Screens/splash_screen/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}


class CheckScreenshot extends StatelessWidget {

  var scr= new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: RepaintBoundary(
              key: scr,

            child: GestureDetector(
              onTap: () async {

                  RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
                  var image = await boundary.toImage();
                  var byteData = await image.toByteData(format: ImageByteFormat.png);
                  var pngBytes = byteData.buffer.asUint8List();
                  print(pngBytes);
              },
              child: Center(
                child: ListView(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image.asset('assets/logo.png'),
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image.asset('assets/logo.png'),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image.asset('assets/logo.png'),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ko', 'KO'),
      ],
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: SplashScreen(),
    );
  }
}
