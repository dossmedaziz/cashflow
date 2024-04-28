import {
  View,
  Text,
  FlatList,
  Animated,
  Touchable,
  Pressable,
} from "react-native";
import React, { useRef, useState } from "react";
import slides from "./slides";
import OnboardingItem from "./OnboardingItem";

import Paginator from "./Paginator";
const Onboarding = () => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const scrollX = useRef(new Animated.Value(0)).current;

  const slidesRef = useRef(null);

  const viewableItemsChanged = useRef(({ viewableItems }: any) => {
    setCurrentIndex(viewableItems[0].index);    
  }).current;

  const viewConfig = useRef({ viewAreaCoveragePercentThreshold: 50 }).current;

  return (
    <View style={{ flex: 1 }}>
      <FlatList
        data={slides}
        renderItem={({ item }) => <OnboardingItem item={item} />}
        keyExtractor={(item) => item.id}
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
      <Paginator data={slides} scrollX={scrollX} />
      <Pressable
        onPress={() => {
          if (currentIndex < slides.length - 1) {
            slidesRef.current.scrollToIndex({ index: currentIndex + 1 });
          } else {
            console.log("Last slide");
          }
        }}
        style={{
          position: "absolute",
          bottom: 20,
          right: 20,
          backgroundColor: "#493d8a",
          padding: 16,
          borderRadius: 40,
        }}
      >
        <Text style={{ color: "white", fontSize: 16 }}>
          {currentIndex === slides.length - 1 ? "Let's Go" : "Next"}
        </Text>
      </Pressable>
    </View>
  );
};

export default Onboarding;
