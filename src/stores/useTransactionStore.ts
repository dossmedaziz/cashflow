import { create } from "zustand";
import {TransactionStore} from "@/types";

const useTransactionStore = create<TransactionStore>()(
    (set, get) => ({
        transactions: [],
        addTransaction: (transaction) => {
            set({ transactions: [...get().transactions, transaction] });
        },
        addTransactions: (transactions) => {
            set({ transactions: [...transactions] });
        }
    })
);


export default useTransactionStore;