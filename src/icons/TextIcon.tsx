import { hp, wp } from "@/helpers/ruler";
import * as React from "react";
import Svg, { Polyline, Line } from "react-native-svg";
type TextIconType = {
  style?: object;
  color?: string;
  width?: number;
  height?: number;
};
const TextIcon = ({ style, color, width, height }: TextIconType) => (
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
    className="feather feather-type"
    style={style}
  >
    <Polyline points="4 7 4 4 20 4 20 7" />
    <Line x1={9} y1={20} x2={15} y2={20} />
    <Line x1={12} y1={4} x2={12} y2={20} />
  </Svg>
);
export default TextIcon;
