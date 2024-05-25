import { ScrollView, StyleSheet, Text, View } from "react-native";
import React from "react";
import {
  HomeScreenCard,
  RecentTransactionList,
  SafeAreaWrapper,
} from "@/components";
import { hp, wp } from "@/helpers/ruler";
import { useTheme } from "@/theme/useTheme";
import useUserStore from "@/stores/useUserStore";

const HomeScreen = () => {
  const { theme } = useTheme();
    const { user } = useUserStore();

    return (
    <SafeAreaWrapper>
      <ScrollView style={styles.container}>
        <View>
          <Text style={[styles.greeting, { color: theme.colors.labelColor }]}>
            Welcome Back
          </Text>
          <Text
            style={[
              styles.conntectedUserName,
              { color: theme.colors.primaryTextColor },
            ]}
          >
            {user.lastName}.
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
          <RecentTransactionList />
        </View>
      </ScrollView>
    </SafeAreaWrapper>
  );
};

export default HomeScreen;

const styles = StyleSheet.create({
  container: { flex: 1, paddingHorizontal: wp(5), paddingTop: hp(4) },
  greeting: { fontSize: hp(2) },
  conntectedUserName: { fontSize: hp(3), fontWeight: "bold" },
});
