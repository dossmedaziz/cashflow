import React from "react";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { AuthStackParamList } from "./types";

import { Onboarding, SignInScreen, SignUpScreen } from "@/screens";
import { NavigationContainer } from "@react-navigation/native";
import useUserStore from "@/stores/useUserStore";
const Stack = createNativeStackNavigator<AuthStackParamList>();

const AuthStackNavigator = () => {

    const {onBoarding} = useUserStore();
  return (
    <Stack.Navigator
      screenOptions={{
        headerShown: false,
      }}
    >
        {
            !onBoarding && <Stack.Screen name="Onboarding" component={Onboarding} />
        }

      <Stack.Screen name="SignIn" component={SignInScreen} />
      <Stack.Screen name="SignUp" component={SignUpScreen} />
    </Stack.Navigator>
  );
};

export default AuthStackNavigator;
