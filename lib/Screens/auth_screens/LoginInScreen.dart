import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:food_tray/Contants/colors.dart';
import 'package:food_tray/Screens/auth_screens/PlaceScreen.dart';
import 'package:food_tray/Screens/modal/UserModal.dart';
import 'package:food_tray/Screens/notice/NoticeSceen.dart';
import 'package:food_tray/Widgets/TextWidget.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_tray/Contants/Enums.dart';
import 'package:food_tray/Contants/colors.dart';
import 'package:food_tray/Screens/auth_screens/LoginInScreen.dart';
import 'package:food_tray/Screens/modal/UserModal.dart';
import 'package:food_tray/Screens/notice/NoticeSceen.dart';
import 'package:food_tray/Widgets/BottomBar.dart';
import 'package:food_tray/Widgets/TextWidget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:food_tray/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginInScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LoginInScreen extends StatefulWidget {
  @override
  _LoginInScreenState createState() => _LoginInScreenState();
}

class _LoginInScreenState extends State<LoginInScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  bool _isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoticeScreen(UserModal()),
            ));
      }
    });
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                "id",
                'name',
                'description',
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoticeScreen(UserModal(mp: message.data)),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: _isloading,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: '?????????????????? ?????????',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: blackColor,
                  ),
                  left: width * 0.08,
                  top: height * 0.12,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.08,
                    right: width * 0.08,
                    top: width * 0.02,
                  ),
                  child: FormBuilder(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: '?????????',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: lightBlackColor,
                          ),
                        ),
                        FormBuilderTextField(
                          name: 'Email',
                          initialValue: "",
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: grayColor,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                            border: OutlineInputBorder(),
                            labelText: '???????????? ??????????????????.',
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.email(context,
                                errorText: '??? ???????????? ????????? ????????? ????????? ???????????????.'),
                            FormBuilderValidators.required(context,
                                errorText: '??? ????????? ???????????????'),

                            // FormBuilderValidators.(context),
                          ]),
                        ),
                        SizedBox(height: 10),
                        TextWidget(
                          text: '????????????',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: lightBlackColor,
                          ),
                        ),
                        FormBuilderTextField(
                          name: 'password',
                          initialValue: "",
                          obscureText: true,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: grayColor,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                            border: OutlineInputBorder(),
                            labelText: '??????????????? ??????????????????.',
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.minLength(context, 6,
                                errorText: '??????????????? 6 ?????? ?????? ???????????????.',
                                allowEmpty: false),
                            FormBuilderValidators.required(context,
                                errorText: '??? ????????? ???????????????'),
                          ]),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            formKey.currentState.save();
                            if (formKey.currentState.validate()) {
                              LoginUser(formKey.currentState.value);
                            }
                          },
                          child: Container(
                            height: height * 0.08,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: greenColor,
                                width: 2.0,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '?????????',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: greenColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          child: TextButton(
                            onPressed: () {
                              Get.to(() => PlaceScreen());
                            },
                            child: Text(
                              '?????? ????????? ?????????? ??????????????????',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: greenColor,
                              ),
                            ),
                          ),
                          alignment: Alignment.centerRight,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LoginUser(data) async {
    setState(() {
      _isloading = true;
    });
    QuerySnapshot ds = null;
    ds = await FirebaseFirestore.instance
        .collection('user')
        .where('Email', isEqualTo: data['Email'])
        .where('password', isEqualTo: data['password'])
        .get();
    if (ds.docs.length > 0) {
      // await saveDeviceToken(ds.docs[0].id);
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      prefs.setString("_foodemail", data['Email']);
      prefs.setString("_foodplace", ds.docs.first.data()["place"].toString());

      await FirebaseMessaging.instance
          .subscribeToTopic(ds.docs.first.data()["place"]);

      print(ds.size);
    } else {
      ds = null;
    }

    setState(() {
      _isloading = false;
    });

    showpopup(ds, data);
  }

  showpopup(res, data) {
    if (res == null) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "ERROR",
        desc: "USER LOGIN FAILED",
        buttons: [
          DialogButton(
            child: Text(
              "ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
      return;
    }

    Alert(
      context: context,
      type: AlertType.success,
      title: "SUCCESS",
      desc: "USER LOGIN",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            // FlutterRestart.restartApp();
            UserModal user = UserModal(querySnapshot: res);
            Get.offAll(() => NoticeScreen(user));

            //
            // UserModal user = UserModal(querySnapshot: res);
            //
            // print(user);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => NoticeScreen(user),
            //   ),
            // );
          },
          width: 120,
        )
      ],
    ).show();

    // Manage_Employee
  }
}
