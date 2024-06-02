import {
  View,
  Text,
  ScrollView,
  Da,
  Platform,
  Pressable,
  TouchableOpacity,
} from "react-native";
import React from "react";
import { CashFlowInput, SafeAreaWrapper } from "@/components";
import { TransactionForm, TransactionType } from "@/types";
import transactionService from "@/services/transactionService";
import { Controller, useForm } from "react-hook-form";
import { useTheme } from "@/theme/useTheme";
import { hp, wp } from "@/helpers/ruler";
import { CalendarIcon, DollarIcon, TextIcon } from "@/icons";
import DateTimePicker, {
  DateTimePickerEvent,
} from "@react-native-community/datetimepicker";
import moment from "moment";
const AddTransactionScreen = () => {
  const { theme } = useTheme();
  const [showDatePicker, setShowDatePicker] = React.useState(false);
  const [transactionTypes, setTransactionTypes] = React.useState<
    TransactionType[]
  >([]);
  React.useEffect(() => {
    transactionService
      .getTransactionTypes()
      .then((response) => {
        setTransactionTypes(response.data);
      })
      .catch((error) => {
        console.error(error);
      });
  }, []);

  const {
    control,
    handleSubmit,
    formState: { errors },
    setValue,
  } = useForm<TransactionForm>();

  const handleOnChange = (
    { type }: DateTimePickerEvent,
    selectedDate?: Date
  ): void => {
    if (type === "set" && selectedDate) {
      if (Platform.OS === "android") {
        setShowDatePicker(false);
        console.log("selectedDate", selectedDate);

        setTimeout(() => {
          setValue(
            "transactionDate",
            moment(selectedDate).format("YYYY-MM-DD")
          );
        }, 0);
      }
    } else {
      setShowDatePicker(false);
    }
  };
  const onSubmit = (data: TransactionForm) => {
    console.log(data);
  };
  return (
    <SafeAreaWrapper>
      <ScrollView>
        <Text style={{ fontSize: 20, fontWeight: "bold", alignSelf: "center" }}>
          Add Transaction
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
                  borderColor: errors.amount
                    ? theme.colors.errorTextColor
                    : theme.colors.labelColor,
                  borderRadius: hp(1.5),
                }}
                placeholder="Amount"
                placeholderTextColor={theme.colors.labelColor}
                keyboardType="number-pad"
                onBlur={onBlur}
                onChange={onChange}
                prefix={
                  <DollarIcon
                    color={
                      errors.amount
                        ? theme.colors.errorTextColor
                        : theme.colors.secondaryBgColor
                    }
                  />
                }
              />
            </View>
          )}
          name="amount"
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
                  borderColor: errors.amount
                    ? theme.colors.errorTextColor
                    : theme.colors.labelColor,
                  borderRadius: hp(1.5),
                }}
                placeholder="Description"
                placeholderTextColor={theme.colors.labelColor}
                onBlur={onBlur}
                onChange={onChange}
                multiline={true}
                prefix={
                  <TextIcon
                    color={
                      errors.amount
                        ? theme.colors.errorTextColor
                        : theme.colors.secondaryBgColor
                    }
                  />
                }
              />
            </View>
          )}
          name="description"
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
                marginVertical: hp(2.5),
              }}
            >
              <Pressable
                onPress={() => {
                  if (setShowDatePicker) {
                    setShowDatePicker(false);
                  }
                  console.log("show date pickerrr");

                  setTimeout(() => {
                    setShowDatePicker(true);
                  }, 0);
                }}
              >
                <CashFlowInput
                  style={{
                    borderWidth: 1,
                    alignSelf: "center",
                    paddingVertical: hp(1.8),
                    paddingHorizontal: wp(15),
                    width: "100%",
                    borderColor: errors.amount
                      ? theme.colors.errorTextColor
                      : theme.colors.labelColor,
                    borderRadius: hp(1.5),
                  }}
                  placeholder="Transaction Date"
                  placeholderTextColor={theme.colors.labelColor}
                  onBlur={onBlur}
                  onChange={onChange}
                  multiline={true}
                  editable={false}
                  value={value ? value.toString() : ""}
                  prefix={
                    <CalendarIcon
                      color={
                        errors.amount
                          ? theme.colors.errorTextColor
                          : theme.colors.secondaryBgColor
                      }
                    />
                  }
                />
              </Pressable>
            </View>
          )}
          name="transactionDate"
        />
        {showDatePicker && (
          <Controller
            control={control}
            render={({ field: { onChange, onBlur, value } }) => (
              <DateTimePicker
                mode={"date"}
                display={"spinner"}
                value={value ? new Date(value) : new Date()}
                onChange={handleOnChange}
                maximumDate={new Date()}
              />
            )}
            name={"transactionDate"}
          />
        )}
      </ScrollView>
    </SafeAreaWrapper>
  );
};

export default AddTransactionScreen;
