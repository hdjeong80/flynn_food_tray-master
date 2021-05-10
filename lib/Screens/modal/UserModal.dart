
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_tray/Contants/Enums.dart';

class UserModal{
  UserModal({QuerySnapshot querySnapshot,Map mp}){
    print("init User Modal ");
    if(querySnapshot!=null)
    init(querySnapshot);
    else if(mp!=null){
      initFromMap(mp);
    }
    else{
      AssertionError("No arguamnt was paased");
    }
  }
  String Email;
  Place plceEnum;
  int  place;


  String name;
  init(QuerySnapshot data){
    this.Email = data.docs[0].data()['Email'];
    this.place = data.docs[0].data()['place']??0;
    if(this.place ==0)
      {    plceEnum = Place.one;
      }
    else{
      plceEnum = Place.two;

    }


  }
  initFromMap(Map data){
    this.Email = data['Email'];
    this.place = data['place'];
    if(this.place ==0)
    {    plceEnum = Place.one;
    }
    else{
      plceEnum = Place.two;

    }


  }


}