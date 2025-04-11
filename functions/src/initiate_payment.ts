import {getFirestore} from "firebase-admin/firestore";
import {onRequest} from "firebase-functions/v2/https";
import {converter} from "./type_converter";
import {
  ActivityStatus,
  ActivityType,
  IPaymentHistory,
} from "./payment_history";
import {logger} from "firebase-functions";
import {makeCallToPayStackForCheckOutUrl} from "./paystack";


// Cross Origin Resource Sharing Info.
// You need to add your app base url here
// to allow requests to these endpoints from your web.
// To allow request from any where. you use something else
export const cors = {
  cors: [
    "http://localhost:5000",
    "https://material-hub-3dfb4.firebaseapp.com",
  ],
};
// you can disable cors by
// exports.sayHello = onRequest(
//  { cors: false },
//  (req, res) => {
//    res.status(200).send("Hello world!");
//  }
// );

// POST BODY
// {
//     "email":"sugar@email.com",
//     "phonenumber":"07037382583",
//     "amount":"2000",
//     "userid":"testuserid"
// }
// You can structure you body anyhow you want.
// But you'll need email and phonenumber to
// process your paystack transaction
// amount is in Naira. and a string.
// userid is how you'll identify the user.
// This API is a POST Endpoint.
// It registers the transaction using the userid
// that's trying to make payment to your Firestore Db.
// create transaction history for this.
// transaction history will be updated when payment is complete.
// get user's email, phonenumber, userid, and amount from request
// get paystack sdk
// set the paystack sdk up
// make the request call
// make call to paystack to fund get callback url
// return the callback url
// end this function.

exports.initiatePaymentTransaction = onRequest(cors,
  async (request, response) => {
    try {
      const userid: string = request.body.userid;
      logger.info(`Initiate Payment: Payment Started for ${userid}`);
      const email: string = request.body.email;
      const phoneNumber: string = request.body.phonenumber;
      const amount: string = request.body.amount;
      const title: string = request.body.title; // New field for title
      const imageUrl: string = request.body.imageUrl;
      const transactionTime: string = (new Date()).toISOString();

      // We get the payment collection for a User.
      // We use a converter so we can deal with
      // a structured response object from
      // cloud firestore.
      const paymentHistory = getFirestore()
        .collection("payment-history")
        .doc(userid).collection("user-payment-history")
        .withConverter(converter<IPaymentHistory>());

      if (Number.isNaN(Number.parseInt(amount))) {
      // if the amount can't be converted from the string,
      // we send a response to the user.
        response.status(400).send({message: "Invalid amount"});
      } else {
        const newPayment: IPaymentHistory = {
          id: "",
          activity_type: ActivityType.WalletDeposit,
          status: ActivityStatus.Pending,
          amount: Number.parseInt(amount) ?? 0,
          amount_expected_when_successful: Number.parseInt(amount)??0,
          amount_unit: "Naira",
          amount_expected_unit: "Naira",
          created_at: transactionTime,
          updated_at: transactionTime,
          bank: null,
          account_name: null,
          account_number: null,
          title: title,
          imageUrl: imageUrl,
        };

        // Always use this history doc to update the transaction Data.
        const historyDoc = await paymentHistory.add(newPayment);
        historyDoc.update({id: historyDoc.id});
        // We will implement this function in another file.
        // Paystack takes payment in kobo,
        // so the naira has to be converted to kobo.
        const result = await makeCallToPayStackForCheckOutUrl(
          (Number.parseInt( amount) ?? 0) * 100,
          email,
          userid,
          phoneNumber,
          historyDoc.id,
        );

        response.send(result);
      }
    } catch (error) {
      response.status(400).send(error);
      logger.error("Error in initiatePaymentTransaction:", error);
      response.status(500).send({message: "Internal Server Error"});
    }
  });
