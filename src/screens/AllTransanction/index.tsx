import { ScrollView, StyleSheet, Text, View } from "react-native";
import React from "react";
import { SafeAreaWrapper } from "@/components";
import { hp, wp } from "@/helpers/ruler";
import TransactionListItem from "@/components/RecentTransaction/TransactionListItem";

const AllTransanctionsScreen = () => {
  return (
    <SafeAreaWrapper>
      <ScrollView style={styles.container}>
        <View
          style={{
            flex: 1,
            alignItems: "center",
            marginVertical: hp(5),
          }}
        >
          <Text
            style={{
              fontSize: hp(3),
              fontWeight: "bold",
            }}
          >
            AllTransanctionsScreen
          </Text>
        </View>

        <View
          style={{
            width: "100%",
            paddingBottom: hp(16),
          }}
        >
          {Array.from({ length: 100 }).map((_, index) => {
            return <TransactionListItem key={index} />;
          })}
        </View>
      </ScrollView>
    </SafeAreaWrapper>
  );
};

export default AllTransanctionsScreen;

const styles = StyleSheet.create({
  container: { flex: 1, paddingHorizontal: wp(5), paddingTop: hp(4) },
});
