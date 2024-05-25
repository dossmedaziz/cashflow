import { StatusBar } from "expo-status-bar";
import { StyleSheet, Text, View } from "react-native";
import ThemeProvider from "./src/theme/useTheme";
import * as SplashScreen from "expo-splash-screen";

import Navigation from "@/navigation";
import { useCallback, useEffect, useState } from "react";


import Reactotron from "reactotron-react-native";
import CashFlowLocalStorage from "@/services/asyncStorage";
import AuthService from "@/services/authService";
import useUserStore from "@/stores/useUserStore";

Reactotron.configure() // controls connection & communication settings
    .useReactNative() // add all built-in react native plugins
    .connect(); // let's connect!
export default function App() {
  const [appIsReady, setAppIsReady] = useState(false);
  const {updateUser} = useUserStore();




  const loadConnectedUser = async () =>{
  await  CashFlowLocalStorage.getData("token").then((token) => {
      AuthService.connectedUser(token)
          .then((response) => {
        let{user} = response.data;
        updateUser(user)
      })
          .catch((error) => {
        console.log(error)
      })
    })
  }

  useEffect(() => {
    async function prepare() {
      try {
        await SplashScreen.preventAutoHideAsync();
        await loadConnectedUser()
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
        </View>
    </ThemeProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});
