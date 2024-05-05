import { createContext, useContext, useState } from "react";
import Colors from "./colors";


type ThemeProviderProps = {
  children: React.ReactNode;
};
const ThemeContext = createContext(null);
const defaultTheme = "light";
export const ThemeProvider = ({ children }: ThemeProviderProps) => {
  const [theme, setTheme] = useState<string>(defaultTheme);
  const sharedState = {
    theme: {
      colors: Colors[theme],
    },
    setTheme,
  };
  return (
    <ThemeContext.Provider value={sharedState}>
      {children}
    </ThemeContext.Provider>
  );
};

export const useTheme = () => {
  return useContext(ThemeContext);
};

export default ThemeProvider;
