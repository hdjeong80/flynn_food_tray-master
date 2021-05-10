import 'package:flutter/material.dart';
import 'package:food_tray/Contants/colors.dart';
import 'package:food_tray/Screens/modal/UserModal.dart';
import 'package:food_tray/Screens/subscribe/SubscribeScreen.dart';
import 'package:food_tray/Widgets/PriceCard.dart';
import 'package:food_tray/Widgets/TextWidget.dart';

class PriceScreen extends StatefulWidget {
  UserModal userModal;
  PriceScreen(this.userModal);
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: TextWidget(
          text: 'CMS 가입신청서 작성',
          style: TextStyle(
            color: lightBlackColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: blackColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.08,
              right: width * 0.08,
              top: width * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: '서비스 월 이용료',
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Divider(color: grayColor),
                PriceCard(),
              ],
            ),
          ),
          Divider(
            color: grayColor,
            thickness: 1.5,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubscribeScreen(true,widget.userModal),
                    ),
                  );
                },
                child: TextWidget(
                  text: 'CMS 자동이체',
                  style: TextStyle(
                    color: grayColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubscribeScreen(false,widget.userModal),
                    ),
                  );
                },
                child: TextWidget(
                  text: '가상계좌',
                  style: TextStyle(
                    color: grayColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
