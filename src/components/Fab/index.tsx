import React, { useImperativeHandle, forwardRef, useState } from "react";
import { Pressable, StyleSheet, View, Dimensions } from "react-native";
import { TransactionTypeEnum } from "@/enums";
import Animated, {
  interpolate,
  useAnimatedStyle,
  useSharedValue,
  withSpring,
  withTiming,
} from "react-native-reanimated";
import { ActionItem } from "./ActionItem";
import { ArrowUp, Plus, ArrowDown } from "lucide-react-native";
import { useNavigation } from "@react-navigation/native";
const { width, height } = Dimensions.get("window");

const SCREEN_WIDTH = width;
const SCREEN_HEIGHT = height;

export const SPRING_CONFIG = {
  damping: 27,
  mass: 1,
  stiffness: 300,
  overshootClamping: false,
  restSpeedThreshold: 0.001,
  restDisplacementThreshold: 0.001,
};

const AnimatedPressable = Animated.createAnimatedComponent(Pressable);
const AnimatedPlusIcon = Animated.createAnimatedComponent(Plus);

export interface FABHandle {
  closeFAB: () => void;
}

import { hp, wp } from "@/helpers/ruler";
import { useTheme } from "@/theme/useTheme";

const actionItems = [
  {
    id: 1,
    icon: ArrowDown,
    color: "green",
    title: TransactionTypeEnum.INCOME.toUpperCase(),
    screen: "AddTransaction",
  },
  {
    id: 2,
    icon: ArrowUp,
    color: "red",
    title: TransactionTypeEnum.EXPENSE.toUpperCase(),
    screen: "AddTransaction",
  },
];

export const FAB = forwardRef<FABHandle>((props, ref) => {
  const width = useSharedValue(65);
  const height = useSharedValue(65);
  const navigation = useNavigation();
  const { theme } = useTheme();
  //No need to use shared values for these
  const [iconSize, setIconSize] = useState(45);
  const [iconOpacity, setIconOpacity] = useState(1);
  const [isExpanded, setIsExpanded] = useState(false);

  const aStyle = useAnimatedStyle(() => {
    const borderRadius = interpolate(
      width.value,
      [65, SCREEN_WIDTH * 0.8],
      [35.2, 20]
    );
    return {
      width: width.value,
      height: height.value,
      borderRadius,
    };
  });

  const handlePress = () => {
    setIsExpanded(true);
    setIconSize(0);
    setIconOpacity(0);
    width.value = withTiming(SCREEN_WIDTH * 0.85, { duration: 250 });
    height.value = withTiming(360, { duration: 250 });
  };

  useImperativeHandle(ref, () => ({
    closeFAB() {
      setIsExpanded(false);
      setIconSize(45);
      width.value = withSpring(65, SPRING_CONFIG);
      height.value = withSpring(65, SPRING_CONFIG);
      setTimeout(() => {
        setIconOpacity(1);
      }, 150);
    },
  }));

  return (
    <AnimatedPressable
      style={[
        styles.fab,
        aStyle,
        { backgroundColor: theme.colors.secondaryBgColor },
      ]}
      onPress={handlePress}
    >
      <AnimatedPlusIcon
        color={theme.colors.primaryBgColor}
        size={iconSize}
        style={{ opacity: iconOpacity }}
      />
      {isExpanded && (
        <View style={styles.expandedContainer}>
          {actionItems.map((item, index) => {
            const { icon, color, title, screen } = item;
            return (
              <ActionItem
                key={index}
                icon={icon}
                color={color}
                title={title}
                onClick={() => {
                  navigation.navigate(screen, {
                    transactionType: item.id,
                  });
                  ref.current.closeFAB();
                }}
                // description={description}
              />
            );
          })}
        </View>
      )}
    </AnimatedPressable>
  );
});

const styles = StyleSheet.create({
  fab: {
    position: "absolute",
    right: wp(5),
    bottom: hp(5),
    justifyContent: "center",
    alignItems: "center",
    overflow: "hidden",
  },
  expandedContainer: {
    justifyContent: "space-evenly",
    height: "80%",
  },
});
