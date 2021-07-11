import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:food_tray/Contants/Enums.dart';
import 'package:food_tray/Contants/colors.dart';
import 'package:food_tray/Screens/auth_screens/LoginInScreen.dart';
import 'package:food_tray/Screens/modal/UserModal.dart';
import 'package:food_tray/Screens/notice/NoticeSceen.dart';
import 'package:food_tray/Widgets/BottomBar.dart';
import 'package:food_tray/Widgets/TextWidget.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:food_tray/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginInScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SignUpScreen extends StatefulWidget {
  Place _place;
  SignUpScreen(this._place);
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  bool place = true;
  bool _loading = false;
  TextEditingController _passwordtxtCtrl = TextEditingController();
  String pasString = "";

  @override
  void initState() {
    super.initState();
    place = widget._place == Place.one ? true : false;
    _passwordtxtCtrl.addListener(() {
      setState(() {
        pasString = _passwordtxtCtrl.text;
        print("dsd");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Scaffold(
          backgroundColor: Colors.white,
          // bottomNavigationBar: GestureDetector(
          //   onTap: () {
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => LoginInScreen(),
          //       ),
          //     );
          //   },
          //   child: BottomBar(
          //     containerHeight: height * 0.10,
          //     textHeight: height * 0.03,
          //     text: '이미 계정이 있습니다',
          //   ),
          // ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: '식판스토리앱 \n회원가입',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: blackColor,
                      ),
                      left: width * 0.08,
                      //top: ,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              place = true;
                            });
                          },
                          child: TextWidget(
                            text: '흥덕/서원/세종',
                            style: TextStyle(
                              color: place ? Colors.black : grayColor,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                            right: width * 0.08,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              place = false;
                            });
                          },
                          child: TextWidget(
                            text: '상당/청원/충북',
                            style: TextStyle(
                              color: place == false ? Colors.black : grayColor,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                            right: width * 0.08,
                          ),
                        ),
                      ],
                    ),
                  ],
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
                          text: '이메일',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: lightBlackColor,
                          ),
                        ),
                        FormBuilderTextField(
                          name: 'Email',
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: grayColor,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                            border: OutlineInputBorder(),
                            labelText: '이메일을 입력해주세요.',
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.email(context,
                                errorText: '이 필드에는 유효한 이메일 주소가 필요합니다.'),
                            FormBuilderValidators.required(context,
                                errorText: '이 필드는 필수입니다'),

                            // FormBuilderValidators.(context),
                          ]),
                        ),
                        SizedBox(height: 10),
                        TextWidget(
                          text: '비밀번호',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: lightBlackColor,
                          ),
                        ),
                        FormBuilderTextField(
                          name: 'password',
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: grayColor,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                            border: OutlineInputBorder(),
                            labelText: '비밀번호를 입력해주세요.',
                          ),
                          controller: _passwordtxtCtrl,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.minLength(context, 6,
                                errorText: '비밀번호는 6 자리 숫자 여야합니다.',
                                allowEmpty: false),
                            FormBuilderValidators.required(context,
                                errorText: '이 필드는 필수입니다'),
                          ]),
                        ),
                        SizedBox(height: 10),
                        TextWidget(
                          text: '비밀번호확인',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: lightBlackColor,
                          ),
                        ),
                        FormBuilderTextField(
                          name: 'password1',
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: grayColor,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                            border: OutlineInputBorder(),
                            labelText: '비밀번호를 다시 입력해주세요.',
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: '이 필드는 필수입니다'),
                            FormBuilderValidators.equal(context, pasString,
                                errorText: '비밀번호가 일치하지 않습니다 *')
                          ]),
                        ),
                        SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            print(_passwordtxtCtrl);
                            formKey.currentState.save();
                            if (formKey.currentState.validate()) {
                              Registeruser(formKey.currentState.value);
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
                                '회원가입',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: greenColor,
                                ),
                                // top: height * 0.02,
                              ),
                            ),
                          ),
                        )
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

  Registeruser(data) async {
    setState(() {
      _loading = true;
    });

    QuerySnapshot ds = await FirebaseFirestore.instance
        .collection('user')
        .where('Email', isEqualTo: data['Email'])
        .get();
    var t = null;
    if (ds.docs.length == 0) {
      var _place = place ? Place.one.index : Place.two.index;
      Map mp = {'place': (_place + 1).toString()};
      mp.addAll(data);

      t = await FirebaseFirestore.instance
          .collection('user')
          .add(Map<String, dynamic>.from(mp));
      ds = await FirebaseFirestore.instance
          .collection('user')
          .where('Email', isEqualTo: data['Email'])
          .get();

      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      prefs.setString("_foodemail", data['Email']);
      prefs.setString("_foodplace", ds.docs.first.data()["place"].toString());

      await FirebaseMessaging.instance
          .subscribeToTopic(ds.docs.first.data()["place"]);
    }

    setState(() {
      _loading = false;
    });

    showpopup(t);
  }

  showpopup(res) {
    if (res == null) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "ERROR",
        desc: "USER ALREADY EXISTS",
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            // onPressed: () => Navigator.pop(context),
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
      desc: "USER REGISTERED",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Get.offAll(() => LoginInScreen());
            // FlutterRestart.restartApp();

            //   Navigator.pop(context);
            // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginInScreen(),));
          },
          width: 120,
        )
      ],
    ).show();

    // Manage_Employee
  }
}
