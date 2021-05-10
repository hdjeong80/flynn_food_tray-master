import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


saveDeviceToken(userdoc) async {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Get the current user
  String uid = 'jeffd23';
  // FirebaseUser user = await _auth.currentUser();

  // Get the token for this device
  String fcmToken = await _fcm.getToken();

  // Save it to Firestore
  if (fcmToken != null) {
    var tokens = FirebaseFirestore.instance
        .collection('user')
        .doc(userdoc)
        .collection('tokens')
        .doc(fcmToken);

    await tokens.set({
      'token': fcmToken,
      'createdAt': FieldValue.serverTimestamp(), // optional
      'platform': Platform.operatingSystem // optional
    });
  }
}
