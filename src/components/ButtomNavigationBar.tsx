import { Pressable, StyleSheet, Text, View } from "react-native";
import React from "react";
import { useTheme } from "@/theme/useTheme";
import { HomeIcon, PlusIcon, StatsIcon } from "@/icons";
import { hp, wp } from "@/helpers/ruler";
import ButtomBarNavLink from "@/components/ButtomBarNavLink";
import {
  BarChartBig,
  House,
  ScrollText,
  User as UserIcon,
  ArrowUpDown,
} from "lucide-react-native";
const ButtomNavigationBar = ({ state, descriptors, navigation }: any) => {
  const { theme } = useTheme();

  const currentRoute = state.routes[state.index];

  if (currentRoute.name === "HomeStack") {
    if (currentRoute.state) {
      if (currentRoute.state.index === 1) {
        return null;
      }
    }
  }
  const navigateTo = (screenName: string) => {
    navigation.navigate(screenName);
  };

  const bottomTabBarLinks = [
    {
      screenName: "HomeStack",
      label: "Home",
      icon: HomeIcon,
    },
    {
      screenName: "Transactionstack",
      label: "Transactions",
      icon: ArrowUpDown,
    },
    {
      screenName: "Stats",
      label: "Stats",
      icon: StatsIcon,
    },
    {
      screenName: "Porfile",
      label: "Profile",
      icon: UserIcon,
    },
  ];

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
              <House
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
      case "AllTransactions":
        return (
          <ButtomBarNavLink
            isActive={isActive}
            label="Transactions"
            navigateTo={navigateTo}
            screenName="AllTransactions"
            icon={
              <ScrollText
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
      case "Stats":
        return (
          <ButtomBarNavLink
            isActive={isActive}
            label="Stats"
            navigateTo={navigateTo}
            screenName="Stats"
            icon={
              <BarChartBig
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
        {bottomTabBarLinks.map((link) => {
          return (
            <ButtomBarNavLink
              isActive={currentRoute.name === link.screenName}
              label={link.label}
              navigateTo={navigateTo}
              screenName={link.screenName}
              icon={
                <link.icon
                  color={
                    currentRoute.name === link.screenName
                      ? theme.colors.activeIconColor
                      : theme.colors.secondaryTextColor
                  }
                />
              }
              key={link.screenName}
            />
          );
        })}

        {/* {routes.map((route: any, i: number) => {
          return renderTabBarLinks(route.name, index === i);
        })} */}
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
    width: "85%",
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
    borderRadius: hp(1.5),
    paddingHorizontal: wp(10),
  },
});
