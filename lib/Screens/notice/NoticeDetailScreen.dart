import 'package:flutter/material.dart';
import 'package:food_tray/Contants/colors.dart';
import 'package:food_tray/Screens/modal/UserModal.dart';
import 'package:food_tray/Screens/price/PriceScreen.dart';
import 'package:food_tray/Widgets/TextWidget.dart';

import 'NoticeModal.dart';

class NoticeDetailScreen extends StatefulWidget {
  NoticeModal _Noticemodal;
  UserModal userModal;

  NoticeDetailScreen(this._Noticemodal,this.userModal);
  @override
  _NoticeDetailScreenState createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: TextWidget(
          text: '공지사항',
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
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: width * 0.08,
          right: width * 0.08,
          top: width * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PriceScreen(widget.userModal),
                  ),
                );
              },
              child: TextWidget(
                text: widget._Noticemodal.notice,
                style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            TextWidget(
              text: widget._Noticemodal.date,
              style: TextStyle(
                color: grayColor,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
            TextWidget(
              text:
              widget._Noticemodal.text,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
