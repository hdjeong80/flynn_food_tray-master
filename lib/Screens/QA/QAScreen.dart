import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_tray/Contants/colors.dart';
import 'package:food_tray/Screens/modal/ChatModal.dart';
import 'package:food_tray/Screens/modal/UserModal.dart';
import 'package:food_tray/Widgets/QACard.dart';
import 'package:food_tray/Widgets/TextWidget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'ChatWidget.dart';

class QAScreen extends StatefulWidget {
  UserModal userModal;
  QAScreen(this.userModal);
  @override
  _QAScreenState createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  dialogue() {
    AlertDialog(
      title: TextWidget(
        text: '문의',
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: blackColor,
        ),
      ),
      content: TextWidget(
        text: '',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: blackColor,
          fontSize: 12,
        ),
      ),
    );
  }
  final formKey = GlobalKey<FormBuilderState>();



  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text(
        '확인',
        style: TextStyle(
          color: greenColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () async {
        formKey.currentState.save();
        if(formKey.currentState.validate()){
          var val = formKey.currentState.value;
          Map mp  = {"Email":widget.userModal.Email,"time":DateTime.now()};
          mp.addAll(val);
          print(val['question']);
         await  FirebaseFirestore.instance.collection("QA").add(Map.from(mp));

        }

        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        '문의',
        style: TextStyle(
          color: blackColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: FormBuilder(
        key: formKey,

        child: FormBuilderTextField(
          name: 'question',


          style: TextStyle(
            color: blackColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        child: new Icon(Icons.add),
        backgroundColor: greenColor,
        onPressed: () {
          showAlertDialog(context);
        },
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: TextWidget(
          text: '문의하기 / 서비스 변경 신청',
          style: TextStyle(
            color: lightBlackColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: blackColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("QA").orderBy("time",descending: true).snapshots(),
        builder:(context, snapshot) {
          if(snapshot.hasData) {
            QuerySnapshot qs = snapshot.data;
            print(qs.docs.length);

            return ListView.builder(
              itemCount: qs.docs.length,
              itemBuilder: (context, index) =>  ChatWidget(ChatModal(qs.docs[index].data())),
            );
          }
          return Container(child: ModalProgressHUD(child:Container(),inAsyncCall: true,),);
        } ,

      ),
    );
  }
}
