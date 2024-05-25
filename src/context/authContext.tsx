import {createContext, useCallback, useContext, useEffect, useMemo, useState} from "react";
import CashFlowLocalStorage from "@/services/asyncStorage";
import AuthService from "@/services/authService";
const AuthContext = createContext({});

type AuthProviderProps = {
  children: React.ReactNode;
};

const AuthProvider = ({ children }: AuthProviderProps) => {
  const [user, setUser] = useState<null | object>(null);
  const [token, setToken] = useState<null | string>(null);

  const setConnectUser = (user: any) => {
    setUser(user);
    CashFlowLocalStorage.storeData("user", JSON.stringify(user));
  };

  const setAccessToken = (token: string | null) => {
      setToken(token);
      CashFlowLocalStorage.storeData("token", token);
  };

  const logout = () => {
    CashFlowLocalStorage.removeData("user");
    CashFlowLocalStorage.removeData("token");
    setConnectUser(null);
    setToken(undefined)
  };


  const setConnectedUser = useMemo(async () => {
    if (token) {
        await AuthService.connectedUser(token).then((response) => {
         let{user} = response.data;
         setConnectUser(user)
        }).catch((error) => {
            console.log(error)
        })


    }
  } ,[token])

  useEffect(() => {
      CashFlowLocalStorage.getData("token").then((token) => {
          if (token) {
              setAccessToken(token);
          }
      });
  }, []);
  return (
    <AuthContext.Provider
      value={{ user, setConnectUser, setAccessToken, logout }}
    >
      {children}
    </AuthContext.Provider>
  )
};

export const useAuth = () => useContext(AuthContext);

export default AuthProvider;
