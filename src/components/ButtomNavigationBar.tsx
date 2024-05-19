import { Pressable, StyleSheet, Text, View } from "react-native";
import React from "react";
import { useTheme } from "@/theme/useTheme";
import { HomeIcon, PlusIcon, UserIcon } from "@/icons";
import { hp, wp } from "@/helpers/ruler";
import ButtomBarNavLink from "@/components/ButtomBarNavLink";
const ButtomNavigationBar = ({ state, descriptors, navigation }: any) => {
  const { theme } = useTheme();
  const { index, routes } = state;

  const navigateTo = (screenName: string) => {
    navigation.navigate(screenName);
  };

  const renderTabBarLinks = (screenName: string, isActive: boolean) => {
    switch (screenName) {
      case "HomeStack":
        return (
          <ButtomBarNavLink
            isActive={isActive}
            label="Home"
            navigateTo={navigateTo}
            screenName="HomeStack"
            icon={
              <HomeIcon
                color={
                  isActive
                    ? theme.colors.activeIconColor
                    : theme.colors.secondaryTextColor
                }
              />
            }
            key={screenName}
          />
        );
      case "AddTransaction":
        return (
          <ButtomBarNavLink
            isActive={isActive}
            label="Add"
            navigateTo={navigateTo}
            screenName="AddTransaction"
            icon={
              <PlusIcon
                color={
                  isActive
                    ? theme.colors.activeIconColor
                    : theme.colors.secondaryTextColor
                }
              />
            }
            key={screenName}
          />
        );
      case "Porfile":
        return (
          <ButtomBarNavLink
            isActive={isActive}
            label="Profile"
            navigateTo={navigateTo}
            screenName="Porfile"
            icon={
              <UserIcon
                color={
                  isActive
                    ? theme.colors.activeIconColor
                    : theme.colors.secondaryTextColor
                }
              />
            }
            key={screenName}
          />
        );
    }
  };

  return (
    <View style={styles.container}>
      <View
        style={[
          styles.links,
          { backgroundColor: theme.colors.secondaryBgColor },
        ]}
      >
        {routes.map((route: any, i: number) => {
          return renderTabBarLinks(route.name, index === i);
        })}
      </View>
    </View>
  );
};

export default ButtomNavigationBar;

const styles = StyleSheet.create({
  container: {
    position: "absolute",
    bottom: 20,
    height: hp(8),
    width: "80%",
    alignSelf: "center",
    justifyContent: "center",
    alignItems: "center",
  },
  links: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    width: "100%",
    height: "100%",
    borderRadius: hp(3),
    paddingHorizontal: wp(10),
  },
});
