import { createNativeStackNavigator } from "@react-navigation/native-stack";
import BottomTabNavigator from "./bottom-tab-stack";
import TransactionStack from "./transaction_stack";

const AppStack = () => {
  const Stack = createNativeStackNavigator();

  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      <Stack.Screen name="TabBar" component={BottomTabNavigator} />
      <Stack.Group>{TransactionStack}</Stack.Group>
    </Stack.Navigator>
  );
};

export default AppStack;
