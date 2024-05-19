import { createContext, useContext, useEffect, useState } from "react";
import { storeData, getData, removeData } from "../services/asyncStorage";
import { Text } from "react-native";
import { connectedUser } from "@/services/authService";
const AuthContext = createContext({});

type AuthProviderProps = {
  children: React.ReactNode;
};

const AuthProvider = ({ children }: AuthProviderProps) => {
  const [user, setUser] = useState<null | object>(null);
  const [token, setToken] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(true);

  const setConnectUser = (user: any) => {
    setUser(user);
    storeData("user", JSON.stringify(user));
  };

  const setAccessToken = (token: string) => {
    setToken(token);
    storeData("token", token);
  };

  const logout = () => {
    removeData("user");
    removeData("token");
    setConnectUser(null);
  };

  const getConnectedUser = () => {
    getData("token").then((token) => {
      connectedUser(token).then((response) => {
        const { user } = response.data;
        console.log(user);
      });
    });
  };

  useEffect(() => {
    const getUser = () => {
      getData("user").then((user) => {
        if (user) {
          setUser(JSON.parse(user));
        }
        setIsLoading(false);
      });
      setUser(user);
    };
    getUser();
  }, []);

  children;

  return (
    <AuthContext.Provider
      value={{ user, setConnectUser, setAccessToken, logout, getConnectedUser }}
    >
      {isLoading ? <Text>loading</Text> : children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);

export default AuthProvider;
