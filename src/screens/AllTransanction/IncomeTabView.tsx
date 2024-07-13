import { Pressable, StyleSheet, Text, View } from "react-native";
import React from "react";
import useTransactionStore from "@/stores/useTransactionStore";
import transactionService from "@/services/transactionService";
import { TransactionTypeIdEnum } from "@/enums";

import { Plus } from "lucide-react-native";
import { hp, wp } from "@/helpers/ruler";
import { Transaction } from "@/types";
import { FlashList } from "@shopify/flash-list";
import TransactionListItem from "@/components/RecentTransaction/TransactionListItem";
import { useNavigation } from "@react-navigation/native";
const IcomeTabView = () => {
  const [transactions, setTransactions] = React.useState<Transaction[]>([]);
  const navigation = useNavigation();

  React.useEffect(() => {
    transactionService
      .transactionsByTransactionType(TransactionTypeIdEnum.INCOME)
      .then((res) => {
        setTransactions(res.data);
      });
  }, []);
  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text
          style={{
            fontSize: hp(2.5),
            fontWeight: "bold",
          }}
        >
          All My Icomes
        </Text>
        <Pressable
          onPress={() => {
            navigation.navigate("AddTransaction", {
              transactionType: TransactionTypeIdEnum.INCOME,
            });
          }}
        >
          <Plus size={20} color={"black"} />
        </Pressable>
      </View>

      {transactions.length > 0 ? (
        <FlashList
          data={transactions}
          estimatedItemSize={100}
          renderItem={({ item }) => (
            <TransactionListItem key={item.id} transaction={item} />
          )}
          ListFooterComponent={() => <View style={{ height: hp(10) }} />}
        />
      ) : (
        <Text>No expenses found</Text>
      )}
    </View>
  );
};

export default IcomeTabView;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingHorizontal: wp(2.5),
    paddingVertical: hp(2.5),
  },
  header: {
    flexDirection: "row",
    justifyContent: "space-between",
    borderBottomWidth: 1,
    borderBottomColor: "gray",
  },
});
