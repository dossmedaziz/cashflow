import { View,Text } from "react-native";
import {SafeAreaWrapper}from '@/components';
import { Pie,PolarChart } from "victory-native";

const StatsScreen = () => {

    
    function MyChart() {
      return (
        <View style={{ height: 300 }}>
          <PolarChart
            data={DATA(5)} // 👈 specify your data
            labelKey={"label"} // 👈 specify data key for labels
            valueKey={"value"} // 👈 specify data key for values
            colorKey={"color"} // 👈 specify data key for color
          >
            <Pie.Chart />
          </PolarChart>
        </View>
      );
    }
    
    function randomNumber() {
      return Math.floor(Math.random() * 26) + 125;
    }
    function generateRandomColor(): string {
      // Generating a random number between 0 and 0xFFFFFF
      const randomColor = Math.floor(Math.random() * 0xffffff);
      // Converting the number to a hexadecimal string and padding with zeros
      return `#${randomColor.toString(16).padStart(6, "0")}`;
    }
    const DATA = (numberPoints = 5) =>
      Array.from({ length: numberPoints }, (_, index) => ({
        value: randomNumber(),
        color: generateRandomColor(),
        label: `Label ${index + 1}`,
      }))
    return (
        <SafeAreaWrapper>
   <View style={{ height: 300 }}>
      <PolarChart
        data={DATA()} // 👈 specify your data
        labelKey={"label"} // 👈 specify data key for labels
        valueKey={"value"} // 👈 specify data key for values
        colorKey={"color"} // 👈 specify data key for color
      >
        <Pie.Chart />
      </PolarChart>
    </View>
        </SafeAreaWrapper>
    )
};


export default StatsScreen;