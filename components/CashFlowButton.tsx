import { Pressable, Text, StyleSheet } from "react-native";
import React from "react";
import { useTheme } from "../theme/useTheme";
import { hp, moderateScale, wp } from "../helpers/ruler";

type ButtonProps = {
  onPress: () => void;
  style?: any;
  label: string;
};

const CashFlowButton = ({ onPress, style = {}, label }: ButtonProps) => {
  const { theme } = useTheme();
  return (
    <Pressable
      onPress={onPress}
      style={[
        styles.default,
        { ...style },
        { backgroundColor: theme.colors.primaryButtonColor },
      ]}
    >
      <Text
        style={{
          color: theme.colors.secondaryTextColor,
          fontSize: moderateScale(20),
          fontWeight: "bold",
        }}
      >
        {label}
      </Text>
    </Pressable>
  );
};

const styles = StyleSheet.create({
  default: {
    alignItems: "center",
    justifyContent: "center",
  },
});

export default CashFlowButton;
