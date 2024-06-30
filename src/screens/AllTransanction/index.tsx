import {
  Image,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from "react-native";
import React, { useRef } from "react";
import { SafeAreaWrapper } from "@/components";
import { hp, wp } from "@/helpers/ruler";
import TransactionListItem from "@/components/RecentTransaction/TransactionListItem";
import { LeftArrowIcon } from "@/icons";
import useTransactionStore from "@/stores/useTransactionStore";
import SwipeableFlatList from "rn-gesture-swipeable-flatlist";
import { FABHandle, FAB } from "@/components/Fab";
import { FlashList } from "@shopify/flash-list";
import Swipeable from "react-native-gesture-handler/Swipeable";

type AllTransanctionsScreenProps = {
  navigation: any;
};

const AllTransanctionsScreen = ({
  navigation,
}: AllTransanctionsScreenProps) => {
  const countTransactions = 10;
  const { transactions } = useTransactionStore();
  const fabRef = useRef<FABHandle>(null);

  const renderLeftActions = (item: any) => {
    // Render left swipe actions for each item

    return <Text>Left Action</Text>;
  };

  const handleTouchStart = () => {
    if (fabRef.current) {
      fabRef.current.closeFAB();
    }
  };
  const renderRightActions = (item: any) => {
    return <Text>Right Action</Text>;
  };
  return (
    <View
      style={{
        flex: 1,
        paddingHorizontal: wp(5),
        paddingTop: hp(5),
      }}
    >
      <FlashList
        renderItem={({ item }) => {
          return (
            <Swipeable
              renderRightActions={renderRightActions}
              renderLeftActions={renderLeftActions}
              onSwipeableOpen={() =>
                // close others swipeable
                fabRef.current?.closeFAB()
              }
            >
              <TransactionListItem key={item.id} transaction={item} />
            </Swipeable>
          );
        }}
        onTouchStart={handleTouchStart}
        data={transactions}
        keyExtractor={(item) => item.id}
        estimatedItemSize={hp(20)}
        ListEmptyComponent={
          <Image
            source={require("@assets/images/empty-box.png")}
            style={[styles.image, { resizeMode: "contain" }]}
          />
        }
        showsVerticalScrollIndicator={false}
        ListHeaderComponent={() => {
          return (
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
          );
        }}
        ListFooterComponent={() => {
          return <View style={{ height: hp(16) }} />;
        }}
      />
      <FAB ref={fabRef} />
    </View>
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
