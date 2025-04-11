
// This is a firebase function. But it is called by paystack

import {getFirestore} from "firebase-admin/firestore";
import {logger} from "firebase-functions/v1";
import {onRequest} from "firebase-functions/v2/https";
import {IPaymentHistory, ActivityStatus} from "./payment_history";
import {converter} from "./type_converter";
import {ITransactionHistory} from "./transaction_history";


// This is a firebase function. But it is called by paystack


// Payment  webhook.

// Ideally, you're not supposed to set cors to false.
// But it makes it easier for Paystack to reach this endpoint.
//
// Deploy the function, and update the webhook url with the endpoint.

exports.paystackCompleteTransactionWebhook = onRequest({cors: false},
  async (request, response)=> {
    const event = request.body.event;
    if (event.includes("charge")) {
      // This happens when users complete payment transaction into your account.
      // There are other events that will call this webhook.
      // Refer to paystack documentation to know more about these events.
      logger.log("Payment Completion Initiated",
        request.body.data.metadata.userid,);
      try {
        // You can create a transaction history collection to save the details
        // of all transactions. that ping your webhook.
        const transactionHistoryCollection = getFirestore()
          .collection("transaction-history")
          .withConverter(converter<ITransactionHistory>());
        const transactionHistory: ITransactionHistory = {
          "meta": request.body,
          "amount_in_kobo": request.body.data.amount,
          "channel": request.body.data.channel,
          "created_at": request.body.data.created_at,
          "currency": request.body.data.currency,
          "fees_in_kobo": request.body.data.fees,
          "gateway_response": request.body.data.gateway_response,
          "ip_address": request.body.data.ip_address,
          "payment_history_ref": request.body.data.metadata.id,
          "reference": request.body.data.reference,
          "phone_number": request.body.data.metadata.phone_number,
          "userid": request.body.data.metadata.userid,
          "paid_at": request.body.data.paid_at,
          "source": request.body.data.source.source,
          "entry_point": request.body.data.source.entry_point,
          "status": request.body.data.status,
          "event": request.body.event,
          "email": request.body.data.customer.email,
          "id": "",
        };
        const transDoc = await transactionHistoryCollection
          .add(transactionHistory);
        transDoc.update({"id": transDoc.id});

        // Update the User's payment-history with the transaction history

        const paymentHistoryDoc = getFirestore().collection("payment-history")
          .doc(transactionHistory.userid).collection("user-payment-history")
          .doc(transactionHistory.payment_history_ref)
          .withConverter(converter<IPaymentHistory>());

        const lastUpdatedTime = (new Date()).toISOString();
        if (transactionHistory.event == "charge.success") {
          await paymentHistoryDoc.update({
            status: ActivityStatus.Success,
            updated_at: lastUpdatedTime,
          });
        } else if (transactionHistory.event.includes("failed")) {
          await paymentHistoryDoc.update({
            status: ActivityStatus.Failed,
            updated_at: lastUpdatedTime,
          });
        } else if (transactionHistory.event.includes("pending")) {
          await paymentHistoryDoc.update({
            status: ActivityStatus.Pending,
            updated_at: lastUpdatedTime,
          });
        }

        response.status(200).end();
      } catch (error) {
        logger.error("Payment Error: ", error);
        response.status(200).end();
        // send 200 on error so Paystack doesn't keep pinging the webhook.
      }
    }
  },);
