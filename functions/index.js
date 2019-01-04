const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase LBTA!");
});


exports.observeDriver_Notification = functions.database.ref('/Campus-Connect/Trip_notification_driver/{uid}/{status}')
  .onCreate(event => {

    var driverUID = event.params.uid;

    // let's log out some messages

    console.log('Send noti to this user' + driverUID + 'status');




    })
