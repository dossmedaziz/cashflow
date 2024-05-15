import { StyleSheet, Text, View } from "react-native";
import React from "react";
import { useTheme } from "@/theme/useTheme";
const ButtomNavigationBar = () => {
  const { theme } = useTheme();
  return (
    <View style={styles.container}>
      <View
        style={[
          styles.links,
          { backgroundColor: theme.colors.secondaryBgColor },
        ]}
      >
        <Text>Home</Text>
        <Text>Settings</Text>
      </View>
    </View>
  );
};

export default ButtomNavigationBar;

const styles = StyleSheet.create({
  container: {
    flex: 0.15,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "transparent",
  },
  links: {
    flexDirection: "row",
    justifyContent: "space-between",
    width: "80%",
    height: "80%",
    borderRadius: 20,
  },
});
