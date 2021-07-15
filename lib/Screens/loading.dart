import 'package:flutter/material.dart';
import 'package:food_tray/Contants/colors.dart';

class Loading extends StatefulWidget {
  Widget child;
  static bool isLoading = false;

  Loading({@required this.child});

  static on() {
    isLoading = true;
  }

  static off() {
    isLoading = false;
  }

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    Loading.off();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Visibility(
          visible: Loading.isLoading,
          child: SizedBox.expand(
            child: Container(
              color: Colors.black.withOpacity(.5),
            ),
          ),
        ),
        Visibility(
          visible: Loading.isLoading,
          child: Center(
            child: CircularProgressIndicator(
              // color: greenColor,
            ),
          ),
        ),
      ],
    );
  }
}
