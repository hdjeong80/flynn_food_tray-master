import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_tray/Contants/colors.dart';
import 'package:food_tray/Screens/modal/UserModal.dart';
import 'package:food_tray/Screens/see_my_subscriptions/FullScreenSubscription.dart';
import 'package:food_tray/Widgets/TextWidget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_tray/Screens/modal/UserModal.dart';

import '../../Contants/colors.dart';
import '../../Widgets/TextWidget.dart';
import 'package:intl/intl.dart';

class My_Subscriptions extends StatefulWidget {
  final UserModal userModal;
  My_Subscriptions(this.userModal);

  @override
  _My_SubscriptionsState createState() => _My_SubscriptionsState();
}

class _My_SubscriptionsState extends State<My_Subscriptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // actions: [Icon(Icons.arrow_back_ios,color: Colors.black54,)],
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
            size: 20,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '제출한 신청서',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            Container(
              width: 10,
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("subscription")
            .where('Email', isEqualTo: widget.userModal.Email)
            .orderBy('datetime', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot qs = snapshot.data;
            print(snapshot.data.docs.length);

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubscribeFullScreen(qs.docs[index]['img']),
                          ));
                    },
                    child: Material(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                text: DateFormat("yyyy.MM.dd HH:mm").format(
                                    qs.docs[index]['datetime'].toDate()),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: blackColor,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black54,
                                size: 30,
                              )
                            ],
                          ),
                          Container(
                            height: 10,
                          ),
                          Container(
                            color: Colors.black54,
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 1,
                          ),
                          Container(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return ModalProgressHUD(inAsyncCall: true, child: Container());
        },
      ),
    );
  }
}
