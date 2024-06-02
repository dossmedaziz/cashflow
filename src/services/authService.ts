import httpClient from "./httpClient";

import {SignInForm , SignUpForm} from "@/types"
 const login =  (signInForm  : SignInForm , onSuccess :(response : any)=>void  , onFail :(response : any)=> void) => {
  try {
   return   httpClient.post("/auth/login", signInForm)
    .then(onSuccess)
    .catch(onFail);
  } catch (error) {
    throw error;
  }
};

const register =  (signUpForm : SignUpForm , onSuccess :(response : any)=>void  , onFail :(response : any)=> void) => {
    try {
     return   httpClient.post("/auth/register", {
       ...signUpForm,
       password_confirmation : signUpForm.password
      })
      .then(onSuccess)
      .catch(onFail);
    } catch (error) {
      throw error;
    }
  
}


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
    logout,
    register
}