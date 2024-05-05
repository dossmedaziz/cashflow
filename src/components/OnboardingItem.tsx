import {
  StyleSheet,
  Text,
  View,
  Image,
  useWindowDimensions,
  ImageSourcePropType,
} from "react-native";
import React from "react";
import { useTheme } from "../theme/useTheme";
import { wp, hp, moderateScale } from "../helpers/ruler";
type OnboardingItemProps = {
  title: string;
  description: string;
  image: ImageSourcePropType;
};
const OnboardingItem = ({ item }: { item: OnboardingItemProps }) => {
  const { width } = useWindowDimensions();
  const { theme } = useTheme();
  return (
    <View style={[styles.container, { width }]}>
      <View
        style={{
          width: wp(100),
          paddingTop: hp(10),
          paddingHorizontal: wp(5),
        }}
      >
        <Text style={[styles.title, { color: theme.colors.primaryTextColor }]}>
          {item.title}
        </Text>
        <Image
          source={item.image}
          style={[styles.image, { resizeMode: "contain" }]}
        />
      </View>
    </View>
  );
};

export default OnboardingItem;

const styles = StyleSheet.create({
  container: {},
  image: {
    justifyContent: "center",
    width: wp(60),
    alignSelf: "center",
  },
  title: {
    width: wp(75),
    fontSize: moderateScale(36),
    fontWeight: "bold",
  },
});
