import { Image, StyleSheet, Text, TextInput, View } from "react-native";
import React from "react";
import { SafeAreaWrapper } from "@/components";
import { hp, wp } from "@/helpers/ruler";
import { useTheme } from "@/theme/useTheme";

const SignInScreen = () => {
  const { theme } = useTheme();
  return (
    <SafeAreaWrapper>
      <View
        style={{
          paddingTop: hp(15),
        }}
      >
        <Image
          source={require("@assets/Logo.png")}
          //style={styles.logo}
          resizeMode="contain"
          style={styles.logo}
        />
      </View>
      <Text style={[styles.wlc, { color: theme.colors.primaryTextColor }]}>
        Welcome Back
      </Text>
      <Text style={[styles.desc, { color: theme.colors.labelColor }]}>
        Sign in to your CashFlow account and continue tracking your expenses.
        Please enter your login details
      </Text>

      <TextInput
        style={{
          borderWidth: 1,
          width: wp(80),
          alignSelf: "center",
          marginTop: hp(5),
          padding: 10,
          borderColor: theme.colors.labelColor,
          borderRadius: 10,
        }}
        placeholder="Email"
        placeholderTextColor={theme.colors.labelColor}
      />
    </SafeAreaWrapper>
  );
};

const styles = StyleSheet.create({
  logo: {
    width: wp(15),
    height: hp(15),
    alignSelf: "center",
  },
  wlc: {
    fontSize: 24,
    fontWeight: "900",
    textAlign: "center",
  },
  desc: {
    fontSize: 16,
    textAlign: "center",
    marginTop: hp(1),
    marginHorizontal: wp(10),
  },
});

export default SignInScreen;
