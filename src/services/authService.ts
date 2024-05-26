import httpClient from "./httpClient";


 const login =  (email: string, password: string , onSuccess :(response : any)=>void  , onFail :(response : any)=> void) => {
  try {
   return   httpClient.post("/auth/login", {
      email,
      password,
    })
    .then(onSuccess)
    .catch(onFail);
  } catch (error) {
    throw error;
  }
};


 const connectedUser =  () =>{
   try{
    return  httpClient.get("/auth/user")
   }catch(error){
    throw error
   }
}

const logout =  () => {
    try{
        return  httpClient.post("/auth/logout",)
    }catch(error){
        throw error
    }
}
export default {
    login,
    connectedUser,
    logout
}