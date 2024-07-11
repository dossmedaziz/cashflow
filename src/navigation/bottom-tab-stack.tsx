import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";

import { RootButtonTabParamList } from "./types";
import HomeStackNavigator from "./home-stack";
import { useTheme } from "@/theme/useTheme";
import { ButtomNavigationBar } from "@/components";
import { PorfileScreen, StatsScreen } from "@/screens";
import TransactionStack from "./transaction-stack";

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
        headerShown: false,
        tabBarStyle: {
          backgroundColor: "red",
        },
      }}
      tabBar={(props) => <ButtomNavigationBar {...props} />}
    >
      <Tab.Screen name="HomeStack" component={HomeStackNavigator} />
      <Tab.Screen name="Transactionstack" component={TransactionStack} />
      <Tab.Screen name="Stats" component={StatsScreen} />
      <Tab.Screen name="Porfile" component={PorfileScreen} />
    </Tab.Navigator>
  );
};

export default BottomTabNavigator;
