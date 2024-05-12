import { NavigationContainer } from "@react-navigation/native";

import React from "react";
import BottomTabNavigator from "./bottom-tab-stack";
import AuthStackNavigator from "./auth-stack";
const Navigation = () => {
  const user = true;
  return (
    <NavigationContainer>
      {user ? <BottomTabNavigator /> : <AuthStackNavigator />}
    </NavigationContainer>
  );
};

export default Navigation;
