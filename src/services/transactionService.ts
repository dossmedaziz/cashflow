import httpClient from "@/services/httpClient";
import { TransactionForm } from "@/types";


const getUserTransactions =  () => {
    try {
        return  httpClient.get("/transactions")
    }catch (e) {
        throw e
    }
}

const getTransactionTypes =  () => {
    try {
        return  httpClient.get("/transaction-types")
    }catch (e) {
        throw e
    }
}

const getTransactionCategoriesByType =  (typeId: number) => {
    try {
        return  httpClient.get(`/transaction-types/${typeId}/transaction-categories`)
    }catch (e) {
        throw e
    }

}

const createTransaction =  (transaction: TransactionForm) => {
    try {
        return  httpClient.post("/transactions", transaction)
    }catch (e) {
        throw e
    }


}
export default {
    getUserTransactions,
    getTransactionTypes,
    getTransactionCategoriesByType,
    createTransaction
}