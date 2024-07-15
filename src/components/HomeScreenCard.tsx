import { StyleSheet, Text, View } from "react-native";
import React from "react";
import { useTheme } from "@/theme/useTheme";
import { hp } from "@/helpers/ruler";
import useUserStore from "@/stores/useUserStore";

const HomeScreenCard = () => {
  const { theme } = useTheme();
  const { user } = useUserStore();
  return (
    <View
      style={[styles.card, { backgroundColor: theme.colors.secondaryBgColor }]}
    >
      <Text style={[styles.header, { color: theme.colors.secondaryTextColor }]}>
        Total Balance
      </Text>

      <View
        style={{
          width: "100%",
          flexDirection: "row",
          justifyContent: "space-evenly",
          marginTop: hp(2),
          alignItems: "baseline",
          overflow: "hidden",
        }}
      >
        <Text
          style={{
            color: theme.colors.secondaryTextColor,
            fontSize: hp(2),
            fontWeight: "normal",
          }}
        >
          TND
        </Text>
        <Text
          style={{
            color: theme.colors.secondaryTextColor,
            fontSize: hp(4),
            fontWeight: "bold",
          }}
        >
          {user?.balance}
        </Text>
      </View>
      <View
        style={{
          width: "100%",
          flexDirection: "row",
          justifyContent: "space-evenly",
          marginTop: hp(2),
          alignItems: "baseline",
          overflow: "hidden",
        }}
      >
        <Text
          style={{
            color: theme.colors.successTextColor,
            fontSize: hp(1.5),
            fontWeight: "bold",
          }}
        >
          + {user?.thisMonthIncome}
        </Text>
        <Text
          style={{
            color: theme.colors.errorTextColor,
            fontSize: hp(1.5),
            fontWeight: "bold",
            borderRadius: 5,
          }}
        >
          - {user?.thisMonthExpense}
        </Text>
      </View>
    </View>
  );
};

export default HomeScreenCard;

const styles = StyleSheet.create({
  card: {
    width: "90%",
    height: hp(20),
    borderRadius: hp(1.5),
    alignItems: "center",
    paddingHorizontal: hp(2),
    paddingVertical: hp(2),
  },
  header: {
    fontSize: hp(2),
    fontWeight: "bold",
  },
});
