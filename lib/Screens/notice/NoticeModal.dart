

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_tray/Screens/modal/UserModal.dart';

import '../../Contants/colors.dart';
import '../../Widgets/TextWidget.dart';
import 'NoticeDetailScreen.dart';
import 'package:intl/intl.dart';

class NoticeModal extends StatelessWidget {
  NoticeModal(this.queryDocumentSnapshot,this.userModal);
  final QueryDocumentSnapshot queryDocumentSnapshot;
  final UserModal userModal;

  String notice ;
  String date;
  String text;
  String url;

  init(){
  notice=  queryDocumentSnapshot.data()['notice'];
  url=  queryDocumentSnapshot.data()['url']??"";
  
  DateTime dt =(queryDocumentSnapshot.data()['date']??Timestamp.fromDate(DateTime.now()) ).toDate() ;
  text =  queryDocumentSnapshot.data()['text']??"첨부 된 텍스트 없음  ";
  date = DateFormat("yyyy.MM.dd").format(dt);
  }
  @override
  Widget build(BuildContext context) {
    init();
    return noticeCard(notice,date,context);
  }
  Widget noticeCard(String heading, String date,context) {
    return GestureDetector(

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoticeDetailScreen(this,userModal),
          ),
        );
      },
      child: Row(
        children: [
          url!=null?
          Container(
              height: 60,
              width: 60,
              child: Image.network(url)):Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: heading,
                style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: date,
                    style: TextStyle(
                      color: grayColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: grayColor,
                  ),
                ],
              ),
              Divider(
                color: grayColor,
              ),
            ],
          ),
        ],
      ),
    );
  }


}
