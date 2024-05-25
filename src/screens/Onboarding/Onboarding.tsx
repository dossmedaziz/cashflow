import {
  View,
  FlatList,
  Animated,
  StyleSheet,
} from "react-native";
import React, { useRef, useState } from "react";
import slides from "@/data/slides";
import { Paginator, OnboardingItem, CashFlowButton } from "@/components";
import { hp, wp } from "@/helpers/ruler";
import { useNavigation } from "@react-navigation/native";
import {SafeAreaWrapper} from '@/components'
import useUserStore from "@/stores/useUserStore";

const Onboarding = () => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const scrollX = useRef(new Animated.Value(0)).current;

  const slidesRef = useRef(null);

  const navigateTo = useNavigation();
const {updateOnBoarding} = useUserStore();
  const navToSignIn = () => {
    navigateTo.navigate("SignIn");
    updateOnBoarding(true);
  };

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
    <SafeAreaWrapper>
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
            navToSignIn()
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
    </SafeAreaWrapper>
  );
};

const styles = StyleSheet.create({
  slidesContainer: {
    flex: 0.7,
  },
});
export default Onboarding;
