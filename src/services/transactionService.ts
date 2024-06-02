import httpClient from "@/services/httpClient";


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

export default {
    getUserTransactions,
    getTransactionTypes
}