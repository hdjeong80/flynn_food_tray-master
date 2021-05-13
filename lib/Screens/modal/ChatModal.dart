

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModal{

  String question;
  String answer;
  String Email;
  String time;



  bool Answered = true ;

  ChatModal(Map querySnapshot){
    init(querySnapshot);
  }

  init(Map data){
    this.question = data['question']??"";
    this.answer = data['answer']??'';
    this.Email =data['Email']??'';
    // this.time =data['time']??'';


    if(this.answer == '')
    {    Answered = false;
    }


  }




}