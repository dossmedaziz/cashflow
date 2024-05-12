import {
  Image,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from "react-native";
import React from "react";
import { CashFlowButton, CashFlowInput, SafeAreaWrapper } from "@/components";
import { hp, moderateScale, wp } from "@/helpers/ruler";
import { useTheme } from "@/theme/useTheme";
import { useNavigation } from "@react-navigation/native";

import { UserIcon, EyeIcon, CloseEyeIcon, LockIcon, EmailIcon } from "@/icons";
import { useForm, Controller } from "react-hook-form";

type SignUpForm = {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
};
const SignInScreen = () => {
  const { theme } = useTheme();
  const [showPassword, setShowPassword] = React.useState(false);
  const navigateTo = useNavigation();

  const navToSignIn = () => {
    navigateTo.navigate("SignIn");
  };

  const {
    control,
    handleSubmit,
    formState: { errors },
  } = useForm<SignUpForm>();
  const onSubmit = (data: SignUpForm) => {
    console.log(data);
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

        <Controller
          control={control}
          rules={{
            required: true,
          }}
          render={({ field: { onChange, onBlur, value } }) => (
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
                  borderColor: errors.firstName
                    ? theme.colors.errorTextColor
                    : theme.colors.labelColor,
                  borderRadius: hp(1.5),
                }}
                placeholder="First Name"
                placeholderTextColor={theme.colors.labelColor}
                onBlur={onBlur}
                onChange={onChange}
                prefix={
                  <UserIcon
                    color={
                      errors.firstName
                        ? theme.colors.errorTextColor
                        : theme.colors.secondaryBgColor
                    }
                  />
                }
              />
            </View>
          )}
          name="firstName"
        />

        <Controller
          control={control}
          rules={{
            required: true,
          }}
          render={({ field: { onChange, onBlur, value } }) => (
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
                  borderColor: errors.lastName
                    ? theme.colors.errorTextColor
                    : theme.colors.labelColor,
                  borderRadius: hp(1.5),
                }}
                placeholder="Last Name"
                placeholderTextColor={theme.colors.labelColor}
                onBlur={onBlur}
                onChange={onChange}
                prefix={
                  <UserIcon
                    color={
                      errors.lastName
                        ? theme.colors.errorTextColor
                        : theme.colors.secondaryBgColor
                    }
                  />
                }
              />
            </View>
          )}
          name="lastName"
        />

        <Controller
          control={control}
          rules={{
            required: true,
          }}
          render={({ field: { onChange, onBlur, value } }) => (
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
                  borderColor: errors.email
                    ? theme.colors.errorTextColor
                    : theme.colors.labelColor,
                  borderRadius: hp(1.5),
                }}
                placeholder="Email"
                placeholderTextColor={theme.colors.labelColor}
                onBlur={onBlur}
                onChange={onChange}
                prefix={
                  <EmailIcon
                    color={
                      errors.email
                        ? theme.colors.errorTextColor
                        : theme.colors.secondaryBgColor
                    }
                  />
                }
              />
            </View>
          )}
          name="email"
        />

        <Controller
          control={control}
          rules={{
            required: true,
          }}
          render={({ field: { onChange, onBlur, value } }) => (
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
                  borderColor: errors.password
                    ? theme.colors.errorTextColor
                    : theme.colors.labelColor,
                  borderRadius: hp(1.5),
                }}
                placeholder="Password"
                placeholderTextColor={theme.colors.labelColor}
                secureTextEntry={!showPassword}
                onBlur={onBlur}
                onChange={onChange}
                prefix={
                  <LockIcon
                    color={
                      errors.password
                        ? theme.colors.errorTextColor
                        : theme.colors.secondaryBgColor
                    }
                  />
                }
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
          )}
          name="password"
        />

        <CashFlowButton
          label="Sign Up"
          style={{
            width: wp(85),
            alignSelf: "center",
            marginVertical: hp(2),
            paddingVertical: hp(1.8),
            borderRadius: hp(1.5),
          }}
          onPress={handleSubmit(onSubmit)}
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
