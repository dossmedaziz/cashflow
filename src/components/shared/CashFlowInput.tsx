import { View, TextInput, KeyboardTypeOptions } from "react-native";
import React from "react";
import { hp, wp } from "@/helpers/ruler";

type CashFlowInputProps = {
  style?: object;
  placeholder: string;
  placeholderTextColor: string;
  prefix?: React.ReactNode;
  suffix?: React.ReactNode;
  secureTextEntry?: boolean;
  onChange?: (text: string) => void;
  onBlur?: () => void;
  value?: string;
  keyboardType?: KeyboardTypeOptions;
  autoCapitalize?: "none";
};

const CashFlowInput = ({
  style,
  placeholder,
  placeholderTextColor,
  prefix,
  suffix,
  secureTextEntry = false,
  onChange,
  onBlur,
  value,
  keyboardType,
    autoCapitalize,
}: CashFlowInputProps) => {
  return (
    <>
      <TextInput
        style={{ ...style }}
        placeholder={placeholder}
        placeholderTextColor={placeholderTextColor}
        secureTextEntry={secureTextEntry}
        onBlur={onBlur}
        onChangeText={onChange}
        value={value}
        keyboardType={keyboardType}
        autoCapitalize={autoCapitalize || "none"}
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
