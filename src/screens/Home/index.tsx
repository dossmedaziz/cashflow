import { ScrollView, StyleSheet, Text, View ,ActivityIndicator} from "react-native";
import React from "react";
import {
  HomeScreenCard,
  RecentTransactionList,
  SafeAreaWrapper,
} from "@/components";
import { hp, wp } from "@/helpers/ruler";
import { useTheme } from "@/theme/useTheme";
import useUserStore from "@/stores/useUserStore";
import TransactionService from "@/services/transactionService";
import useTransactionStore from "@/stores/useTransactionStore";

const HomeScreen = () => {
  // @ts-ignore
    const { theme } = useTheme();
    const { user } = useUserStore();
    const [isLoading, setIsLoading] = React.useState(true);
    const {transactions , addTransactions} = useTransactionStore();

    React.useEffect(() => {
            TransactionService.getUserTransactions()
                .then((response) => {
                    const {data} = response;
                    addTransactions(data)
                    setIsLoading(false)
                })
                .catch((error) => {
                    console.log("error" , error);
                }
            )
    }, []);

    return (
    <SafeAreaWrapper>
      <ScrollView style={styles.container}>
        <View>
          <Text style={[styles.greeting, { color: theme.colors.labelColor }]}>
            Welcome Back
          </Text>
          <Text
            style={[
              styles.connectedUserName,
              { color: theme.colors.primaryTextColor },
            ]}
          >
            {user?.lastName}.
          </Text>
        </View>
        <View
          style={{
            alignItems: "center",
            marginTop: hp(5),
          }}
        >
          <HomeScreenCard />
          <View
            style={{
              height: 1,
              width: "100%",
              backgroundColor: theme.colors.labelColor,
              marginVertical: hp(2),
            }}
          />
            {
                isLoading ? <ActivityIndicator size="large" color={theme.colors.secondaryBgColor} /> : <RecentTransactionList transactions={transactions} />
            }
        </View>
      </ScrollView>
    </SafeAreaWrapper>
  );
};

export default HomeScreen;

const styles = StyleSheet.create({
  container: { flex: 1, paddingHorizontal: wp(5), paddingTop: hp(4) },
  greeting: { fontSize: hp(2) },
  connectedUserName: { fontSize: hp(3), fontWeight: "bold" },
});
