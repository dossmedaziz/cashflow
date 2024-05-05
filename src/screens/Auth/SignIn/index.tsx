import {
  Image,
  Pressable,
  StyleSheet,
  Text,
  TextInput,
  View,
} from "react-native";
import React from "react";
import { SafeAreaWrapper } from "@/components";
import { hp, wp } from "@/helpers/ruler";
import { useTheme } from "@/theme/useTheme";
import Fontisto from "@expo/vector-icons/Fontisto";
import UserIcon from "@/components/shared/UserIcon";
import EyeIcon from "@/components/shared/EyeIcon";
import colors from "@/theme/colors";
import CloseEyeIcon from "@/components/shared/CloseEyeIcon";
const SignInScreen = () => {
  const { theme } = useTheme();
  const [showPassword, setShowPassword] = React.useState(false);
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
      <View
        style={{
          width: wp(85),
          alignSelf: "center",
          marginTop: hp(5),
        }}
      >
        <TextInput
          style={{
            borderWidth: 1,
            alignSelf: "center",
            paddingVertical: 10,
            paddingHorizontal: 50,
            width: "100%",
            borderColor: theme.colors.labelColor,
            borderRadius: 10,
          }}
          placeholder="Email"
          placeholderTextColor={theme.colors.labelColor}
          secureTextEntry={showPassword}
        />
        <UserIcon
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
          {showPassword ? (
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
