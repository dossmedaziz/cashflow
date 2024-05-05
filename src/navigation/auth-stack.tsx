import React from "react";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { AuthStackParamList } from "./types";

import { Onboarding  , SignInScreen , SignUpScreen} from "../screens";
import { NavigationContainer } from "@react-navigation/native";
const Stack = createNativeStackNavigator<AuthStackParamList>();

const AuthStackNavigator = () => {
  return (
    <NavigationContainer>
    <Stack.Navigator
      screenOptions={{
        headerShown: false,
      }}
    >
      <Stack.Screen name="Onboarding" component={Onboarding} />

      <Stack.Screen name="SignIn" component={SignInScreen} />
      <Stack.Screen name="SignUp" component={SignUpScreen} />
    </Stack.Navigator>
    </NavigationContainer>
  );
};

export default AuthStackNavigator;
