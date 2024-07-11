import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { TransactionStackParamList } from "./types";
import {
  AddTransactionScreen,
  AllTransanctionsScreen,
  AllTransactions,
} from "@/screens";

const Stack = createNativeStackNavigator<TransactionStackParamList>();

const TransactionStack = () => {
  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      <Stack.Screen name="AllTransactions" component={AllTransactions} />
      <Stack.Screen name="AddTransaction" component={AddTransactionScreen} />
      <Stack.Screen name="EditTransaction" component={AddTransactionScreen} />
    </Stack.Navigator>
  );
};

export default TransactionStack;
