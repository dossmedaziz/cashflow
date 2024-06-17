import { StyleSheet, Text, View } from "react-native";
import React from "react";
import { FlashList } from "@shopify/flash-list"
import useTransactionStore from "@/stores/useTransactionStore";
import TransactionListItem from "@/components/RecentTransaction/TransactionListItem";

const AllTransactions = () => {
  const { transactions } = useTransactionStore();

  return (
    <View>
      <FlashList
        renderItem={({ item }) => <TransactionListItem transaction={item} />}
        data={transactions}
      />
    </View>
  );
};

export default AllTransactions;

const styles = StyleSheet.create({});
