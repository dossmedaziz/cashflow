import { hp, wp } from "@/helpers/ruler";
import * as React from "react";
import Svg, { Path, Polyline } from "react-native-svg";
type EmailIconProps = {
  style?: object;
  color?: string;
  width?: number;
  height?: number;
};
const EmailIcon = ({ style, color, width, height }: EmailIconProps) => (
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
    className="feather feather-mail"
    style={style}
  >
    <Path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
    <Polyline points="22,6 12,13 2,6" />
  </Svg>
);
export default EmailIcon;
