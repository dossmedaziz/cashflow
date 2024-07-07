import { Pressable, ScrollView, StyleSheet, Text, View } from "react-native";
import React from "react";
import { SafeAreaWrapper } from "@/components";
import { ArrowLeft, Plus, Scroll } from "lucide-react-native";
import { wp, hp } from "@/helpers/ruler";
import useTransactionStore from "@/stores/useTransactionStore";
import TransactionListItem from "@/components/RecentTransaction/TransactionListItem";
import { TransactionTypeEnum } from "@/enums";
type AllTransactionsProps = {
  navigation: any;
};
const AllTransactions = ({ navigation }: AllTransactionsProps) => {
  const { transactions } = useTransactionStore();

  const handleCreateTransaction = (transactionType: string) => {
    switch (transactionType) {
      case TransactionTypeEnum.EXPENSE:
        navigation.navigate("AddTransaction", {
          transactionType: 1,
        });
        break;
      case TransactionTypeEnum.INCOME:
        navigation.navigate("AddTransaction", {
          transactionType: 2,
        });
        break;
      default:
        break;
    }
  };

  return (
    <SafeAreaWrapper
      style={{
        shadowColor: "#000",
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.2,
        shadowRadius: 4,
        elevation: 5, // for Android
      }}
    >
      <ScrollView>
        <View style={styles.header}>
          <Pressable onPress={() => navigation.goBack()}>
            <ArrowLeft size={hp(3.5)} color={"black"} />
          </Pressable>
          <Text style={styles.headerTitle}>All Transactions</Text>
          <Text></Text>
        </View>
        <View style={styles.profileSection}>
          <Text style={styles.balance}>tnd 1200.0</Text>
          <Text style={styles.balanceDescription}>My Total earnings</Text>
        </View>
        <View style={styles.container}>
          <View style={styles.sectionHeader}>
            <Text style={styles.sectionTitle}>All My Expenses</Text>
            <View style={styles.left}>
              <Text style={styles.seeAll}>View All</Text>
            </View>
          </View>
          <View>
            <Pressable
              style={styles.addBtn}
              onPress={() => {
                handleCreateTransaction(TransactionTypeEnum.EXPENSE);
              }}
            >
              <Plus color={"black"} />
            </Pressable>
          </View>
          <View style={styles.transactionsContainer}>
            {transactions.slice(0, 3).map((transaction, index) => {
              return (
                <TransactionListItem key={index} transaction={transaction} />
              );
            })}
          </View>
        </View>

        <View style={styles.container}>
          <View style={styles.sectionHeader}>
            <Text style={styles.sectionTitle}>All My Icomes</Text>
            <View style={styles.left}>
              <Text style={styles.seeAll}>View All</Text>
            </View>
          </View>
          <View>
            <Pressable
              style={styles.addBtn}
              onPress={() => {
                handleCreateTransaction(TransactionTypeEnum.INCOME);
              }}
            >
              <Plus color={"black"} />
            </Pressable>
          </View>
          <View style={styles.transactionsContainer}>
            {transactions.slice(0, 3).map((transaction, index) => {
              return (
                <TransactionListItem key={index} transaction={transaction} />
              );
            })}
          </View>
        </View>
      </ScrollView>
    </SafeAreaWrapper>
  );
};

export default AllTransactions;
const styles = StyleSheet.create({
  profileSection: {
    padding: wp(2),
  },
  balance: {
    fontSize: hp(3),
    fontWeight: "bold",
    textTransform: "uppercase",
  },
  balanceDescription: {
    fontSize: hp(2),
    color: "gray",
  },
  header: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    padding: wp(2),
  },
  headerTitle: {
    fontSize: hp(2.5),
    fontWeight: "bold",
  },
  container: {
    padding: wp(2),
  },
  sectionHeader: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  sectionTitle: {
    fontSize: hp(2),
    fontWeight: "bold",
  },
  left: {
    alignItems: "center",
  },
  seeAll: {
    color: "black",
    fontWeight: "bold",
    marginRight: wp(2),
  },
  addBtn: {
    padding: wp(2),
    backgroundColor: "lightgray",
    borderRadius: wp(50),
    width: wp(10),
    alignSelf: "flex-end",
  },
  transactionsContainer: {
    marginTop: hp(2),
    paddingHorizontal: wp(2),
    backgroundColor: "white",
    borderRadius: 8,
  },
});
