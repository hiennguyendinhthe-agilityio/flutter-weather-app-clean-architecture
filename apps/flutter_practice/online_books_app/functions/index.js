const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendPushNotification = functions.firestore
    .document("items/{itemId}")
    .onCreate((snap, context) => {
      const newItem = snap.data();
      const itemName = newItem.name;
      const itemId = context.params.itemId;


      const userToken = "cp6NR7JyQJ-Ph1AwdOJl8U:APA91bGZ9mjCGDKnoA0PcD6-75dofDN8mZwBrSvNgSe9nnRMd1C7T-OS0kAcNnC4TeWI49oxjMFIH7RvPC_DEVT6KneASkTDxDHt31jpnVNPngmj97NeXdg";

      const message = {
        notification: {
          title: "New Item Added!",
          body: "A new item \"$itemName\" has been added.",
        },
        data: {
          "item_id": itemId,
          "name": itemName,
        },
        token: userToken,
      };

      return admin.messaging().send(message)
          .then((response) => {
            console.log("Notification sent successfully:", response);
            return null;
          })
          .catch((error) => {
            console.error("Error sending notification:", error);
          });
    });
