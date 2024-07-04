import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { TransactionStackParamList } from "./types";
import {
  AddTransactionScreen,
  AllTransanctionsScreen,
  HomeScreen,
} from "@/screens";

const Stack = createNativeStackNavigator<TransactionStackParamList>();

const TransactionStack = (
  <Stack.Group screenOptions={{ headerShown: false }}>
    <Stack.Screen name="AllTransactions" component={AllTransanctionsScreen} />
    <Stack.Screen name="AddTransaction" component={AddTransactionScreen} />
    <Stack.Screen name="EditTransaction" component={AddTransactionScreen} />
  </Stack.Group>
);

export default TransactionStack;
