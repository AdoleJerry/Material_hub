import axios, {AxiosResponse} from "axios";
import {logger} from "firebase-functions/v1";

import * as env from "dotenv";
// To get environment variable, create a .env file where you save your secrets
// Research online on how to do this.

env.config();
const payStackKey = process.env.PAYSTACK_SECRET_KEY;


// Note: This is not a firebase function.

/**
 * Returns CheckoutUrl after making a request to paystack
 * @param {string} amount the amount to be paid in
 *  NGN kobo i.e 1k naira is 100000.
 * @param {string} email the email of the user.
 * @param {string} userid the user id of the user.
 * @param {string} phoneNumber the phone number of the user.
 * @param {string} id the id of the transaction history item.
 * @return {Promise<any>} checkoutUrl.
 */
export async function makeCallToPayStackForCheckOutUrl(
  amount: number,
  email: string,
  userid: string,
  phoneNumber: string,
  id: string,
): Promise<any> {
  const initiateTransactionPaystack = "https://api.paystack.co/transaction/initialize";
  const secretKey = payStackKey;

  // Authorization: `Bearer ${process.env.PAYSTACK_SECRET_KEY}`,
  const headers = {
    "Authorization": `Bearer ${secretKey}`,
    "content-type": "application/json",
    "cache-control": "no-cache",
  };

  // / we set the history doc id as the reference string.
  // / so we can find the history doc when the webhook api is called. easily.
  const payload = {
    amount: amount,
    email: email,
    reference: id,
    metadata: {
      userid: userid,
      phone_number: phoneNumber,
      id: id,
    },
  };
  try {
    // We use Axios to query paystack url.
    // npm install axios-typescript.
    // to get Axios.

    const response: AxiosResponse = await axios.post(
      initiateTransactionPaystack,
      payload,
      {headers},
    );
    // Expected Response from Paystack.
    // {
    //     "status": true,
    //     "message": "Authorization URL created",
    //     "data": {
    //       "authorization_url": "https://checkout.paystack.com/0peioxfhpn",
    //       "access_code": "0peioxfhpn",
    //       "reference": "7PVGX8MEk85tgeEpVDtD"
    //     }
    //   }
    if (!response.data && response.status !== 200) {
      throw new Error("An error occurred with our third party");
    }

    // / I called the checkout url redirect url. here mistakenly.
    const data = {
      redirect_url: response.data.data.authorization_url,
      payment_ref: response.data.data.reference,
      access_code: response.data.data.access_code,
    };

    return data;
    // Data is returned directly to
    // the firebase function that calls this function.
    // and that firebase function sends
    // the data back to the user in via the response body.
  } catch (error) {
    // Ensure you don't return any secrets in this error response.
    // and log your errors to Firebase Functions Console.
    logger.error("Paystack Error:", error);
    throw (error as Map<string, any>).delete("config");
  }
}
