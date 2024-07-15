import { Pressable, StyleSheet, Text, View, Alert } from "react-native";
import React from "react";
import transactionService from "@/services/transactionService";
import { TransactionTypeIdEnum } from "@/enums";
import { useNavigation } from "@react-navigation/native";
import { Plus, Trash } from "lucide-react-native";
import { hp, wp } from "@/helpers/ruler";
import { Transaction } from "@/types";
import { FlashList } from "@shopify/flash-list";
import TransactionListItem from "@/components/RecentTransaction/TransactionListItem";
import Swipeable from "react-native-gesture-handler/Swipeable";
import { useTheme } from "@/theme/useTheme";
const ExpenseTabView = () => {
  const [transactions, setTransactions] = React.useState<Transaction[]>([]);
  const navigation = useNavigation();

  const { theme } = useTheme();
  const renderItems = (item: Transaction) => {
    return (
      <Swipeable renderLeftActions={(props) => <LeftActions item={item} />}>
        <TransactionListItem key={item.id} transaction={item} />
      </Swipeable>
    );
  };

  const LeftActions = ({ item }: { item: Transaction }) => {
    return (
      <View
        style={{
          width: wp(20),
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        <Pressable
          onPress={() => {
            Alert.alert(
              "Deleteing Transaction",
              "Are you sure you want to delete this transaction?",
              [
                {
                  text: "Cancel",
                  onPress: () => null,
                  style: "cancel",
                },
                {
                  text: "OK",
                  onPress: () => {
                    transactionService.deleteTransaction(item.id).then(() => {
                      setTransactions((prev) =>
                        prev.filter((transaction) => transaction.id !== item.id)
                      );
                      //swip back the item
                    });
                  },
                },
              ],
              {
                cancelable: true,
                onDismiss: () => null,
              }
            );
          }}
        >
          <Trash size={24} color={"red"} />
        </Pressable>
      </View>
    );
  };

  React.useEffect(() => {
    transactionService
      .transactionsByTransactionType(TransactionTypeIdEnum.EXPENSE)
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
          All Expenses
        </Text>
        <Pressable
          onPress={() => {
            navigation.navigate("AddTransaction", {
              transactionType: TransactionTypeIdEnum.EXPENSE,
            });
          }}
        >
          <Plus size={hp(3.5)} color={theme.colors.primaryTextColor} />
        </Pressable>
      </View>

      {transactions.length > 0 ? (
        <FlashList
          data={transactions}
          estimatedItemSize={100}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => renderItems(item)}
          ListFooterComponent={() => <View style={{ height: hp(10) }} />}
        />
      ) : (
        <Text>No expenses found</Text>
      )}
    </View>
  );
};

export default ExpenseTabView;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingHorizontal: wp(2.5),
    paddingVertical: hp(2.5),
  },
  header: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: hp(2.5),
  },
});
