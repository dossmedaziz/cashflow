import {
  ActivityIndicator,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from "react-native";
import React from "react";
import {
  ProjectSavingCard,
  RecentTransactionList,
  SafeAreaWrapper,
} from "@/components";
import { hp, wp } from "@/helpers/ruler";
import { useTheme } from "@/theme/useTheme";
import useUserStore from "@/stores/useUserStore";
import TransactionService from "@/services/transactionService";
import useTransactionStore from "@/stores/useTransactionStore";
import { StatusBar } from "expo-status-bar";
import {
  ArrowUp,
  Bitcoin,
  ChevronDown,
  ChevronUp,
  HandCoins,
} from "lucide-react-native";
import CircularProgress from "react-native-circular-progress-indicator";

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
      <ScrollView
        style={[
          styles.container,
          { backgroundColor: theme.colors.secondaryBgColor },
        ]}
      >
        <View style={styles.topSide}>
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

        <View
          style={{
            backgroundColor: theme.colors.primaryBgColor,
            height: hp(100),
            borderTopStartRadius: hp(5),
            borderTopEndRadius: hp(5),
            paddingTop: hp(2.5),
            paddingHorizontal: wp(5),
          }}
        >
          <ProjectSavingCard />

          {isLoading ? (
            <ActivityIndicator
              size="large"
              color={theme.colors.secondaryBgColor}
            />
          ) : (
            <View
              style={{
                marginTop: hp(2),
              }}
            >
              <RecentTransactionList transactions={transactions} />
            </View>
          )}
        </View>
      </ScrollView>
    </SafeAreaWrapper>
  );
};

export default HomeScreen;

const styles = StyleSheet.create({
  container: {
    // flex: 1, paddingHorizontal: wp(5),
    // paddingTop: hp(4
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
  randomProjectCard: {
    height: hp(20),
    width: "100%",
    borderRadius: hp(4),
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
});
