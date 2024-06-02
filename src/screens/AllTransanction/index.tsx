import {
  Image,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from "react-native";
import React from "react";
import { SafeAreaWrapper } from "@/components";
import { hp, wp } from "@/helpers/ruler";
import TransactionListItem from "@/components/RecentTransaction/TransactionListItem";
import { LeftArrowIcon } from "@/icons";
import useTransactionStore from "@/stores/useTransactionStore";

type AllTransanctionsScreenProps = {
  navigation: any;
};

const AllTransanctionsScreen = ({
  navigation,
}: AllTransanctionsScreenProps) => {
  const countTransactions = 10;
  const { transactions } = useTransactionStore();
  return (
    <SafeAreaWrapper>
      <ScrollView style={styles.container}>
        <View
          style={{
            flex: 1,
            alignItems: "center",
            marginVertical: hp(1),
            flexDirection: "row",
          }}
        >
          <Pressable
            style={{
              width: "20%",
            }}
            onPress={() => navigation.goBack()}
          >
            <LeftArrowIcon />
          </Pressable>
          <Text
            style={{
              fontSize: hp(3),
              fontWeight: "bold",
            }}
          >
            All Transactions
          </Text>
        </View>

        <View
          style={{
            width: "100%",
            paddingBottom: hp(16),
          }}
        >
          {countTransactions > 0 ? (
            transactions.map((transaction, index) => {
              return (
                <TransactionListItem key={index} transaction={transaction} />
              );
            })
          ) : (
            <Image
              source={require("@assets/images/empty-box.png")}
              style={[styles.image, { resizeMode: "contain" }]}
            />
          )}
        </View>
      </ScrollView>
    </SafeAreaWrapper>
  );
};

export default AllTransanctionsScreen;

const styles = StyleSheet.create({
  container: { flex: 1, paddingHorizontal: wp(5), paddingTop: hp(2) },
  image: {
    justifyContent: "center",
    width: wp(60),
    alignSelf: "center",
  },
});
