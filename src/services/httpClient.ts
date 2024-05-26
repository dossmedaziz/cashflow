import axios from "axios";
import CashFlowLocalStorage from "@/services/asyncStorage";

const httpClient = axios.create({
  baseURL: "http://192.168.1.11:8000/api",
});

httpClient.interceptors.request.use(
    async (config) => {
        const accessToken = await CashFlowLocalStorage.getData("token");
        if (accessToken) {
            const token = JSON.parse(accessToken).token;
         if(token){
             config.headers.Authorization = `Bearer ${token}`;
         }
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
    );

export default httpClient;