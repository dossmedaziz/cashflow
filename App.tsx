import { StatusBar } from "expo-status-bar";
import { StyleSheet, Text, View } from "react-native";
import ThemeProvider from "./src/theme/useTheme";
import BottomTabNavigator from "@/navigation/bottom-tab-stack";
import { NavigationContainer } from "@react-navigation/native";
import Navigation from "@/navigation";
export default function App() {
  return (
    <ThemeProvider>
      <View style={styles.container}>
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
