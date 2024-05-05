import { hp, wp } from "@/helpers/ruler";
import * as React from "react";
import Svg, { G, Path, Defs, ClipPath, Rect, Line } from "react-native-svg";

type CloseEyeIconProps = {
  style?: object;
  color?: string;
  width?: number;
  height?: number;
};
const CloseEyeIcon = ({ style, color, width, height }: CloseEyeIconProps) => (
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
    className="feather feather-eye-off"
    style={style}
  >
    <Path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24" />
    <Line x1={1} y1={1} x2={23} y2={23} />
  </Svg>
);
export default CloseEyeIcon;
