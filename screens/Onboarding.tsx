import {
  View,
  Text,
  FlatList,
  Animated,
  Pressable,
  StyleSheet,
} from "react-native";
import React, { useRef, useState } from "react";
import slides from "../data/slides";

import { Paginator, OnboardingItem, CashFlowButton } from "../components";
import { hp, moderateScale, wp } from "../helpers/ruler";
import { useTheme } from "../theme/useTheme";
const Onboarding = () => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const scrollX = useRef(new Animated.Value(0)).current;

  const slidesRef = useRef(null);

  const { theme } = useTheme();

  const viewableItemsChanged = useRef(({ viewableItems }: any) => {
    setCurrentIndex(viewableItems[0].index);
  }).current;

  const viewConfig = useRef({ viewAreaCoveragePercentThreshold: 50 }).current;

  type SlideItemType = {
    id: string;
    title: string;
    description: string;
    image: any;
  };
  return (
    <View style={{ flex: 1, backgroundColor: theme.colors.primaryBgColor }}>
      <View style={styles.slidesContainer}>
        <FlatList
          data={slides}
          renderItem={({ item }) => <OnboardingItem item={item} />}
          keyExtractor={(item: SlideItemType) => item.id}
          horizontal
          showsHorizontalScrollIndicator={false}
          pagingEnabled
          bounces={false}
          onScroll={Animated.event(
            [{ nativeEvent: { contentOffset: { x: scrollX } } }],
            { useNativeDriver: false }
          )}
          scrollEventThrottle={32}
          onViewableItemsChanged={viewableItemsChanged}
          viewabilityConfig={viewConfig}
          ref={slidesRef}
        />
      </View>
      <Paginator data={slides} scrollX={scrollX} />
      <CashFlowButton
        label={currentIndex === slides.length - 1 ? "Join" : "Next"}
        onPress={() => {
          if (currentIndex < slides.length - 1) {
            slidesRef.current.scrollToIndex({ index: currentIndex + 1 });
          } else {
            console.log("Navigate to the other screen");
          }
        }}
        style={{
          position: "absolute",
          bottom: hp(8),
          alignSelf: "center",
          borderRadius: wp(3),
          width: wp(60),
          height: hp(8),
        }}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  slidesContainer: {
    flex: 0.7,
  },
});
export default Onboarding;
