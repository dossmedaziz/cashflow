import { StatusBar } from "expo-status-bar";
import { StyleSheet, Text, View } from "react-native";
import ThemeProvider from "./src/theme/useTheme";
import * as SplashScreen from "expo-splash-screen";
import Toast from "react-native-toast-message";

import Navigation from "@/navigation";
import { useCallback, useEffect, useState } from "react";
import onStart from "./src/onStart";

import Reactotron from "reactotron-react-native";

import useUserStore from "@/stores/useUserStore";
import useTransactionStore from "@/stores/useTransactionStore";
Reactotron.configure({
  name: "CashFlow",
})
  .useReactNative({
    asyncStorage: true,
  })
  .connect();
export default function App() {
  const [appIsReady, setAppIsReady] = useState(false);
  const transactionStore = useTransactionStore();
  const userStore = useUserStore();

  useEffect(() => {
    async function prepare() {
      try {
        await SplashScreen.preventAutoHideAsync();
        await onStart.init(userStore, transactionStore);
      } catch (e) {
        console.warn(e);
      } finally {
        // Tell the application to render
        setAppIsReady(true);
      }
    }

    prepare();
  }, []);

  const onLayoutRootView = useCallback(async () => {
    if (appIsReady) {
      await SplashScreen.hideAsync();
    }
  }, [appIsReady]);

  if (!appIsReady) {
    return null;
  }
  return (
    <ThemeProvider>
      <View style={styles.container} onLayout={onLayoutRootView}>
        <Navigation />
        <StatusBar style="auto" />
        <Toast />
      </View>
    </ThemeProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});
