import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { HomeStackParamList } from "./types";
import { AllTransanctionsScreen, HomeScreen } from "@/screens";
import { Text, View } from "react-native";

const Stack = createNativeStackNavigator<HomeStackParamList>();

const HomeStackNavigator = () => {
  return (
    <Stack.Navigator
      screenOptions={{
        headerShown: false,
      }}
    >
      <Stack.Screen name="Home" component={HomeScreen} />
      <Stack.Screen name="AllTransanction" component={AllTransanctionsScreen} />
    </Stack.Navigator>
  );
};

export default HomeStackNavigator;
