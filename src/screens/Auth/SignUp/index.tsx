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
import { CashFlowButton, CashFlowInput, SafeAreaWrapper } from "@/components";
import { hp, moderateScale, wp } from "@/helpers/ruler";
import { useTheme } from "@/theme/useTheme";
import { useNavigation } from "@react-navigation/native";

import { UserIcon, EyeIcon, CloseEyeIcon, LockIcon, EmailIcon } from "@/icons";

const SignInScreen = () => {
  const { theme } = useTheme();
  const [showPassword, setShowPassword] = React.useState(false);
  const navigateTo = useNavigation();

  const navToSignIn = () => {
    navigateTo.navigate("SignIn");
  };

  return (
    <SafeAreaWrapper>
      <ScrollView>
        <View
          style={{
            paddingTop: hp(1),
          }}
        >
          <Image
            source={require("@assets/Logo.png")}
            resizeMode="contain"
            style={styles.logo}
          />
        </View>
        <Text style={[styles.wlc, { color: theme.colors.primaryTextColor }]}>
          Join Us
        </Text>
        <Text style={[styles.desc, { color: theme.colors.labelColor }]}>
          Create your CashFlow account to start tracking your money
        </Text>
        <View
          style={{
            width: wp(85),
            alignSelf: "center",
            marginVertical: hp(2),
          }}
        >
          <CashFlowInput
            style={{
              borderWidth: 1,
              alignSelf: "center",
              paddingVertical: hp(1.8),
              paddingHorizontal: wp(15),
              width: "100%",
              borderColor: theme.colors.labelColor,
              borderRadius: hp(1.5),
            }}
            placeholder="First Name"
            placeholderTextColor={theme.colors.labelColor}
            prefix={<UserIcon color={theme.colors.secondaryBgColor} />}
          />
        </View>
        <View
          style={{
            width: wp(85),
            alignSelf: "center",
            marginVertical: hp(2),
          }}
        >
          <CashFlowInput
            style={{
              borderWidth: 1,
              alignSelf: "center",
              paddingVertical: hp(1.8),
              paddingHorizontal: wp(15),
              width: "100%",
              borderColor: theme.colors.labelColor,
              borderRadius: hp(1.5),
            }}
            placeholder="Last Name"
            placeholderTextColor={theme.colors.labelColor}
            prefix={<UserIcon color={theme.colors.secondaryBgColor} />}
          />
        </View>
        <View
          style={{
            width: wp(85),
            alignSelf: "center",
            marginVertical: hp(2),
          }}
        >
          <CashFlowInput
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
            prefix={<EmailIcon color={theme.colors.secondaryBgColor} />}
          />
        </View>
        <View
          style={{
            width: wp(85),
            alignSelf: "center",
            marginVertical: hp(2),
          }}
        >
          <CashFlowInput
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
            prefix={<LockIcon color={theme.colors.secondaryBgColor} />}
            suffix={
              <Pressable onPress={() => setShowPassword(!showPassword)}>
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
            }
          />
        </View>
        <CashFlowButton
          label="Sign Up"
          style={{
            width: wp(85),
            alignSelf: "center",
            marginVertical: hp(2),
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
            Already have an account?{" "}
            <Pressable onPress={navToSignIn}>
              <Text
                style={{
                  color: theme.colors.primaryTextColor,
                  fontWeight: "900",
                }}
              >
                Login now
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
