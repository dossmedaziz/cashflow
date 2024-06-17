import * as React from "react";
import { hp, wp } from "@/helpers/ruler";
import Svg, { Path } from "react-native-svg";
type StatsIconProps = {
    style?: object;
    color?: string;
    width?: number;
    height?: number;
  };
const StatsIcon = ({ style, color, width, height } : StatsIconProps) => (
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
    className="feather feather-pie-chart"
    style={style}
  >
    <Path d="M21.21 15.89A10 10 0 1 1 8 2.83" />
    <Path d="M22 12A10 10 0 0 0 12 2v10z" />
  </Svg>
);
export default StatsIcon;
