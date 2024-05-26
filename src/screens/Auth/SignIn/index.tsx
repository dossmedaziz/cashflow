import {
  Image,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from "react-native";
import React from "react";
import { CashFlowButton, SafeAreaWrapper, CashFlowInput } from "@/components";
import { hp, moderateScale, wp } from "@/helpers/ruler";
import { useTheme } from "@/theme/useTheme";
import { useNavigation } from "@react-navigation/native";

import { EmailIcon, CloseEyeIcon, EyeIcon, LockIcon } from "@/icons";
import { useForm, Controller } from "react-hook-form";
import AuthService from "@/services/authService";
import useUserStore from "@/stores/useUserStore";
import {LoginResponse, SignInForm} from "@/types";

const SignInScreen = () => {
  const { theme } = useTheme();
  const {updateUser , updateToken} = useUserStore();
  const [showPassword, setShowPassword] = React.useState(false);
  const navigateTo = useNavigation();

  const navToSignUp = () => {
    navigateTo.navigate("SignUp");
  };

  const {
    control,
    handleSubmit,
    formState: { errors },
  } = useForm<SignInForm>(
    {
      defaultValues: {
          email: "dossaziz@gmail.com",
          password: "testtest",
      },
    }
  );

  const onSubmit = (data: SignInForm) => {
    const onSuccess = (response: any) => {
      const { data } = response;
      const { user , token } : LoginResponse = data;
        updateUser(user);
        updateToken(token);
    };
    const onFail = (error: any) => {
      const { status } = error.response;
      switch (status) {
        case 422:
          const response = error.response;
          let { email, password } = response.data.errors;
          control.setError("email", {
            type: "manual",
            message: email,
          });
          control.setError("password", {
            type: "manual",
            message: password,
          });
          break;
        case 401:
          alert("Login failed");
          break;
        default:
          alert("another error");
          break;
      }
    };
    AuthService.login(data.email, data.password, onSuccess, onFail);
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

        {/* started email input  */}

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
                marginVertical: hp(2.5),
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
                keyboardType="email-address"
                onBlur={onBlur}
                onChange={onChange}
                value={value}
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
        {/* {errors.email && <Text>This is required.</Text>} */}

        {/* started password input  */}

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
                marginVertical: hp(2.5),
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
                placeholder="Passwords"
                placeholderTextColor={theme.colors.labelColor}
                secureTextEntry={!showPassword}
                onBlur={onBlur}
                onChange={onChange}
                value={value}
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
          label="Sign In"
          style={{
            width: wp(85),
            alignSelf: "center",
            marginVertical: hp(2.5),
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
