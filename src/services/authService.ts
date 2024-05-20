import httpClient from "./httpClient";


export const login = async (email: string, password: string , onSuccess :(response : any)=>void  , onFail :(response : any)=> void) => {
  try {
   return  await httpClient.post("/auth/login", {
      email,
      password,
    })
    .then(onSuccess)
    .catch(onFail);
  } catch (error) {
    throw error;
  }
};


export const connectedUser = async (token : string) =>{
   try{
    return await httpClient.get("/auth/user")
    
   }catch(error){
    throw error
   }
}