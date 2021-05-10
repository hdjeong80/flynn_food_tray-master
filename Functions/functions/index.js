"use strict";
// import * as functions from 'firebase-functions';
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendToDevice = void 0;
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();
const fcm = admin.messaging();
exports.sendToDevice = functions.firestore
    .document('notice/{orderId}')
    .onWrite(async (snapshot) => {
    const order = snapshot.after.data();
    if (order) {
        let ls = order.chat;
        let sortedArray = ls.reverse();
        //console.log(sortedArray[0]['msg']);
        let msterID = snapshot.before.id;
        let senderID = sortedArray[0]['sender'];
        let recieverID = msterID.slice(0, msterID.indexOf(senderID));
        console.log("master    +====" + msterID);
        console.log("sender   +++++++++====" + senderID);
        if (recieverID.length == 0) {
            console.log("lenght   ++++++++++++====  sender len" + senderID.length + '  masterlen   ' + msterID.length);
            recieverID = msterID.slice(senderID.length, msterID.length);
        }
        console.log("recieverID  ++++++++++++====" + recieverID);
        const querySnapshot = await db
            .collection('users')
            .doc(recieverID)
            .collection('tokens')
            .get();
        const tokens = querySnapshot.docs.map(snap => snap.id);
        console.log("tokens  ++++++++++++====" + tokens);
        const payload = {
            notification: {
                title: 'New Message!',
                body: sortedArray[0]['sender'],
                icon: 'your-icon-url',
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            },
            data:{}
        };
        return fcm.sendToDevice(tokens, payload);
    }
    // const payload1: admin.messaging.MessagingPayload = {
    // notification: {
    //   title: 'New Order!',
    //   body: 'you sold ',
    //   icon: 'your-icon-url',
    //   click_action: 'FLUTTER_NOTIFICATION_CLICK',
    // },
    // };
    // return fcm.sendToDevice('tokens', payload1);
    return null;
});
//# sourceMappingURL=index.js.map