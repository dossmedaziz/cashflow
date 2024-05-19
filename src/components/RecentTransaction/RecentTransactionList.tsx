import { Pressable, StyleSheet, Text, View } from "react-native";
import React from "react";
import { hp } from "@/helpers/ruler";
import { useNavigation } from "@react-navigation/native";
import { HomeStackParamList } from "@/navigation/types";
import TransactionListItem from "./TransactionListItem";
const RecentTransactionList = () => {
  const navigation = useNavigation();
  return (
    <View
      style={{
        width: "100%",
      }}
    >
      <View
        style={{
          flexDirection: "row",
          justifyContent: "space-between",
          alignItems: "center",
          marginBottom: hp(2),
        }}
      >
        <Text
          style={{
            fontSize: hp(2),
          }}
        >
          Recent Transactions
        </Text>
        <Pressable onPress={() => navigation.navigate("AllTransanction")}>
          <Text
            style={{
              fontWeight: "bold",
            }}
          >
            View All
          </Text>
        </Pressable>
      </View>
      <View
        style={{
          width: "100%",
          paddingBottom: hp(16),
        }}
      >
        {Array.from({ length: 10 }).map((_, index) => {
          return <TransactionListItem key={index} />;
        })}
      </View>
    </View>
  );
};

export default RecentTransactionList;

const styles = StyleSheet.create({});
