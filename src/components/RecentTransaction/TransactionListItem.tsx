import { StyleSheet, Text, View } from "react-native";
import React from "react";
import { hp, wp } from "@/helpers/ruler";
import { useTheme } from "@/theme/useTheme";
import { ShopCartIcon } from "@/icons";

const TransactionListItem = () => {
  const { theme } = useTheme();
  return (
    <View
      style={{
        width: "100%",
        height: hp(8),
        marginBottom: hp(1),
        borderRadius: hp(1),
        alignItems: "center",
        flexDirection: "row",
        borderBottomWidth: 1,
        borderBottomColor: theme.colors.labelColor,
      }}
    >
      <View
        style={{
          backgroundColor: theme.colors.secondaryBgColor,
          height: "80%",
          width: "15%",
          borderRadius: hp(1),
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        <ShopCartIcon color={theme.colors.primaryBgColor} />
      </View>

      <View
        style={{
          height: "100%",
          width: "85%",
          justifyContent: "center",
          paddingLeft: wp(3),
        }}
      >
        <View
          style={{
            height: "40%",
            flexDirection: "row",
            justifyContent: "space-between",
            width: "100%",
          }}
        >
          <Text>Transaction Type</Text>
          <Text> Amount</Text>
        </View>
        <View
          style={{
            height: "40%",
            flexDirection: "row",
            justifyContent: "space-between",
            width: "100%",
          }}
        >
          <Text>Shop</Text>
          <Text> Date</Text>
        </View>
      </View>
    </View>
  );
};

export default TransactionListItem;

const styles = StyleSheet.create({});
