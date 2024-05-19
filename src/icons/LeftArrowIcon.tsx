import { hp, wp } from "@/helpers/ruler";
import * as React from "react";
import Svg, { Line, Polyline } from "react-native-svg";
type LeftArrowIconProps = {
  style?: object;
  color?: string;
  width?: number;
  height?: number;
};
const LeftArrowIcon = ({ style, color, width, height }: LeftArrowIconProps) => (
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
    className="feather feather-arrow-left"
    style={style}
  >
    <Line x1={19} y1={12} x2={5} y2={12} />
    <Polyline points="12 19 5 12 12 5" />
  </Svg>
);
export default LeftArrowIcon;
