import 'package:flutter/material.dart';
import 'package:food_tray/Contants/colors.dart';

import 'TextWidget.dart';

class QACard extends StatelessWidget {
  final String question;
  final String answer;
  FontWeight boldAnswer;

  QACard({this.question, this.answer, this.boldAnswer});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
        left: width * 0.08,
        right: width * 0.08,
      ),
      child: Card(
        color: Color.fromRGBO(255, 255, 255, 1),
        elevation: 0,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(
            width * 0.04,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: this.question,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: blackColor,
                ),
              ),
              TextWidget(
                text: this.answer,
                style: TextStyle(
                  fontWeight: boldAnswer ?? FontWeight.normal,
                  color: blackColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
