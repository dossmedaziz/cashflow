import { StatusBar } from "expo-status-bar";
import { StyleSheet, Text, View } from "react-native";
import {Onboarding} from "./screens";
import ThemeProvider from "./theme/useTheme";
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
