import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

//const db = admin.firestore();
const fcm = admin.messaging();


export const sendToTopic = functions.firestore
  .document('notice/{puppyId}')
  .onCreate(async snapshot => {
    const puppy = snapshot.data();

    var body = puppy.notice
    if(puppy.text!=null){
    body = puppy.text
    }

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Notice!  : '+puppy.notice,
        body: body,
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
      }
    };

    return fcm.sendToTopic(puppy.place, payload);
  });