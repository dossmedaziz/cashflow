import httpClient from "./httpClient";


 const login = async (email: string, password: string , onSuccess :(response : any)=>void  , onFail :(response : any)=> void) => {
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


 const connectedUser = async (token : string) =>{
   try{
    return await httpClient.get("/auth/user", {
        headers: {
            Authorization: `Bearer ${token}`,
        },
        })
   }catch(error){
    throw error
   }
}

const logout = async (token : string) => {
    try{
        return await httpClient.post("/auth/logout", null,{
            headers: {
                Authorization: `Bearer ${token}`,
            },
        })
    }catch(error){
        throw error
    }
}
export default {
    login,
    connectedUser,
    logout
}