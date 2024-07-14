import { StyleSheet, Text, View } from "react-native";
import React from "react";
import { hp, wp } from "@/helpers/ruler";
import { useTheme } from "@/theme/useTheme";
import { ShopCartIcon } from "@/icons";
import { Transaction } from "@/types";
import { TransactionTypeEnum } from "@/enums";
import { TouchableOpacity } from "react-native-gesture-handler";

type TransactionListItemProps = {
  transaction: Transaction;
};
const TransactionListItem = ({ transaction }: TransactionListItemProps) => {
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
          <Text>{transaction.transactionCategory.name}</Text>
          <Text
            style={{
              color:
                transaction.transactionCategory.transactionType.name ===
                TransactionTypeEnum.INCOME
                  ? theme.colors.successTextColor
                  : theme.colors.errorTextColor,
            }}
          >
            {" "}
            {transaction.transactionCategory.transactionType.name ===
            TransactionTypeEnum.INCOME
              ? "+" + transaction.amount
              : "-" + transaction.amount}
          </Text>
        </View>
        <View
          style={{
            height: "40%",
            flexDirection: "row",
            justifyContent: "space-between",
            width: "100%",
          }}
        >
          <Text
            style={{
              maxWidth: "50%",
              overflow: "visible",
            }}
            numberOfLines={1}
            ellipsizeMode="middle"
          >
            {transaction.description}
          </Text>
          <Text> {transaction.transactionDate}</Text>
        </View>
      </View>
    </View>
  );
};

export default TransactionListItem;

const styles = StyleSheet.create({});
