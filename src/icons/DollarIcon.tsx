import { hp, wp } from "@/helpers/ruler";
import * as React from "react";
import Svg, { Line, Path } from "react-native-svg";

type DollarIconType = {
  style?: object;
  color?: string;
  width?: number;
  height?: number;
};
const DollarIcon = ({ style, color, width, height }: DollarIconType) => (
  <Svg
    xmlns="http://www.w3.org/2000/svg"
    width={width || wp(7)}
    height={height || hp(4)}
    viewBox="0 0 24 24"
    fill="none"
    stroke={color || "#000000"}
    strokeWidth={2}
    strokeLinecap="round"
    strokeLinejoin="round"
    className="feather feather-dollar-sign"
    style={style}
  >
    <Line x1={12} y1={1} x2={12} y2={23} />
    <Path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6" />
  </Svg>
);
export default DollarIcon;
