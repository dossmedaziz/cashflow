import * as React from "react";
import Svg, { Polyline } from "react-native-svg";
import { hp, wp } from "@/helpers/ruler";
type CheckIconProps = {
  style?: object;
  color?: string;
  width?: number;
  height?: number;
};
const Checkicon = ({ color, height, style, width }: CheckIconProps) => (
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
    className="feather feather-check"
    style={style}
  >
    <Polyline points="20 6 9 17 4 12" />
  </Svg>
);
export default Checkicon;
