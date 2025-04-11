/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at
 * https://firebase.google.com/docs/functions
 */
import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import paymentTransaction = require("./initiate_payment");
import webHook = require("./webhook");
import * as admin from "firebase-admin";
admin.initializeApp();

module.exports = {
  ...paymentTransaction,
  ...webHook,
};
// Start writing functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});
