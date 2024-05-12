import { hp, wp } from "@/helpers/ruler";
import * as React from "react";
import Svg, { Path } from "react-native-svg";
type EmailIconProps = {
  style?: object;
  color?: string;
  width?: number;
  height?: number;
};
const EmailIcon = ({ style, color, width, height }: CloseEyeIconProps) => (
  <Svg
    xmlns="http://www.w3.org/2000/svg"
    width={width || wp(7)}
    height={height || hp(4)}
    viewBox="0 0 24 24"
    fill="none"
    stroke={color || "#000000"}
    strokeWidth={2}
    style={style}
  >
    <Path
      d="M4 4H20C21.1 4 22 4.9 22 6V18C22 19.1 21.1 20 20 20H4C2.9 20 2 19.1 2 18V6C2 4.9 2.9 4 4 4Z"
      stroke="black"
      strokeWidth={2}
      strokeLinecap="round"
      strokeLinejoin="round"
    />
    <Path
      d="M22 6L12 13L2 6"
      stroke="black"
      strokeWidth={2}
      strokeLinecap="round"
      strokeLinejoin="round"
    />
  </Svg>
);
export default EmailIcon;
