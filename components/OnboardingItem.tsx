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
import { wp, hp, normalize, moderateScale } from "../helpers/ruler";
import FirstSlideImage from "./onboarding/FirstSlideImage";
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
      <Text style={[styles.title, { color: theme.colors.primaryTextColor }]}>
        {item.title}
      </Text>
      <Image
        source={item.image}
        style={[styles.image, { resizeMode: "contain" }]}
      />
    </View>
  );
};

export default OnboardingItem;

const styles = StyleSheet.create({
  container: {
    paddingTop: 50,
    flex: 0.4,
  },
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
