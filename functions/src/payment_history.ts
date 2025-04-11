import {DocumentData} from "firebase-admin/firestore";

export interface IPaymentHistory extends DocumentData{
    id: string,
    activity_type: ActivityType,
    status: ActivityStatus,
    amount: number,
    amount_expected_when_successful: number,
    amount_unit: string, // Naira.
    amount_expected_unit: string, // Naira
    created_at: string,
    updated_at: string,
    bank: string | null,
    account_name: string | null,
    account_number: string | null,
    title: string,
    imageUrl: string,
}

export enum ActivityType{
    WalletDeposit = "walletDeposit",
}

export enum ActivityStatus{
    Pending = "pending",
    Failed = "failed",
    Success = "successful",
}
