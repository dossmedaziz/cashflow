import { NavigationContainer } from "@react-navigation/native";

import React from "react";
import BottomTabNavigator from "./bottom-tab-stack";
import AuthStackNavigator from "./auth-stack";
import useUserStore from "@/stores/useUserStore";
import AppStack from "./app-stack";
const Navigation = () => {
  const { user } = useUserStore();
  return (
    <NavigationContainer>
      {user ? <BottomTabNavigator /> : <AuthStackNavigator />}
    </NavigationContainer>
  );
};

export default Navigation;
