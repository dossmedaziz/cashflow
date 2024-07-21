import {
  ScrollView,
  StyleSheet,
  Text,
  View,
  ActivityIndicator,
} from "react-native";
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
import { StatusBar } from "expo-status-bar";
import { ArrowUp, ChevronDown, ChevronUp } from "lucide-react-native";
import { StretchOutY } from "react-native-reanimated";

const HomeScreen = () => {
  // @ts-ignore
  const { theme } = useTheme();
  const { user } = useUserStore();
  const [isLoading, setIsLoading] = React.useState(true);
  const { transactions, addTransactions } = useTransactionStore();

  React.useEffect(() => {
    TransactionService.getUserTransactions()
      .then((response) => {
        const { data } = response;
        addTransactions(data);
        setIsLoading(false);
      })
      .catch((error) => {
        console.log("error", error);
      });
  }, []);

  return (
    <SafeAreaWrapper>
      <StatusBar
        style="light"
        backgroundColor={theme.colors.secondaryBgColor}
      />
      <ScrollView style={styles.container}>
        <View
          style={[
            styles.topSide,
            { backgroundColor: theme.colors.secondaryBgColor },
          ]}
        >
          <View>
            <Text
              style={[
                styles.greeting,
                { color: theme.colors.secondaryTextColor },
              ]}
            >
              Welcome Back
            </Text>
            <Text
              style={[
                styles.connectedUserName,
                { color: theme.colors.secondaryTextColor },
              ]}
            >
              {user?.lastName}.
            </Text>
          </View>
          <View>
            <View
              style={{
                width: "100%",
                flexDirection: "row",
                justifyContent: "space-evenly",
                marginTop: hp(2),
                alignItems: "baseline",
                overflow: "hidden",
              }}
            >
              <Text
                style={{
                  color: theme.colors.secondaryTextColor,
                  fontSize: hp(2),
                  fontWeight: "normal",
                }}
              >
                TND
              </Text>
              <Text
                style={{
                  color: theme.colors.secondaryTextColor,
                  fontSize: hp(4),
                  fontWeight: "bold",
                }}
              >
                {user?.balance}
              </Text>
            </View>

            <View style={styles.cardsContainer}>
              <View style={styles.trasactionCard}>
                <View
                  style={{
                    flexDirection: "row",
                    alignItems: "flex-end",
                  }}
                >
                  <ChevronUp
                    size={hp(2.5)}
                    color={theme.colors.successTextColor}
                  />
                  <Text
                    style={{
                      color: theme.colors.secondaryTextColor,
                      fontSize: hp(2),
                    }}
                  >
                    Icome
                  </Text>
                </View>
                <Text
                  style={{
                    fontSize: hp(2),
                    color: theme.colors.secondaryTextColor,
                  }}
                >
                  + {user?.thisMonthIncome}
                </Text>
              </View>
              <View
                style={[
                  styles.seprator,
                  { backgroundColor: theme.colors.primaryBgColor },
                ]}
              />
              <View style={styles.trasactionCard}>
                <View
                  style={{
                    flexDirection: "row",
                    alignItems: "flex-end",
                  }}
                >
                  <ChevronDown
                    size={hp(2.5)}
                    color={theme.colors.errorTextColor}
                  />
                  <Text
                    style={{
                      color: theme.colors.secondaryTextColor,
                      fontSize: hp(2),
                    }}
                  >
                    Expense
                  </Text>
                </View>
                <Text
                  style={{
                    fontSize: hp(2),
                    color: theme.colors.secondaryTextColor,
                  }}
                >
                  - {user?.thisMonthExpense}
                </Text>
              </View>
            </View>
          </View>
        </View>
      </ScrollView>
    </SafeAreaWrapper>
  );
};

export default HomeScreen;

const styles = StyleSheet.create({
  container: {
    // flex: 1, paddingHorizontal: wp(5),
    // paddingTop: hp(4)
  },
  greeting: {
    fontSize: hp(2),
  },
  connectedUserName: {
    fontSize: hp(3),
    fontWeight: "bold",
  },
  topSide: {
    width: "100%",
    height: hp(30),
    paddingHorizontal: wp(5),
  },
  cardsContainer: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginTop: hp(2),
  },
  trasactionCard: {
    alignItems: "center",
    backgroundColor: "rgba(0, 0, 0, 0.25)",
    width: "35%",
    borderRadius: hp(1.5),
    justifyContent: "center",
  },
  seprator: {
    width: 1,
    height: "100%",
  },
});
