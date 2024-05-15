import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";

import { RootButtonTabParamList } from "./types";
import HomeStackNavigator from "./home-stack";
import { useTheme } from "@/theme/useTheme";
import { Text } from "react-native";
import { ButtomNavigationBar } from "@/components";
import { AddTransactionScreen, PorfileScreen } from "@/screens";

const Tab = createBottomTabNavigator<RootButtonTabParamList>();

const BottomTabNavigator = () => {
  const { theme } = useTheme();
  return (
    <Tab.Navigator
      screenOptions={{
        tabBarActiveTintColor: "black",
        tabBarInactiveTintColor: theme.colors.gray550,
        tabBarHideOnKeyboard: true,
        tabBarShowLabel: false,
        headerShown: true,
      }}
      tabBar={(props) => <ButtomNavigationBar {...props} />}
    >
      <Tab.Screen name="HomeStack" component={HomeStackNavigator} />
      <Tab.Screen name="AddTransaction" component={AddTransactionScreen} />
      <Tab.Screen name="Porfile" component={PorfileScreen} />
    </Tab.Navigator>
  );
};

export default BottomTabNavigator;
