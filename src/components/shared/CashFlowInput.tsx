import { View, TextInput } from "react-native";
import React from "react";
import { hp, wp } from "@/helpers/ruler";

type CashFlowInputProps = {
  style?: object;
  placeholder: string;
  placeholderTextColor: string;
  prefix?: React.ReactNode;
  suffix?: React.ReactNode;
  secureTextEntry?: boolean;
};

const CashFlowInput = ({
  style,
  placeholder,
  placeholderTextColor,
  prefix,
  suffix,
  secureTextEntry = false,
}: CashFlowInputProps) => {
  return (
    <>
      <TextInput
        style={{ ...style }}
        placeholder={placeholder}
        placeholderTextColor={placeholderTextColor}
        secureTextEntry={secureTextEntry}
      />
      {prefix && (
        <View
          style={{
            position: "absolute",
            top: hp(1.6),
            left: wp(3),
            width: wp(7),
          }}
        >
          {prefix}
        </View>
      )}
      {suffix && (
        <View
          style={{
            position: "absolute",
            top: hp(1.6),
            right: wp(3),
            width: wp(7),
          }}
        >
          {suffix}
        </View>
      )}
    </>
  );
};

export default CashFlowInput;
