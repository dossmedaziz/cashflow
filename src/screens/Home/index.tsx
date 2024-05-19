import { ScrollView, StyleSheet, Text, View } from "react-native";
import React from "react";
import { SafeAreaWrapper } from "@/components";

const HomeScreen = () => {
  return (
    <SafeAreaWrapper>
      <ScrollView style={{ flex: 1 }}>
        {/* {Array.from({ length: 20 }).map((_, index) => (
          <View
            key={index}
            style={{ height: 100, marginBottom: 20, backgroundColor: "blue" }}
          >
            <Text>{index}</Text>
          </View>
        ))} */}
      </ScrollView>
    </SafeAreaWrapper>
  );
};

export default HomeScreen;

const styles = StyleSheet.create({});
