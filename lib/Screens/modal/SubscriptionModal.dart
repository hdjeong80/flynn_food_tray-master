




import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class SubsrciptionModal  {
  SubsrciptionModal(this.queryDocumentSnapshot){
    if(this.queryDocumentSnapshot==null)
    initforNULL();
    else
      init();

  }
  final QueryDocumentSnapshot queryDocumentSnapshot;
  String index;


  String txt1;
  String txt2;
  String txt3;
  String Email;


  init(){



    txt1 = queryDocumentSnapshot.data()['txt1']??"";
    txt2 = queryDocumentSnapshot.data()['txt2']??"";
    txt3 = queryDocumentSnapshot.data()['txt3']??"";
    Email = queryDocumentSnapshot.data()['Email']??"";

    index =( queryDocumentSnapshot.data()['index']??'_').toString();


  }
  initforNULL(){



    txt1 = "_";
    txt2 = "_";
    txt3 = "_";
    Email = "_";

    // index =( queryDocumentSnapshot.data()['index']??'_').toString();


  }
  toMap(){
    return {"txt1":this.txt1,
      "txt2":this.txt2,
      "txt3":this.txt3,};

  }

}


