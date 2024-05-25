import axios from "axios";

const httpClient = axios.create({
  baseURL: "http://192.168.1.11:8000/api",
});

axios.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem("token");
        if (token) {
        config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
    );

export default httpClient;