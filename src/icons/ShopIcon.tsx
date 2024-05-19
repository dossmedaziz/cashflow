import { hp, wp } from "@/helpers/ruler";
import * as React from "react";
import Svg, { Circle, Path } from "react-native-svg";

type ShopCartIconProps = {
  style?: object;
  color?: string;
  width?: number;
  height?: number;
};
const ShopCartIcon = ({ style, color, width, height }: ShopCartIconProps) => (
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
    className="feather feather-shopping-cart"
    style={style}
  >
    <Circle cx={9} cy={21} r={1} />
    <Circle cx={20} cy={21} r={1} />
    <Path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6" />
  </Svg>
);
export default ShopCartIcon;
