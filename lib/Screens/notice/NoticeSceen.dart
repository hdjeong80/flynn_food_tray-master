import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:food_tray/Contants/Enums.dart';
import 'package:food_tray/Contants/colors.dart';
import 'package:food_tray/Screens/QA/QAScreen.dart';
import 'package:food_tray/Screens/modal/UserModal.dart';
import 'package:food_tray/Screens/notice/NoticeDetailScreen.dart';
import 'package:food_tray/Screens/price/PriceScreen.dart';
import 'package:food_tray/Widgets/TextWidget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../subscribe/SubscribeScreen.dart';
import 'NoticeModal.dart';

class NoticeScreen extends StatefulWidget {

  UserModal userModal;

  NoticeScreen(this.userModal);
  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  List ls = [];
  String docid = null;

  @override
  Widget build(BuildContext context) {
    print(widget.userModal.Email);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var ok;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: blackColor),
      ),
      drawer: Drawer(
        child:  Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 150,),
              TextWidget(
                text: widget.userModal.Email,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.black,
                ),
                left: 0.0,
                top: 0.0,
                bottom: 0.0,
                right: 0.0,
              ),
              Container(height: 20,),

              FlatButton(
                color: Colors.white,
                onPressed:_restartApp,
                child: TextWidget(
                  text: '로그아웃',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                  left: 0.0,
                  top: 0.0,
                  bottom: 0.0,
                  right: 0.0,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(height, width),
      body: Padding(
        padding: EdgeInsets.only(
          left: width * 0.08,
          right: width * 0.08,
          top: width * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: '공지사항',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: blackColor,
              ),
              left: 0.0,
              top: 0.0,
              bottom: 0.0,
              right: 0.0,
            ),
            TextWidget(
              text: widget.userModal.plceEnum == Place.one ? '흥덕 / 서원 / 세종' : '상당 / 청원 / 충북',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: blackColor,
              ),
              left: 0.0,
            ),
            Divider(color: grayColor),
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("notice")
                    .where("place", isEqualTo: widget.userModal.place.toString())
                    .limit(3)
                    .orderBy("time", descending: true)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
print(snapshot.data.docs.length);
print(widget.userModal.place);

                    if (ls.length == 0) {
                      snapshot.data.docs.forEach((element) {
                        ls.add(NoticeModal(element,widget.userModal));
                        docid = element.id;
                        print(docid);
                      });
                    }
                    // ls = [];
                    return Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) => ls[index],
                      itemCount: ls.length,
                    ));
                  }

                  return Container(
                      height: 100,
                      width: 100,
                      child: ModalProgressHUD(
                          inAsyncCall: true, child: Container()));
                }),
            SizedBox(height: 18),
            GestureDetector(
              onTap: () async {
                DocumentSnapshot ds = await FirebaseFirestore.instance
                    .collection("notice")
                    .doc(docid)
                    .get();
                QuerySnapshot qs = await FirebaseFirestore.instance
                    .collection("notice")
                    .where("place", isEqualTo: widget.userModal.place.toString())
                    .orderBy("time", descending: true)
                    .startAfterDocument(ds)
                    .limit(3)
                    .get();
                if (qs.docs.length == 0)
                  Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "더 이상 공지가 없습니다.",
                      buttons: [
                        DialogButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("확인"),
                          color: Colors.white,
                        )
                      ]).show();
                else {
                  setState(() {
                    qs.docs.forEach((element) {
                      ls.add(NoticeModal(element,widget.userModal));
                      docid = element.id;
                    });
                  });
                }
              },
              child: Container(
                height: height * 0.08,
                color: Color.fromRGBO(246, 246, 246, 1),
                child: Center(
                  child: TextWidget(
                    text: '+ 더보기',
                    style: TextStyle(
                      color: grayColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    top: height * 0.025,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  //
  // Widget noticeCard(String heading, String date) {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => NoticeDetailScreen(this),
  //         ),
  //       );
  //     },
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         TextWidget(
  //           text: heading,
  //           style: TextStyle(
  //             color: blackColor,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 16,
  //           ),
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             TextWidget(
  //               text: date,
  //               style: TextStyle(
  //                 color: grayColor,
  //                 fontWeight: FontWeight.normal,
  //                 fontSize: 16,
  //               ),
  //             ),
  //             Icon(
  //               Icons.arrow_forward_ios,
  //               color: grayColor,
  //             ),
  //           ],
  //         ),
  //         Divider(
  //           color: grayColor,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget bottomBar(
    double height,
    double width,
  ) {
    return Container(
      height: height * 0.10,
      width: double.infinity,
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PriceScreen(widget.userModal),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: greenColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                ),
              ),
              width: width / 2,
              child: TextWidget(
                center: true,
                text: 'CMS 가입신청서 \n작성하기',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QAScreen(widget.userModal),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: grayColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                ),
              ),
              width: width / 2,
              child: TextWidget(
                center: true,
                text: '문의하기 / \n서비스 변경 신청하기',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _restartApp() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    final SharedPreferences prefs = await _prefs;

    print("restarting app");
    if(await prefs.clear())
      await  FirebaseMessaging.instance.subscribeToTopic(widget.userModal.place.toString());

    FlutterRestart.restartApp();
  }
}
