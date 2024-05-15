import { Pressable, StyleSheet, Text, View } from "react-native";
import React from "react";
import { useTheme } from "@/theme/useTheme";
import { HomeIcon, PlusIcon, UserIcon } from "@/icons";
import { hp, wp } from "@/helpers/ruler";
const ButtomNavigationBar = ({ state, descriptors, navigation }: any) => {
  const { theme } = useTheme();
  const { index } = state;

  // state.routes.map((route: any, index: number) => {
  //   console.log(descriptors);
  // });

  // const icons =[
  //   {
  //     name: "Home",
  //     icon: <HomeIcon color={theme.colors.secondaryTextColor} />,
  //   },
  //   {
  //     name: "Add",
  //     icon: <PlusIcon color={theme.colors.secondaryTextColor} />,
  //   },
  //   {
  //     name: "Profile",
  //     icon: <UserIcon color={theme.colors.primaryBgColor} />,
  //   },
  // ]
  return (
    <View
      style={[
        styles.container,
        { backgroundColor: theme.colors.primaryBgColor },
      ]}
    >
      <View
        style={[
          styles.links,
          { backgroundColor: theme.colors.secondaryBgColor },
        ]}
      >
        <Pressable
          style={{
            alignItems: "center",
          }}
          onPress={() => navigation.navigate("HomeStack")}
        >
          <HomeIcon
            color={
              index == 0
                ? theme.colors.activeIconColor
                : theme.colors.secondaryTextColor
            }
          />
          <Text
            style={{
              color:
                index == 0
                  ? theme.colors.activeIconColor
                  : theme.colors.secondaryTextColor,
              fontSize: 12,
              fontWeight: "bold",
            }}
          >
            Home
          </Text>
        </Pressable>
        <Pressable
          style={{
            alignItems: "center",
          }}
          onPress={() => navigation.navigate("AddTransaction")}
        >
          <PlusIcon
            color={
              index == 1
                ? theme.colors.activeIconColor
                : theme.colors.secondaryTextColor
            }
          />
          <Text
            style={{
              color:
                index == 1
                  ? theme.colors.activeIconColor
                  : theme.colors.secondaryTextColor,
              fontSize: 12,
              fontWeight: "bold",
            }}
          >
            Add
          </Text>
        </Pressable>
        <Pressable
          style={{
            alignItems: "center",
          }}
          onPress={() => navigation.navigate("Porfile")}
        >
          <UserIcon
            color={
              index == 2
                ? theme.colors.activeIconColor
                : theme.colors.secondaryTextColor
            }
          />
          <Text
            style={{
              color:
                index == 2
                  ? theme.colors.activeIconColor
                  : theme.colors.secondaryTextColor,
              fontSize: 12,
              fontWeight: "bold",
            }}
          >
            Profile
          </Text>
        </Pressable>
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
  },
  links: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    width: "80%",
    height: "80%",
    borderRadius: hp(3),
    paddingHorizontal: wp(10),
  },
});
