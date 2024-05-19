import { Pressable, StyleSheet, Text, View } from "react-native";
import React from "react";
import { useTheme } from "@/theme/useTheme";
import { HomeIcon, PlusIcon, UserIcon } from "@/icons";
import { hp, wp } from "@/helpers/ruler";
const ButtomNavigationBar = ({ state, descriptors, navigation }: any) => {
  const { theme } = useTheme();
  const { index, routes } = state;

  console.log(routes);

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
    <View style={styles.container}>
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
              fontWeight: "normal",
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
