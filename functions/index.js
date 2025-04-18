const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.deleteUserFromAuth = functions.https.onCall(async (data, context) => {
  const uid = data.uid;
  try {
    await admin.auth().deleteUser(uid);
    return { success: true };
  } catch (error) {
    return { success: false, error: error.message };
  }
});
