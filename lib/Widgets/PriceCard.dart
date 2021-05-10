import 'package:flutter/material.dart';
import 'package:food_tray/Contants/colors.dart';
import 'package:food_tray/Widgets/TextWidget.dart';

class PriceCard extends StatefulWidget {
  @override
  _PriceCardState createState() => _PriceCardState();
}

class _PriceCardState extends State<PriceCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: ' · 부모님 부담 : 월 10,000원',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: blackColor,
              ),
            ),
            TextWidget(
              text: '(원내 다자녀 할인 10% 9,000원)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: blackColor,
                fontSize: 12,
              ),
            ),
            TextWidget(
              text: ' · 식판, 수저, 포크',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: blackColor,
              ),
            ),
            TextWidget(
              text: '*이용료에 간식그릇 비용은 포함되지 않습니다.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: blackColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
