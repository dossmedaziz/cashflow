import { StyleSheet, Text, View } from "react-native";
import React from "react";
import { Bitcoin, HandCoins } from "lucide-react-native";
import { hp, wp } from "@/helpers/ruler";
import CircularProgress from "react-native-circular-progress-indicator";
import { useTheme } from "@/theme/useTheme";

const ProjectSavingCard = () => {
  const { theme } = useTheme();
  return (
    <View
      style={[
        styles.randomProjectCard,
        { backgroundColor: theme.colors.secondaryBgColor },
      ]}
    >
      <View
        style={{
          flexDirection: "column",
          justifyContent: "space-between",
          padding: hp(2),
          width: "35%",
          height: "100%",
          alignItems: "center",
        }}
      >
        <CircularProgress
          value={50}
          radius={hp(4)}
          activeStrokeWidth={hp(0.5)}
          inActiveStrokeWidth={hp(0.5)}
          activeStrokeColor={theme.colors.activeIconColor}
          showProgressValue={false}
          inActiveStrokeColor={theme.colors.labelColor}
          duration={1000}
          title="50%"
          titleStyle={{
            fontSize: hp(2),
          }}
        />
        <Text
          style={{
            textAlign: "center",
            color: theme.colors.secondaryTextColor,
          }}
        >
          Savings on goals
        </Text>
      </View>
      <View
        style={{
          width: ".3%",
          height: "80%",
          backgroundColor: theme.colors.primaryBgColor,
        }}
      />
      <View
        style={{
          width: "64.7%",
          height: "100%",
          justifyContent: "space-between",
          alignItems: "center",
        }}
      >
        <View
          style={{
            flexDirection: "row",
            justifyContent: "center",
            height: "50%",
            width: "100%",
            alignItems: "center",
          }}
        >
          <View
            style={{
              flexDirection: "row",
              alignItems: "flex-end",
              width: "80%",
            }}
          >
            <HandCoins size={hp(5)} color={theme.colors.secondaryTextColor} />
            <View
              style={{
                marginLeft: wp(2),
              }}
            >
              <Text
                style={{
                  color: theme.colors.secondaryTextColor,
                  fontSize: hp(2),
                }}
              >
                Required Amount
              </Text>
              <Text
                style={{
                  color: theme.colors.secondaryTextColor,
                  fontSize: hp(2),
                }}
              >
                1200.00
              </Text>
            </View>
          </View>
        </View>
        <View
          style={{
            width: "80%",
            height: ".5%",
            justifyContent: "center",
            alignItems: "center",
            backgroundColor: theme.colors.primaryBgColor,
          }}
        />
        <View
          style={{
            flexDirection: "row",
            justifyContent: "center",
            height: "49.5%",
            width: "100%",
            alignItems: "center",
          }}
        >
          <View
            style={{
              flexDirection: "row",
              alignItems: "flex-end",
              width: "80%",
            }}
          >
            <Bitcoin size={hp(5)} color={theme.colors.secondaryTextColor} />
            <View
              style={{
                marginLeft: wp(2),
              }}
            >
              <Text
                style={{
                  color: theme.colors.secondaryTextColor,
                  fontSize: hp(2),
                }}
              >
                Riched Amount
              </Text>
              <Text
                style={{
                  color: theme.colors.secondaryTextColor,
                  fontSize: hp(2),
                }}
              >
                600.00
              </Text>
            </View>
          </View>
        </View>
      </View>
    </View>
  );
};

export default ProjectSavingCard;

const styles = StyleSheet.create({
  container: {
    // flex: 1, paddingHorizontal: wp(5),
    // paddingTop: hp(4
  },
  greeting: {
    fontSize: hp(2),
  },
  connectedUserName: {
    fontSize: hp(3),
    fontWeight: "bold",
  },
  topSide: {
    width: "100%",
    height: hp(30),
    paddingHorizontal: wp(5),
  },
  cardsContainer: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginTop: hp(2),
  },
  trasactionCard: {
    alignItems: "center",
    backgroundColor: "rgba(0, 0, 0, 0.25)",
    width: "35%",
    borderRadius: hp(1.5),
    justifyContent: "center",
  },
  seprator: {
    width: 1,
    height: "100%",
  },
  randomProjectCard: {
    height: hp(20),
    width: "100%",
    borderRadius: hp(4),
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
});
