import {
  Image,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from "react-native";
import React from "react";
import { CashFlowButton, SafeAreaWrapper } from "@/components";
import { hp, moderateScale, wp } from "@/helpers/ruler";
import { useTheme } from "@/theme/useTheme";
import UserIcon from "@/components/shared/UserIcon";
import EyeIcon from "@/components/shared/EyeIcon";
import CloseEyeIcon from "@/components/shared/CloseEyeIcon";
import LockIcon from "@/components/shared/LockIcon";
import { useNavigation } from "@react-navigation/native";

const SignInScreen = () => {
  const { theme } = useTheme();
  const [showPassword, setShowPassword] = React.useState(false);
  const navigateTo = useNavigation();

  const navToSignUp = () => {
    navigateTo.navigate("SignUp");
  };

  return (
    <SafeAreaWrapper>
      <ScrollView>
        <View
          style={{
            paddingTop: hp(15),
          }}
        >
          <Image
            source={require("@assets/Logo.png")}
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
        <View
          style={{
            width: wp(85),
            alignSelf: "center",
            marginVertical: hp(2.5),
          }}
        >
          <TextInput
            style={{
              borderWidth: 1,
              alignSelf: "center",
              paddingVertical: hp(1.8),
              paddingHorizontal: wp(15),
              width: "100%",
              borderColor: theme.colors.labelColor,
              borderRadius: hp(1.5),
            }}
            placeholder="Email"
            placeholderTextColor={theme.colors.labelColor}
          />
          <UserIcon
            style={{
              position: "absolute",
              top: hp(1.6),
              left: wp(3),
              fill: theme.colors.secondaryBgColor,
            }}
          />
        </View>
        <View
          style={{
            width: wp(85),
            alignSelf: "center",
            marginVertical: hp(2.5),
          }}
        >
          <TextInput
            style={{
              borderWidth: 1,
              alignSelf: "center",
              paddingVertical: hp(1.8),
              paddingHorizontal: wp(15),
              width: "100%",
              borderColor: theme.colors.labelColor,
              borderRadius: hp(1.5),
            }}
            placeholder="Password"
            placeholderTextColor={theme.colors.labelColor}
            secureTextEntry={!showPassword}
          />
          <LockIcon
            style={{
              position: "absolute",
              top: hp(1.6),
              left: wp(3),
              fill: theme.colors.secondaryBgColor,
            }}
          />
          <Pressable
            style={{
              position: "absolute",
              top: hp(1.6),
              right: wp(3),
            }}
            onPress={() => setShowPassword(!showPassword)}
          >
            {!showPassword ? (
              <EyeIcon
                color={theme.colors.labelColor}
                width={wp(6)}
                height={hp(5)}
              />
            ) : (
              <CloseEyeIcon
                color={theme.colors.labelColor}
                width={wp(6)}
                height={hp(5)}
              />
            )}
          </Pressable>
        </View>
        <CashFlowButton
          label="Sign In"
          style={{
            width: wp(85),
            alignSelf: "center",
            marginVertical: hp(2.5),
            paddingVertical: hp(1.8),
            borderRadius: hp(1.5),
          }}
          onPress={() => {}}
        />

        <View
          style={{
            alignItems: "center",
          }}
        >
          <Text>
            Don't have an account?{" "}
            <Pressable onPress={navToSignUp}>
              <Text
                style={{
                  color: theme.colors.primaryTextColor,
                  fontWeight: "900",
                }}
              >
                Create a one
              </Text>
            </Pressable>
          </Text>
        </View>
      </ScrollView>
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
    fontSize: moderateScale(24),
    fontWeight: "900",
    textAlign: "center",
  },
  desc: {
    fontSize: moderateScale(15),
    textAlign: "center",
    marginTop: hp(1),
    marginHorizontal: wp(10),
  },
});

export default SignInScreen;
