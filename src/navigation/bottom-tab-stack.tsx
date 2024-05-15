import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";

import { RootButtonTabParamList } from "./types";
import HomeStackNavigator from "./home-stack";
import { useTheme } from "@/theme/useTheme";
import { Text } from "react-native";
import { ButtomNavigationBar } from "@/components";

const Tab = createBottomTabNavigator<RootButtonTabParamList>();

const BottomTabNavigator = () => {
  const { theme } = useTheme();
  return (
    <Tab.Navigator
      screenOptions={{
        tabBarActiveTintColor: "black",
        tabBarInactiveTintColor: theme.colors.gray550,
        tabBarHideOnKeyboard: true,
      }}
      tabBar={() => <ButtomNavigationBar />}
    >
      <Tab.Screen
        name="HomeStack"
        component={HomeStackNavigator}
        options={() => ({
          title: "Home",
          tabBarIcon: ({ color }) => <Text>Home</Text>,
          headerShown: false,
        })}
      />
    </Tab.Navigator>
  );
};

export default BottomTabNavigator;
