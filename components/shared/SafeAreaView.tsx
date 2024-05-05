import React from "react";
import { SafeAreaView } from "react-native-safe-area-context";
import { useTheme } from "../../theme/useTheme";

type SafeAreaWrapperProps = {
  children: React.ReactNode;
};

const SafeAreaWrapper = ({ children }: SafeAreaWrapperProps) => {
    const { theme } = useTheme();
    return (
    <SafeAreaView
      style={{
        flex: 1,
        backgroundColor: theme.colors.primaryBgColor,
      }}
    >
      {children}
    </SafeAreaView>
  );
};

export default SafeAreaWrapper;