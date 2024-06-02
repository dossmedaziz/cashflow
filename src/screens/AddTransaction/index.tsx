import { View, Text, ScrollView, Platform, Pressable } from "react-native";
import React from "react";
import { CashFlowButton, CashFlowInput, SafeAreaWrapper } from "@/components";
import { TransactionForm, TransactionType } from "@/types";
import TransactionService from "@/services/transactionService";
import { Controller, useForm } from "react-hook-form";
import { useTheme } from "@/theme/useTheme";
import { hp, wp } from "@/helpers/ruler";
import {
  CalendarIcon,
  Checkicon,
  DollarIcon,
  LeftArrowIcon,
  TextIcon,
} from "@/icons";
import DateTimePicker, {
  DateTimePickerEvent,
} from "@react-native-community/datetimepicker";
import moment from "moment";
import RNPickerSelect from "react-native-picker-select";
import Toast from "react-native-toast-message";
import useTransactionStore from "@/stores/useTransactionStore";

const AddTransactionScreen = ({ navigation }: any) => {
  const { theme } = useTheme();
  const [showDatePicker, setShowDatePicker] = React.useState(false);
  const [transactionTypeOptions, setTransactionTypeOptions] = React.useState(
    []
  );
  const { addTransaction } = useTransactionStore();
  const [transactionCategoryOptions, setTransactionCategoryOptions] =
    React.useState([]);
  React.useEffect(() => {
    TransactionService.getTransactionTypes()
      .then((response) => {
        let { data } = response;
        let options = data.map((item: TransactionType) => {
          return {
            label: item.name,
            value: item.id,
          };
        });
        setTransactionTypeOptions(options);
      })
      .catch((error) => {
        console.error(error);
      });
  }, []);

  const handleOnTransactionTypeChanged = (value: string) => {
    if (!value) return;
    TransactionService.getTransactionCategoriesByType(Number(value))
      .then((response) => {
        let { data } = response;
        let options = data.map((item: TransactionType) => {
          return {
            label: item.name,
            value: item.id,
          };
        });
        setTransactionCategoryOptions(options);
      })
      .catch((error) => {
        console.error(error);
      });
  };

  const {
    control,
    handleSubmit,
    formState: { errors },
    setValue,
    resetField,
    reset,
  } = useForm<TransactionForm>();

  const handleOnChange = (
    { type }: DateTimePickerEvent,
    selectedDate?: Date
  ): void => {
    if (type === "set" && selectedDate) {
      if (Platform.OS === "android") {
        setShowDatePicker(false);
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
    TransactionService.createTransaction(data)
      .then((response) => {
        let { data } = response;
        addTransaction(data);
        Toast.show({
          type: "success",
          text1: "Transaction added successfully",
        });

        setValue("description", "");
        resetField("transactionCategoryId");
        // reset the form
        navigation.goBack();
      })
      .catch((error) => {
        console.error(error);
      });
  };
  return (
    <SafeAreaWrapper>
      <ScrollView>
        <View
          style={{
            flexDirection: "row",
            justifyContent: "space-between",
            paddingHorizontal: wp(5),
            marginTop: hp(2.5),
          }}
        >
          <Pressable
            onPress={() => {
              navigation.goBack();
            }}
          >
            <LeftArrowIcon />
          </Pressable>
          <Text
            style={{ fontSize: 20, fontWeight: "bold", alignSelf: "center" }}
          >
            Add Transaction
          </Text>
          <Pressable onPress={handleSubmit(onSubmit)}>
            <Checkicon />
          </Pressable>
        </View>
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
                  borderColor: errors.description
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
                      errors.description
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
                    borderColor: errors.transactionDate
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
                        errors.transactionDate
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
        <View
          style={{
            width: wp(85),
            alignSelf: "center",
            marginVertical: hp(2.5),
          }}
        >
          <View
            style={{
              borderWidth: 1,
              alignSelf: "center",
              width: "100%",
              borderColor: theme.colors.labelColor,
              borderRadius: hp(1.5),
            }}
          >
            <RNPickerSelect
              onValueChange={handleOnTransactionTypeChanged}
              items={transactionTypeOptions}
              placeholder={{
                label: "Select Transaction Type",
                value: null,
              }}
            />
          </View>
        </View>
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
              <View
                style={{
                  borderWidth: 1,
                  width: "100%",
                  borderColor: errors.transactionCategoryId
                    ? theme.colors.errorTextColor
                    : theme.colors.labelColor,
                  borderRadius: hp(1.5),
                }}
              >
                <RNPickerSelect
                  onValueChange={onChange}
                  items={transactionCategoryOptions}
                  placeholder={{
                    label: "Select Transaction Type",
                    value: null,
                  }}
                />
              </View>
            </View>
          )}
          name="transactionCategoryId"
        />
      </ScrollView>
    </SafeAreaWrapper>
  );
};

export default AddTransactionScreen;
