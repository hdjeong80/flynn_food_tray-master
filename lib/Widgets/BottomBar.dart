import 'package:flutter/material.dart';
import 'package:food_tray/Contants/colors.dart';
import 'package:food_tray/Widgets/TextWidget.dart';

class BottomBar extends StatelessWidget {
  final double containerHeight;
  final double textHeight;
  final String text;
  final Function onPressedFunction;
  BottomBar({
    this.containerHeight,
    this.textHeight,
    this.text,
    this.onPressedFunction
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressedFunction,
      child: Container(
        height: containerHeight,
        decoration: BoxDecoration(
          color: greenColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
        ),
        child: Center(
          child: TextWidget(
            text: text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            top: textHeight,
          ),
        ),
      ),
    );
  }
}
