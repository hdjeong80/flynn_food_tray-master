import 'package:flutter/material.dart';
import 'package:food_tray/Contants/colors.dart';
import 'package:food_tray/Screens/auth_screens/SignUpScreen.dart';
import 'package:food_tray/Widgets/BottomBar.dart';
import 'package:food_tray/Widgets/TextWidget.dart';
import 'package:get/get.dart';

import 'LoginInScreen.dart';
import 'package:food_tray/Contants/Enums.dart';

class PlaceScreen extends StatefulWidget {
  @override
  _PlaceScreenState createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  int _selectedPlace = 0;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // bottomNavigationBar: GestureDetector(
        //   onTap:(){
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => LoginInScreen(),
        //       ),
        //     );
        //   } ,
        //   child: BottomBar(
        //
        //     containerHeight: height * 0.10,
        //     textHeight: height * 0.03,
        //     text: '이미 계정이 있습니다',
        //   ),
        // ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextWidget(
                text: '식판스토리앱 \n회원가입',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: blackColor,
                ),
                left: width * 0.08,
                top: height * 0.12,
              ),
            ),
            Center(
              child: TextWidget(
                text: '가입하실 지역을 선택하세요.',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: lightBlackColor,
                ),
                top: height * 0.12,
              ),
            ),
            SizedBox(height: height * 0.05),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedPlace = 1;
                });
              },
              child: Card(
                color: _selectedPlace == 1 ? greenColor : Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(color: greenColor)),
                child: SizedBox(
                  width: Get.width / 1.5,
                  height: Get.width / 8,
                  child: Center(
                    child: Text(
                      '흥덕/서원/세종',
                      style: TextStyle(
                        color: _selectedPlace == 1 ? Colors.white : greenColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedPlace = 2;
                });
              },
              child: Card(
                color: _selectedPlace == 2 ? greenColor : Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(color: greenColor)),
                child: SizedBox(
                  width: Get.width / 1.5,
                  height: Get.width / 8,
                  child: Center(
                    child: Text(
                      '상당/청원/충북',
                      style: TextStyle(
                        color: _selectedPlace == 2 ? Colors.white : greenColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.05),
            AnimatedOpacity(
              opacity: _selectedPlace == 0 ? 0 : 1,
              duration: Duration(milliseconds: 500),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(
                          _selectedPlace == 1 ? Place.one : Place.two),
                    ),
                  );
                },
                icon: Icon(
                  Icons.navigate_next,
                  color: greenColor,
                ),
                iconSize: 50,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // GestureDetector(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => SignUpScreen(Place.one),
                //       ),
                //     );
                //   },
                //   child: Card(
                //     color: greenColor,
                //     child: SizedBox(
                //       width: Get.width / 3,
                //       height: Get.width / 3,
                //       child: Center(
                //         child: Text(
                //           '흥덕/서원/세종',
                //           style: TextStyle(
                //             color: Colors.black,
                //             fontSize: 14,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => SignUpScreen(Place.two),
                //       ),
                //     );
                //   },
                //   child: Card(
                //     color: greenColor,
                //     child: SizedBox(
                //       width: Get.width / 3,
                //       height: Get.width / 3,
                //       child: Center(
                //         child: Text(
                //           '상당/청원/충북',
                //           style: TextStyle(
                //             color: Colors.black,
                //             fontSize: 14,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
