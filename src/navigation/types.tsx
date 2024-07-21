import {
  CompositeNavigationProp,
  NavigatorScreenParams,
} from "@react-navigation/native";
import { NativeStackNavigationProp } from "@react-navigation/native-stack";

/*
  auth stack type 
  */
export type AuthStackParamList = {
  Onboarding: undefined;
  SignIn: undefined;
  SignUp: undefined;
};

/*
    App stack type ( buttom tabs)
  */
export type RootButtonTabParamList = {
  HomeStack: NavigatorScreenParams<HomeStackParamList>;
  Transactionstack: NativeStackNavigationProp<TransactionStackParamList>;
  Stats: undefined;
  Porfile: undefined;
};

/*
  home screen stack type
  */
export type HomeStackParamList = {
  Home: undefined;
  AllTransanction: undefined;
};

export type TransactionStackParamList = {
  AllTransactions: undefined;
  AddTransaction: undefined;
  EditTransaction: { id: string };
};

/*
    root stack type
  */
export type RootStackParamList = {
  App: NavigatorScreenParams<RootButtonTabParamList>;
  Auth: NavigatorScreenParams<AuthStackParamList>;
};

declare global {
  namespace ReactNavigation {
    interface RootParamList extends RootStackParamList {}
  }
}

//   export type AuthScreenNavigationType<
//     RouteName extends keyof AuthStackParamList
//   > = CompositeNavigationProp<
//     NativeStackNavigationProp<AuthStackParamList, RouteName>,
//     NativeStackNavigationProp<AppStackParamList, "Root">
//   >;
