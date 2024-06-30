import React from "react";
import { View, Text, Pressable, StyleSheet,Dimensions } from "react-native";
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withTiming,
  FadeIn,
} from "react-native-reanimated";
import { LucideIcon } from "lucide-react-native";
import { useTheme } from "@/theme/useTheme";
import { hp, wp } from "@/helpers/ruler";

const AnimatedPressable = Animated.createAnimatedComponent(Pressable);

interface ActionItemProps {
  icon: LucideIcon;
  color: string;
  title: string;
  description?: string;
}
const SCREEN_WIDTH = Dimensions.get("window").width;

export const ActionItem: React.FC<ActionItemProps> = ({
  icon: Icon,
  color,
  title,
  description,
}) => {
  const scale = useSharedValue(1);
  const {theme} = useTheme();

  const actionItemAStyle = useAnimatedStyle(() => {
    return {
      transform: [{ scale: scale.value }],
    };
  });

  return (
    <AnimatedPressable
      entering={FadeIn.duration(100)}
      onPressIn={() => {
        scale.value = withTiming(0.95);
      }}
      onPressOut={() => {
        scale.value = withTiming(1);
      }}
      style={[styles.actionItem, actionItemAStyle]}
    >
      <View
        style={{
          ...styles.iconContainer,
          backgroundColor: color,
        }}
      >
        <Icon size={24} color="white" />
      </View>
      <View style={styles.actionTextContainer}>
        <Text style={styles.actionTitle}>{title}</Text>
       {description && <Text style={styles.actionDescription}>{description}</Text>} 
      </View>
    </AnimatedPressable>
  );
};

const styles = StyleSheet.create({
  actionItem: {
    flexDirection: "row",
    alignItems: "center",
    backgroundColor: "rgba(44, 44, 46, 0.6)",
    borderRadius: hp(2),
    padding: wp(1),
    borderWidth: wp(.5), // Adding border
    borderColor: "#3a3a3c", // Slightly lighter border color
    height: hp(12),
    width: SCREEN_WIDTH * 0.82,
  },
  iconContainer: {
    width: 40,
    height: 40,
    borderRadius: 20,
    alignItems: "center",
    justifyContent: "center",
  },
  actionTextContainer: {
    marginLeft: 10,
    rowGap: 4,
    width: "90%",
  },
  actionTitle: {
    color: "white",
    fontSize: 16,
    fontWeight: "bold",
  },
  actionDescription: {
    fontSize: 14,
    fontWeight: "500",
    lineHeight: 18,
    color: "rgba(224, 224, 224, 0.9)",
  },
});
