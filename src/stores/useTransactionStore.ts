import { create } from "zustand";
import {TransactionStore} from "@/types";

const useTransactionStore = create<TransactionStore>()(
    (set, get) => ({
        transactions: [],
        transactionCategories: [],
        transactionTypes: [],
        addTransaction: (transaction) => {
            set({ transactions: [...get().transactions, transaction] });
        },
        addTransactions: (transactions) => {
            set({ transactions: [...transactions] });
        },
        addTransactionCategories: (transactionCategories) => {
            set({ transactionCategories: [...transactionCategories] });
        },
        addTransactionTypes: (transactionTypes) => {
            set({ transactionTypes: [...transactionTypes] });
        },
    })
);


export default useTransactionStore;