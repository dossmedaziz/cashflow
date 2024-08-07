import { Pressable, ScrollView, StyleSheet, Text, View } from "react-native";
import React from "react";
import { SafeAreaWrapper } from "@/components";
import { ArrowLeft, Plus, Scroll } from "lucide-react-native";
import { wp, hp } from "@/helpers/ruler";
import useTransactionStore from "@/stores/useTransactionStore";
import TabViewExample from "./TabViewExample";
import transactionService from "@/services/transactionService";
import useUserStore from "@/stores/useUserStore";
type AllTransactionsProps = {
  navigation: any;
};
const AllTransactions = ({ navigation }: AllTransactionsProps) => {
  const { addTransactionTypes } = useTransactionStore();
  const  {user} =  useUserStore()

  React.useEffect(() => {
    transactionService.getTransactionTypes().then((res) => {
      addTransactionTypes(res.data);
    });
  }, []);
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
      <View style={styles.header}>
        <Pressable onPress={() => navigation.goBack()}>
          <ArrowLeft size={hp(3.5)} color={"black"} />
        </Pressable>
        <Text style={styles.headerTitle}>All Transactions</Text>
        <Text></Text>
      </View>
      <View style={styles.profileSection}>
        <Text style={styles.balance}>{user?.balance} TND</Text>
        <Text style={styles.balanceDescription}>My Total earnings</Text>
      </View>
      <TabViewExample />
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
