import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final double left;
  final double right;
  final double bottom;
  final double top;
  final TextStyle style;
  final String text;
  final bool center;

  TextWidget({
    this.bottom = 8.0,
    this.left = 8.0,
    this.right = 8.0,
    this.top = 8.0,
    this.style,
    this.text,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: left,
            right: right,
            top: top,
            bottom: bottom,
          ),
          child: Text(
            text,
            style: style,
            textAlign: center ? TextAlign.center : TextAlign.left,
          ),
        ),
      ],
    );
  }
}
