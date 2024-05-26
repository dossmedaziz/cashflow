import httpClient from "@/services/httpClient";


const getUserTransactions =  () => {
    try {
        return  httpClient.get("/transactions")
    }catch (e) {
        throw e
    }
}

export default {
    getUserTransactions
}