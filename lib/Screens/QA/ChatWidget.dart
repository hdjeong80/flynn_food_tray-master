import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_tray/Contants/colors.dart';
import 'package:food_tray/Screens/modal/ChatModal.dart';
import 'package:food_tray/Screens/modal/UserModal.dart';
import 'package:food_tray/Widgets/QACard.dart';
import 'package:food_tray/Widgets/TextWidget.dart';

class ChatWidget extends StatelessWidget {
  String id;
  ChatModal chatModal;

  ChatWidget(this.chatModal, {this.id});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*      TextWidget(
                text: '답변 대기중',
                style: TextStyle(
                  color: chatModal.Answered ?greenColor:Color.fromRGBO(181, 190, 195, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                left: width * 0.08,
                right: width * 0.08,
                top: height * 0.02,
                bottom: height * 0.03,
              ),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // IconButton(
                  //   icon: Icon(Icons.edit),
                  //   onPressed: () async {},
                  // ),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('삭제'),
                                content: Text('삭제 하시겠습니까?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('취소'),
                                  ),
                                  TextButton(
                                    onPressed: () async =>
                                        await FirebaseFirestore.instance
                                            .collection('QA')
                                            .doc(id)
                                            .delete()
                                            .then((value) =>
                                                Navigator.of(context).pop()),
                                    child: Text('확인'),
                                  ),
                                ],
                              ));
                    },
                  ),
                ],
              ),
              QACard(
                question: '문의',
                answer: chatModal.question,
              ),
              chatModal.Answered
                  ? QACard(
                      question: chatModal.Answered ? '답변' : '문의',
                      answer: chatModal.Answered
                          ? chatModal.answer
                          : chatModal.question,
                      boldAnswer: chatModal.Answered
                          ? FontWeight.bold
                          : FontWeight.normal,
                    )
                  : Container(),
              // Divider(
              //   color: grayColor,
              //   thickness: 1.5,
              // ),
              Opacity(
                opacity: 0,
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.more),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
