import httpClient from "./httpClient";


export const login = async (email: string, password: string) => {
  try {
   return  await httpClient.post("/auth/login", {
      email,
      password,
    })
  } catch (error) {
    throw error;
  }
};