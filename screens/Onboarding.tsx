import {
    View,
    Text,
    FlatList,
    Animated,
    Touchable,
    Pressable,
    StyleSheet,
  } from "react-native";
  import React, { useRef, useState } from "react";
  import slides from "../data/slides";
  import OnboardingItem from "../components/OnboardingItem";
  
  import Paginator from "../components/Paginator";
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
      <View style={{ flex: 1 }}>
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
        <Pressable
          onPress={() => {
            if (currentIndex < slides.length - 1) {
              slidesRef.current.scrollToIndex({ index: currentIndex + 1 });
            } else {
              console.log("Navigate to the other screen");
            }
          }}
          style={{
            position: "absolute",
            bottom: 20,
            alignSelf: "center",
            backgroundColor: theme.colors.primaryButtonColor,
            padding: 16,
            borderRadius: 10,
            width: wp(60),
            height: hp(8),
            alignItems: "center",
          }}
        >
          <Text
            style={{
              color: theme.colors.secondaryTextColor,
              fontSize: moderateScale(20),
              fontWeight: "bold",
            }}
          >
            {currentIndex === slides.length - 1 ? "Join" : "Next"}
          </Text>
        </Pressable>
      </View>
    );
  };
  
  const styles = StyleSheet.create({
    container: {
      flex: 1,
    },
    slidesContainer: {
      flex: 0.7,
    },
  });
  export default Onboarding;
  