import { StatusBar } from "expo-status-bar";
import { StyleSheet, Text, View } from "react-native";
import ThemeProvider from "./src/theme/useTheme";

import Navigation from "@/navigation";
import AuthProvider from "@/context/authContext";
export default function App() {
  return (
    <ThemeProvider>
      <AuthProvider>
        <View style={styles.container}>
          <Navigation />
          <StatusBar style="auto" />
        </View>
      </AuthProvider>
    </ThemeProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});
