import * as React from "react";
import Svg, { Line } from "react-native-svg";
import { hp, wp } from "@/helpers/ruler";

type PlusIconProps = {
  style?: object;
  color?: string;
  width?: number;
  height?: number;
};
const PlusIcon = ({ style, color, width, height }: PlusIconProps) => (
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
    className="feather feather-plus"
    style={style}
  >
    <Line x1={12} y1={5} x2={12} y2={19} />
    <Line x1={5} y1={12} x2={19} y2={12} />
  </Svg>
);
export default PlusIcon;
