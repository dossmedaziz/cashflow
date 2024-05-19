import { Pressable, StyleSheet, Text, View } from "react-native";
import React from "react";
import { HomeIcon } from "@/icons";
import { useTheme } from "@/theme/useTheme";

type ButtomBarNavLinkProps = {
  label: string;
  screenName: string;
  isActive: boolean;
  navigateTo: (screenName: string) => void;
  icon: React.ReactNode;
};

const ButtomBarNavLink = ({
  screenName,
  navigateTo,
  isActive,
  icon,
  label,
}: ButtomBarNavLinkProps) => {
  const { theme } = useTheme();
  return (
    <Pressable
      style={{
        alignItems: "center",
      }}
      onPress={() => navigateTo(screenName)}
      key={screenName}
    >
      {icon}
      <Text
        style={{
          color: isActive
            ? theme.colors.activeIconColor
            : theme.colors.secondaryTextColor,
          fontSize: 12,
          fontWeight: "bold",
        }}
      >
        {label}
      </Text>
    </Pressable>
  );
};

export default ButtomBarNavLink;

const styles = StyleSheet.create({});
