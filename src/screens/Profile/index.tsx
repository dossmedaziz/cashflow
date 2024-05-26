import { Pressable, StyleSheet, Text, View } from "react-native";
import React from "react";
import { SafeAreaWrapper } from "@/components";
import useUserStore from "@/stores/useUserStore";
import AuthService from "@/services/authService";
const PorfileScreen = () => {
const {  logout , token } = useUserStore();
  return (
    <SafeAreaWrapper>
      <Text>PorfileScreen</Text>
      <Pressable
        onPress={async () => {
            if(token) {
                AuthService.logout(token.token)
                    .then((response)=>{
                    }).catch((error)=>{
                    console.log(error)
                })
            }
            logout()
        }}
      >
        <Text>Logout</Text>
      </Pressable>
    </SafeAreaWrapper>
  );
};

export default PorfileScreen;

const styles = StyleSheet.create({});
