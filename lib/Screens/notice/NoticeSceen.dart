import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:food_tray/Contants/Enums.dart';
import 'package:food_tray/Contants/colors.dart';
import 'package:food_tray/Screens/QA/QAScreen.dart';
import 'package:food_tray/Screens/loading.dart';
import 'package:food_tray/Screens/modal/UserModal.dart';
import 'package:food_tray/Screens/notice/NoticeDetailScreen.dart';
import 'package:food_tray/Screens/price/PriceScreen.dart';
import 'package:food_tray/Widgets/TextWidget.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_tray/Screens/see_my_subscriptions/my_subscriptions.dart';
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
  int _selectedPlace = 0;

  @override
  Widget build(BuildContext context) {
    print(widget.userModal.Email);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var ok;
    return Loading(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: blackColor),
          actions: [
            PopupMenuButton(
              onSelected: (r){
                print(r);
                if(r=='1'){
                  Get.dialog(
                    AlertDialog(
                      title: Text('확인'),
                      content: Text('가입하신 지역을 정말 변경하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            '취소',
                            style: TextStyle(color: greenColor),
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            Get.back();
                            Get.dialog(StatefulBuilder(
                              builder: (dialogContext, dialogSetState) =>
                                  Loading(
                                    child: AlertDialog(
                                      title: Text('가입 지역 변경'),
                                      content: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: height * 0.04),
                                            InkWell(
                                              onTap: () {
                                                dialogSetState(() {
                                                  _selectedPlace = 1;
                                                });
                                              },
                                              child: Card(
                                                color: _selectedPlace == 1
                                                    ? greenColor
                                                    : Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(100),
                                                    side: BorderSide(
                                                        color: greenColor)),
                                                child: SizedBox(
                                                  width: Get.width / 1.5,
                                                  height: Get.width / 8,
                                                  child: Center(
                                                    child: Text(
                                                      '흥덕/서원/세종',
                                                      style: TextStyle(
                                                        color: _selectedPlace == 1
                                                            ? Colors.white
                                                            : greenColor,
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
                                                dialogSetState(() {
                                                  _selectedPlace = 2;
                                                });
                                              },
                                              child: Card(
                                                color: _selectedPlace == 2
                                                    ? greenColor
                                                    : Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(100),
                                                    side: BorderSide(
                                                        color: greenColor)),
                                                child: SizedBox(
                                                  width: Get.width / 1.5,
                                                  height: Get.width / 8,
                                                  child: Center(
                                                    child: Text(
                                                      '상당/청원/충북',
                                                      style: TextStyle(
                                                        color: _selectedPlace == 2
                                                            ? Colors.white
                                                            : greenColor,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: height * 0.04),
                                            AnimatedOpacity(
                                              opacity: _selectedPlace == 0 ? 0 : 1,
                                              duration: Duration(milliseconds: 500),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      _selectedPlace = 0;
                                                      Get.back();
                                                    },
                                                    child: Text(
                                                      '취소',
                                                      style: TextStyle(
                                                        color: greenColor,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      String _newPlace =
                                                      _selectedPlace == 1
                                                          ? '1'
                                                          : '2';
                                                      dialogSetState(() {
                                                        Loading.isLoading = true;
                                                      });
                                                      _selectedPlace = 0;

                                                      QuerySnapshot ds = null;
                                                      ds = await FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .where('Email',
                                                          isEqualTo: widget
                                                              .userModal.Email)
                                                          .get();

                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(ds.docs.first.id)
                                                          .update({
                                                        'place': _newPlace,
                                                      });

                                                      widget.userModal.place =
                                                          _newPlace;
                                                      if (_newPlace == '1') {
                                                        widget.userModal.plceEnum =
                                                            Place.one;
                                                      } else {
                                                        widget.userModal.plceEnum =
                                                            Place.two;
                                                      }
                                                      ;

                                                      final SharedPreferences
                                                      prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                      await prefs.setString(
                                                          "_foodplace", _newPlace);

                                                      ls.clear();

                                                      dialogSetState(() {
                                                        Loading.isLoading = false;
                                                      });
                                                      Get.back();
                                                    },
                                                    child: Text(
                                                      '변경하기',
                                                      style: TextStyle(
                                                        color: greenColor,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            )).then((value) => setState(() {}));
                          },
                          child: Text(
                            '변경하기',
                            style: TextStyle(color: greenColor),
                          ),
                        ),

                      ],
                    ),
                  );
                }
                else{
                  Navigator.push(context,MaterialPageRoute(builder: (context) => My_Subscriptions(widget.userModal),) );

                }
              },

                onCanceled: () {
                  // Get.dialog(
                  //   AlertDialog(
                  //     title: Text('확인'),
                  //     content: Text('가입하신 지역을 정말 변경하시겠습니까?'),
                  //     actions: [
                  //       TextButton(
                  //         onPressed: () => Get.back(),
                  //         child: Text(
                  //           '취소',
                  //           style: TextStyle(color: greenColor),
                  //         ),
                  //       ),
                  //
                  //       TextButton(
                  //         onPressed: () {
                  //           Get.back();
                  //           Get.dialog(StatefulBuilder(
                  //             builder: (dialogContext, dialogSetState) =>
                  //                 Loading(
                  //               child: AlertDialog(
                  //                 title: Text('가입 지역 변경'),
                  //                 content: Container(
                  //                   child: Column(
                  //                     mainAxisSize: MainAxisSize.min,
                  //                     children: [
                  //                       SizedBox(height: height * 0.04),
                  //                       InkWell(
                  //                         onTap: () {
                  //                           dialogSetState(() {
                  //                             _selectedPlace = 1;
                  //                           });
                  //                         },
                  //                         child: Card(
                  //                           color: _selectedPlace == 1
                  //                               ? greenColor
                  //                               : Colors.white,
                  //                           shape: RoundedRectangleBorder(
                  //                               borderRadius:
                  //                                   BorderRadius.circular(100),
                  //                               side: BorderSide(
                  //                                   color: greenColor)),
                  //                           child: SizedBox(
                  //                             width: Get.width / 1.5,
                  //                             height: Get.width / 8,
                  //                             child: Center(
                  //                               child: Text(
                  //                                 '흥덕/서원/세종',
                  //                                 style: TextStyle(
                  //                                   color: _selectedPlace == 1
                  //                                       ? Colors.white
                  //                                       : greenColor,
                  //                                   fontSize: 14,
                  //                                   fontWeight: FontWeight.bold,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       SizedBox(height: height * 0.02),
                  //                       InkWell(
                  //                         onTap: () {
                  //                           dialogSetState(() {
                  //                             _selectedPlace = 2;
                  //                           });
                  //                         },
                  //                         child: Card(
                  //                           color: _selectedPlace == 2
                  //                               ? greenColor
                  //                               : Colors.white,
                  //                           shape: RoundedRectangleBorder(
                  //                               borderRadius:
                  //                                   BorderRadius.circular(100),
                  //                               side: BorderSide(
                  //                                   color: greenColor)),
                  //                           child: SizedBox(
                  //                             width: Get.width / 1.5,
                  //                             height: Get.width / 8,
                  //                             child: Center(
                  //                               child: Text(
                  //                                 '상당/청원/충북',
                  //                                 style: TextStyle(
                  //                                   color: _selectedPlace == 2
                  //                                       ? Colors.white
                  //                                       : greenColor,
                  //                                   fontSize: 14,
                  //                                   fontWeight: FontWeight.bold,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       SizedBox(height: height * 0.04),
                  //                       AnimatedOpacity(
                  //                         opacity: _selectedPlace == 0 ? 0 : 1,
                  //                         duration: Duration(milliseconds: 500),
                  //                         child: Row(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.spaceEvenly,
                  //                           children: [
                  //                             TextButton(
                  //                               onPressed: () {
                  //                                 _selectedPlace = 0;
                  //                                 Get.back();
                  //                               },
                  //                               child: Text(
                  //                                 '취소',
                  //                                 style: TextStyle(
                  //                                   color: greenColor,
                  //                                   fontSize: 14,
                  //                                   fontWeight: FontWeight.bold,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             TextButton(
                  //                               onPressed: () async {
                  //                                 String _newPlace =
                  //                                     _selectedPlace == 1
                  //                                         ? '1'
                  //                                         : '2';
                  //                                 dialogSetState(() {
                  //                                   Loading.isLoading = true;
                  //                                 });
                  //                                 _selectedPlace = 0;
                  //
                  //                                 QuerySnapshot ds = null;
                  //                                 ds = await FirebaseFirestore
                  //                                     .instance
                  //                                     .collection('user')
                  //                                     .where('Email',
                  //                                         isEqualTo: widget
                  //                                             .userModal.Email)
                  //                                     .get();
                  //
                  //                                 await FirebaseFirestore
                  //                                     .instance
                  //                                     .collection('user')
                  //                                     .doc(ds.docs.first.id)
                  //                                     .update({
                  //                                   'place': _newPlace,
                  //                                 });
                  //
                  //                                 widget.userModal.place =
                  //                                     _newPlace;
                  //                                 if (_newPlace == '1') {
                  //                                   widget.userModal.plceEnum =
                  //                                       Place.one;
                  //                                 } else {
                  //                                   widget.userModal.plceEnum =
                  //                                       Place.two;
                  //                                 }
                  //                                 ;
                  //
                  //                                 final SharedPreferences
                  //                                     prefs =
                  //                                     await SharedPreferences
                  //                                         .getInstance();
                  //                                 await prefs.setString(
                  //                                     "_foodplace", _newPlace);
                  //
                  //                                 ls.clear();
                  //
                  //                                 dialogSetState(() {
                  //                                   Loading.isLoading = false;
                  //                                 });
                  //                                 Get.back();
                  //                               },
                  //                               child: Text(
                  //                                 '변경하기',
                  //                                 style: TextStyle(
                  //                                   color: greenColor,
                  //                                   fontSize: 14,
                  //                                   fontWeight: FontWeight.bold,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           )).then((value) => setState(() {}));
                  //         },
                  //         child: Text(
                  //           '변경하기',
                  //           style: TextStyle(color: greenColor),
                  //         ),
                  //       ),
                  //
                  //     ],
                  //   ),
                  // );
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: '1',
                        child: Text('가입 지역 변경'),
                      ),
                    PopupMenuItem(
                      value: '2',
                      child: Text('가입신청서 확인'),

                      ),

                ]
                // },
                ),


            // IconButton(onPressed: () {
            //   DropDown
            // }, icon: Icon(Icons.more_horiz)),
          ],
        ),
        // drawer: Drawer(
        //   child: Padding(
        //     padding: const EdgeInsets.all(18.0),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Container(
        //           height: 150,
        //         ),
        //         TextWidget(
        //           text: widget.userModal.Email,
        //           style: TextStyle(
        //             fontWeight: FontWeight.normal,
        //             fontSize: 18,
        //             color: Colors.black,
        //           ),
        //           left: 0.0,
        //           top: 0.0,
        //           bottom: 0.0,
        //           right: 0.0,
        //         ),
        //         Container(
        //           height: 20,
        //         ),
        //         FlatButton(
        //           color: Colors.white,
        //           // onPressed: _restartApp,
        //           child: TextWidget(
        //             text: '로그아웃',
        //             style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               fontSize: 24,
        //               color: Colors.black,
        //             ),
        //             left: 0.0,
        //             top: 0.0,
        //             bottom: 0.0,
        //             right: 0.0,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
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
                text: widget.userModal.plceEnum == Place.one
                    ? '흥덕 / 서원 / 세종'
                    : '상당 / 청원 / 충북',
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
                      .where("place",
                          isEqualTo: widget.userModal.place.toString())
                      .limit(3)
                      .orderBy("time", descending: true)
                      .get(),
                  builder: (context, snapshot) {
                    // if (snapshot.hasData) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      print(snapshot.data.docs.length);
                      print(widget.userModal.place);
                      print('connection state !!');

                      if (ls.length == 0) {
                        snapshot.data.docs.forEach((element) {
                          ls.add(NoticeModal(element, widget.userModal));
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
                      .where("place",
                          isEqualTo: widget.userModal.place.toString())
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
                        ls.add(NoticeModal(element, widget.userModal));
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
            onTap: () {
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
                  topLeft: Radius.circular(20),
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
            onTap: () {
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
                  topRight: Radius.circular(20),
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
}
