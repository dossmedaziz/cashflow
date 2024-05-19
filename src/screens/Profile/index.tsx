import { Pressable, StyleSheet, Text, View } from "react-native";
import React from "react";
import { SafeAreaWrapper } from "@/components";
import { useAuth } from "@/context/authContext";

const PorfileScreen = () => {
  const { logout, getConnectedUser } = useAuth();
  return (
    <SafeAreaWrapper>
      <Text>PorfileScreen</Text>
      <Pressable
        onPress={() => {
          getConnectedUser();
        }}
      >
        <Text>Logout</Text>
      </Pressable>
    </SafeAreaWrapper>
  );
};

export default PorfileScreen;

const styles = StyleSheet.create({});
