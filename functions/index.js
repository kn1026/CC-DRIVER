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


exports.observe_request_ride = functions.database.ref('/Campus-Connect/Request_noti/{uid}/{likingId}')
  .onCreate((snap,context) => {

    var payload = {
      notification: {
        title: "Notice !!!",
        body: 'Students are currently looking for rides right now, go online and start giving rides!',
        badge : '1',
        sound: 'default',
      },

      data: {
        type: "abcd",
      }


    };

    admin.messaging().sendToTopic('CC-Driver',payload)
    .then(response => {
      console.log("Successfully sent message:", response);
      return response
    }).catch(function(error) {
      console.log("Error sending message:", error);
      return error
    });


})
