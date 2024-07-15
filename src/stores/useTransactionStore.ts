import { create } from "zustand";
import {TransactionStore} from "@/types";

const useTransactionStore = create<TransactionStore>()(
    (set, get) => ({
        transactions: [],
        transactionCategories: [],
        transactionTypes: [],
        incomeTransactions: [],
        expenseTransactions: [],
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
        addIncomeTransactions: (incomeTransactions) => {
            set({ incomeTransactions: [...get().incomeTransactions,...incomeTransactions] });
        },
        addExpenseTransactions: (expenseTransactions) => {
            set({ expenseTransactions: [...get().expenseTransactions,...expenseTransactions] });
        },
        deleteIcomeTransaction: (id) => {
            set({
                incomeTransactions: get().incomeTransactions.filter(
                    (transaction) => transaction.id !== id
                ),
            });
        },
        deleteExpenseTransaction: (id) => {
            set({
                expenseTransactions: get().expenseTransactions.filter(
                    (transaction) => transaction.id !== id
                ),
            });
        },
        deleteTransaction : (id) => {
            set({
                transactions: get().transactions.filter(
                    (transaction) => transaction.id !== id
                ),
            });
        }
    })
);


export default useTransactionStore;