import { NavigationContainer } from "@react-navigation/native";

import React from "react";
import BottomTabNavigator from "./bottom-tab-stack";
import AuthStackNavigator from "./auth-stack";
import { useAuth } from "@/context/authContext";
const Navigation = () => {
  const { user } = useAuth();
  return (
    <NavigationContainer>
      {user ? <BottomTabNavigator /> : <AuthStackNavigator />}
    </NavigationContainer>
  );
};

export default Navigation;
