import { hp, wp } from "@/helpers/ruler";
import * as React from "react";
import Svg, { Path, Polyline } from "react-native-svg";

type homeIconProps = {
  style?: object;
  color?: string;
  width?: number;
  height?: number;
};
const HomeIcon = ({ style, color, width, height }: homeIconProps) => (
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
    className="feather feather-home"
    style={style}
  >
    <Path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
    <Polyline points="9 22 9 12 15 12 15 22" />
  </Svg>
);
export default HomeIcon;
