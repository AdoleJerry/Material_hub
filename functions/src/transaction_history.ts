import {DocumentData} from "firebase-admin/firestore";


export interface ITransactionHistory extends DocumentData{
    meta: Map<string, any>,
    amount_in_kobo: number,
    channel: string,
    created_at: string,
    currency: string,
    fees_in_kobo: number,
    gateway_response: string,
    ip_address: string,
    payment_history_ref: string,
    reference: string,
    phone_number: string,
    userid: string,
    paid_at: string,
    entry_point: string,
    source: string,
    status: string,
    event: string,
    email: string,
    id: string,
}
