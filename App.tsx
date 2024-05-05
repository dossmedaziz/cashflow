import { StatusBar } from "expo-status-bar";
import { StyleSheet, Text, View } from "react-native";
import {Onboarding} from "./src/screens";
import ThemeProvider from "./src/theme/useTheme";
export default function App() {
  return (
    <ThemeProvider>
      <View style={styles.container}>
        <Onboarding />
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
